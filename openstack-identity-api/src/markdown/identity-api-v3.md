OpenStack Identity API v3
=========================

General Themes
--------------

The general theme of this proposal is a broad CRUD based API supporting
authentication and authorization needs in OpenStack. Back-end implementations
of the Identity API may not support all components of the API, hence an API may
return HTTP 501 Not Implemented. This is to support the Identity API as a
programmatic facade to a deployment’s existing authentication and authorization
system(s).

Themes for changes:

- different style of pagination that I hope will be more effective for UI work
- consolidate CRUD operations currently in contrib into CORE
- adding a "url" resource attribute that's the fully qualified resource
  location for the identity service
- added domains (collections of projects)
- restructure role API calls to be specific to user->project or user->domain
- tokens are now very explicit to user+project combinations
- new API mechanisms to get projects associated with a user
- generalized credentials associated with a user/project combo (ec2, pki, ssh
  keys, etc)
- renamed "tenant" to "project"

### Querying by Attribute

From an interaction perspective, the REST resource should contain a canonically
unique identifier; that means the id in this case. Since not all resource
attributes are guaranteed unique on their own this is actually a filter query,
and needs to be addressed as such. Filter params definitely belong in GET
request params. So something like GET /users?name=foo is the most valid. This
should is also extensible to multiple params `GET /users?name=foo&enabled=1`.

There were several requests for querying to related objects through this
mechanism, and I'd like to suss out how to properly arrange this with this
draft, potentially including them as we get into the meat of development.

### PKI Support

After reviewing our current PKI approach, I'm pretty sure everything is
backwards compatible with our existing token API, with the *potential*
exception of the length of his "tokens" being too long for some tools to handle
as valid URL's or header values.

A base64 encoded PKI token lands in the 1-2KB range, in his examples. This
encrypted token can be handled as *unencrypted* by both clients and services
that do not understand/support PKI (you can still GET /tokens/{token_id} the
entire thing as an opaque string, and still pass it in an X-Auth-Token, etc).

Signed tokens can still have an ID,  so the concept of ID:value for tokens will
work well. The only thing that won't work is putting the signed tokens into the
URL, and the avoiding-token-in-urls scheme obviates that.

### Resources and Resource Structure

Resource names are kept plural in this edition of the API, with identity or
listing with a filter being provided by querying by attributes or an additional
identifier in the URI. Resources are kept separate in the URI structure except
where there is a clear hierarchy to be represented.

### REST Verbs

This API uses the PATCH verb extensively, intended for that to be able to make
"partial updates" to resource attributes.

### Deployment

TCP port 35357 is designated by the Internet Assigned Numbers Authority
("IANA") for use by OpenStack Identity services. Example API requests &
responses in this document therefore assume that the Identity service
implementation is deployed at the root of `http://identity:35357/`.

API Resources
-------------

### Users

- represent individual users
- are associated with 0 or more projects (users are not exclusive to a project)
- A user associated with no projects is useless from the perspective of
  OpenStack and should not ever be authenticated to any resources. It is
  allowed, however, to create a workflow means of acquiring or loading users
  from other resources and mapping them to projects.
- can be associated with one or more projects, and therefore can also be in one
  or more domains, the association of the domain being strictly though the
  projects that user is associated with.
- project_id on a user resource represents a ‘default’ project, to be used with
  authorization and validation calls later described in this API. If no
  project_id is provided to these calls, the user’s "project_id" is used as a
  default.

Resource attributes:

- id (globally unique - PRIMARY KEY/resource ID)
- name (globally unique)
- url (fully qualified resource URL)
- enabled (optional)
- password (optional)
- description (optional)
- email (optional)
- project_id (optional)
- domain_id (optional)

### Credentials

- arbitrary credentials associated with a user
- a user may have 0 or more credentials associated
- The type is a string, with the idea that an initially supported type will be
  "ec2", but that more credentials could be supported in the future.

Resource attributes:

- id (globally unique - PRIMARY KEY/resource ID)
- type (string) [ec2|access_key]
- url (fully qualified resource URL)
- project_id (optional)
- data (blob of data)

### Projects

base unit of "ownership" in OpenStack
may have 0 or more users
always associated with a single domain
A project can not be in two domains at once
roles may be granted to a user on a specific project

Resource attributes:

- id (globally unique - PRIMARY KEY/resource ID)
- name (globally unique)
- domain_id (globally unique)
- url (fully qualified resource URL)
- enabled (boolean: True or False)

### Domains

- a collection of projects (no project may be in two domains at once)
- roles may be granted to a user within a domain

Resource attributes:

- name (globally unique - PRIMARY KEY/resource ID)
- description (user facing description)
- id (globally unique)
- url (fully qualified resource URL)
- enabled (boolean: True or False)

### Roles

- a user-facing named identifier that is used to map a collection of actions
  from a user to either a specific project or an entire domain.

Resource attributes:

- id (globally unique - PRIMARY KEY/resource ID)
- name (globally unique)
- url (fully qualified resource URL)

### Service

- an API endpoint for an OpenStack service
- may have 0 or more policies associated with it
- may have 0 or more endpoints associated with it (although a service with 0
  endpoints associated with it is useless in an OpenStack configuration)

Resource attributes:

- id (globally unique - PRIMARY KEY/resource ID)
- type [compute|image|ec2|identity|volume|network]

### Endpoint

- the "extra" resource attribute is intended to allow for additional tags or
  attributes associated with the endpoint to allow implementations to map
  regionality or location if it’s appropriate for their environment.
- "region" is intended to be implementation specific in meaning, but in general
  represents a geographical location to the service endpoint if such is
  relevant to the deployment.

Resource attributes:

- id (globally unique - PRIMARY KEY/resource ID)
- service_id (globally unique)
- name (optional, user facing description)
- interface [public|admin|internal]
- region (optional)
- extra (optional) - json blob
- url (fully qualified resource URL)

### Tokens

- an authN/Z representation of a user/project pair with an expiration
- passed between client and service APIs in HTTP request headers

Resource attributes:

- id (globally unique - PRIMARY KEY/resource ID)
- expires (iso8601 timestamp)
- user (full resource description, see User resource above)
- project (full resource description, see project resource above)
- catalog (full description of all endpoints available to/for the token)
- url (fully qualified resource URL)

### Policy

- associated with a single endpoint

Resource attributes:

- id (globally unique - PRIMARY KEY/resource ID)
- endpoint_id
- blob policy (serialized blob)
- type (serialization MIME type)
- url (fully qualified resource URL)

Core API
--------

### Versions

#### List versions; `GET /`

(TBD: This needs additional definition to match the detail below)

### Tokens

The key use cases we need to cover:

- given a user name & password, get a token to represent the user
- given a token, get a list of other projects the user can access
- given a token ID, validate the token and return user, project, roles, and
  potential endpoints.
- given a valid token, request another token with a different project (change
  project being represented with the user)
- forced expiration of a token

The "just a token" has been the starting requirement, and with PKI coming
online, it provides a resource path for the tokens independent of linkages to
anything else.

Multiple POST variations are available to authenticate and request and Token
resource.

#### Authenticate: `POST /tokens`

For the use case where we are providing a username and password, optionally
with a project_name or project_id. If a project_name or project_id is NOT
provided, the system will use the default project associated with the user, or
return a 401 Not Authorized if a default project is not found or unable to be
used.

Request:

    {
        "auth": {
            "password_credentials": {
                "username": "--user-name--",
                "password": "--password--",
                "user_id": "--optional-user-id--"
            },
        "project_name": "--optional-project-name--",
        "project_id": "--optional-project-id--"
        }
    }

For the use case where we already have a token, but are requesting
authorization to a different project_id. If project_id or project_name is not
specified, default_project will be used.

Request:

    {
        "auth": {
            "project_id": "--optional-project-id--",
            "project_name": "--optional-project-name--",
            "token": {
                "id": "--token-id--"
            }
        }
    }

Response:

    Status: 200
    Location: https://identity:35357/v3/tokens/--token-id--

    {
        "project": {
            "domain": {
                "enabled": true,
                "id": "...",
                "name": "..."
            },
            "enabled": true,
            "id": "...",
            "name": "..."
        },
        "services": [
            {
                "endpoints": [
                    {
                        "extra": {},
                        "facing": "public",
                        "id": "--endpoint-id--",
                        "name": null,
                        "region": "RegionOne",
                        "url": "http://external:8776/v1/--project-id--"
                    },
                    {
                        "extra": {},
                        "facing": "internal",
                        "id": "--endpoint-id--",
                        "name": null,
                        "region": "RegionOne",
                        "url": "http://internal:8776/v1/--project-id--"
                    }
                ],
                "id": "--service-id--",
                "type": "volume"
            },
            {
                "endpoints": [
                    {
                        "facing": "public",
                        "id": "--endpoint-id--",
                        "name": null,
                        "region": "RegionOne",
                        "url": "http://external:9292/v1"
                    },
                    {
                        "facing": "internal",
                        "id": "--endpoint-id--",
                        "name": null,
                        "region": "RegionOne",
                        "url": "http://internal:9292/v1"
                    }
                ],
                "id": "--service-id--",
                "type": "identity"
            }
        ],
        "token": {
            "expires": "2012-06-18T20:08:53Z",
            "id": "--token-id--"
        },
        "user": {
            "description": "a domain administrator",
            "id": "766f3f4235fa468588e30f31157eb9ac",
            "name": "admin",
            "project_id": "--default-project-id--",
            "roles": [
                {
                    "id": "...",
                    "name": "Member",
                    "project_id": "c5271357278e4a2094a96e0e6856c5cf"
                },
                {
                    "description": "desc of domain...",
                    "domain_id": "0ab841c666284a7ca5941f2471019074",
                    "id": "...",
                    "name": "Admin"
                }
            ],
            "roles_links": []
        }
    }

Failure response (example - additional failure cases are quite possible, including 403 Forbidden and 409 Conflict):

    Status: 401 Not Authorized

    {
        "error": {
            "code": 401,
            "message": "The request you have made requires authentication",
            "title": "Not Authorized"
        }
    }

#### Validate token: `GET /tokens`

- token to be used to validate the call in X-Auth-Token HTTP header
- token to be validated is set in X-Subject-Token HTTP header

Response:

    Status: 200 OK

    {
        "catalog": [
            {
                "service": {
                    "endpoints": [
                        {
                            "extra": {},
                            "facing": "public",
                            "id": "--endpoint-id--",
                            "name": null,
                            "region": "RegionOne",
                            "url": "http://external:8776/v1/--project-id--"
                        },
                        {
                            "extra": {},
                            "facing": "internal",
                            "id": "--endpoint-id--",
                            "name": null,
                            "region": "RegionOne",
                            "url": "http://internal:8776/v1/--project-id--"
                        }
                    ],
                    "id": "--service-id--",
                    "name": "volume"
                }
            },
            {
                "service": {
                    "endpoints": [
                        {
                            "facing": "public",
                            "id": "--endpoint-id--",
                            "name": null,
                            "region": "RegionOne",
                            "url": "http://external:9292/v1"
                        },
                        {
                            "facing": "internal",
                            "id": "--endpoint-id--",
                            "name": null,
                            "region": "RegionOne",
                            "url": "http://internal:9292/v1"
                        }
                    ],
                    "id": "--service-id--",
                    "name": "identity"
                }
            }
        ],
        "project": {
            "domain": {
                "enabled": true,
                "id": "--domain-id--",
                "name": "--domain-name--"
            },
            "enabled": true,
            "id": "--project-id--",
            "name": "--project-name--"
        },
        "token": {
            "expires": "2012-06-18T20:08:53Z",
            "id": "--token-id--",
            "project": {
                "description": null,
                "enabled": true,
                "id": "--project-id--",
                "name": "admin"
            }
        },
        "user": {
            "description": "a domain administrator",
            "id": "--user-id--",
            "name": "admin",
            "project_id": "--default-project-id--",
            "roles": [
                {
                    "id": "--role-id--",
                    "name": "--role-name--",
                    "project_id": "--project-id--"
                },
                {
                    "domain_id": "--domain-id--",
                    "id": "--role-id--",
                    "name": "--role-name--"
                }
            ],
            "roles_links": []
        }
    }

#### Check token: `HEAD /tokens`

- token to be used to validate the call in X-Auth-Token HTTP header
- token to be validated is set in X-Subject-Token HTTP header

Response:

    Status: 200 OK

Failure response:

    Status: 401 Not Authorized

    {
        "error": {
            "code": 401,
            "message": "The request you have made requires authentication",
            "title": "Not Authorized"
        }
    }

#### Remove token: `DELETE /tokens`

- token to be used to validate the call in X-Auth-Token
- token to be deleted is set in X-Subject-Token HTTP header

Response:

    Status: 204 No Content

### Catalog

The key use cases we need to cover:

- CRUD for services and endpoints
- retrieving the endpoints of a given service, and/or with a given facing service

#### List services: `GET /services`

Response:

    Status: 200 OK

    [
        {
            "id": "--service-id--",
            "link": {
                "href": "http://identity:35357/v3/services/--service-id--",
                "rel": "self"
            },
            "type": "volume"
        },
        {
            "id": "--service-id--",
            "link": {
                "href": "http://identity:35357/v3/services/--service-id--",
                "rel": "self"
            },
            "type": "identity"
        }
    ]


#### Get service: `GET /services/{service_id}`

Response:

    Status: 200 OK

    {
        "id": "--service-id--",
        "link": {
            "href": "http://identity:35357/v3/services/--service-id--",
            "rel": "self"
        },
        "type": "volume"
    }

#### Create service: `POST /services`

Request:

    {
        "type": "..."
    }

Response:

    Status: 201 Created
    Location: https://identity:35357/v3/services/--service-id--

    {
        "service": {
            "id": "--service-id--",
            "type": "volume"
        }
    }

#### Update service: `PATCH /services/{service_id}`

Response:

    Status: 200 OK

    {
        "service": {
            "id": "--service-id--",
            "type": "volume"
        }
    }

#### Delete service: `DELETE /services/{service_id}`

* Note: deleting a service when endpoints exist should either 1) delete all
  associated endpoints or 2) fail until endpoints are deleted

Response:

    Status: 204 No Content

### Endpoints

#### List endpoints: `GET /endpoints`

Response:

    Status: 200 OK

    [
        {
            "extra": {},
            "facing": "public",
            "id": "--endpoint-id--",
            "link": {
                "href": "http://identity:35357/v3/endpoints/--endpoint-id--",
                "rel": "self"
            },
            "name": "the public volume endpoint",
            "service_id": "--service-id--"
        },
        {
            "extra": {},
            "facing": "internal",
            "id": "--endpoint-id--",
            "link": {
                "href": "http://identity:35357/v3/endpoints/--endpoint-id--",
                "rel": "self"
            },
            "name": "the internal volume endpoint",
            "service_id": "--service-id--"
        }
    ]

#### Create endpoint: `POST /endpoints`

Request:

    {
        "extra": "--json-blob--",
        "facing": "[admin|public|internal]",
        "name": "name",
        "url": "..."
    }

Response:

    Status: 201 Created
    Location: https://identity:35357/v3/endpoints/--endpoint-id--

    {
        "extra": {},
        "facing": "internal",
        "id": "--endpoint-id--",
        "link": {
            "href": "http://identity:35357/v3/endpoints/--endpoint-id--",
            "rel": "self"
        },
        "name": "the internal volume endpoint",
        "service_id": "--service-id--"
    }


#### Update endpoint: `PATCH /endpoints/{endpoint_id}`

Response:

    Status: 200 OK

    {
        "extra": {},
        "facing": "internal",
        "id": "--endpoint-id--",
        "link": {
            "href": "http://identity:35357/v3/endpoints/--endpoint-id--",
            "rel": "self"
        },
        "name": "the internal volume endpoint",
        "service_id": "--service-id--"
    }

#### Delete endpoint: `DELETE /endpoints/{endpoint_id}`

Response:

    Status: 204 No Content

## Identity

The key use cases we need to cover:

- CRUD on a user
- associating a user with a project
- CRUD on a domain
- CRUD on a project

### Domains

#### Create domain: `POST /domains`

Request:

    {
        "description": "",
        "enabled": "",
        "name": ""
    }

Response:

    Status: 201 Created
    Location: https://identity:35357/v3/domains/--domain-id--

    {
        "description": "desc of domain",
        "enabled": true,
        "id": "--domain-id--",
        "link": {
            "href": "http://identity:35357/v3/domains/--domain-id--",
            "rel": "self"
        },
        "name": "my domain"
    }

#### List domains: `GET /domains`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name" and "enabled" (optional)

Response:

    Status: 200 OK

    [
        {
            "description": "desc of domain",
            "enabled": true,
            "id": "--domain-id--",
            "link": {
                "href": "http://identity:35357/v3/domains/--domain-id--",
                "rel": "self"
            },
            "name": "my domain"
        },
        {
            "description": "desc of another domain",
            "enabled": true,
            "id": "--domain-id--",
            "link": {
                "href": "http://identity:35357/v3/domains/--domain-id--",
                "rel": "self"
            },
            "name": "another domain"
        }
    ]

#### Get domain: `GET /domains/{domain_id}`

Response:

    Status: 200 OK

    {
        "description": "desc of domain",
        "enabled": true,
        "id": "--domain-id--",
        "link": {
            "href": "http://identity:35357/v3/domains/--domain-id--",
            "rel": "self"
        },
        "name": "my domain"
    }

#### Update domain: `PATCH /domains/{domain_id}`

Response:

    Status: 200 OK

    {
        "description": "desc of domain",
        "enabled": true,
        "id": "--domain-id--",
        "link": {
            "href": "http://identity:35357/v3/domains/--domain-id--",
            "rel": "self"
        },
        "name": "my domain"
    }

#### Delete domain: `DELETE /domains/{domain_id}`

Response:

    Status: 204 No Content

#### Get domain projects: `GET /domains/{domain_id}/projects`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name", "enabled", or "domain_id" (optional)

Response:

    Status: 200 OK

    [
        {
            "domain_id": "--domain-id--",
            "enabled": true,
            "id": "--project-id--",
            "link": {
                "href": "http://identity:35357/v3/projects/--project-id--",
                "rel": "self"
            },
            "name": "a project name"
        },
        {
            "domain_id": "--domain-id--",
            "enabled": true,
            "id": "--domain-id--",
            "link": {
                "href": "http://identity:35357/v3/projects/--project-id--",
                "rel": "self"
            },
            "name": "another domain"
        }
    ]

#### Get domain users: `GET /domains/{domain_id}/users`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name", "enabled", "email" (optional)

Response:

    Status: 200 OK

    [
        {
            "description": "a user",
            "email": "...",
            "enabled": true,
            "id": "--user-id--",
            "link": {
                "href": "http://identity:35357/v3/users/--user-id--",
                "rel": "self"
            },
            "name": "admin",
            "project_id": "--default-project-id--"
        },
        {
            "description": "another user",
            "email": "...",
            "enabled": true,
            "id": "--user-id--",
            "link": {
                "href": "http://identity:35357/v3/users/--user-id--",
                "rel": "self"
            },
            "name": "someone",
            "project_id": "--default-project-id--"
        }
    ]

### Projects

#### Create project: `POST /projects`

Request:

    {
        "description": "...",
        "domain_id": "...",
        "enabled": "...",
        "name": "..."
    }

Response:

    Status: 201 Created
    Location: http://identity:35357/v3/projects/--project-id--

    {
        "domain_id": "--domain-id--",
        "enabled": true,
        "id": "--project-id--",
        "link": {
            "href": "http://identity:35357/v3/projects/--project-id--",
            "rel": "self"
        },
        "name": "a project name"
    }

#### List projects: `GET /projects`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name", "enabled", or "domain_id" (optional)

Response:

    Status: 200 OK

    [
        {
            "domain_id": "--domain-id--",
            "enabled": true,
            "id": "--project-id--",
            "link": {
                "href": "http://identity:35357/v3/projects/--project-id--",
                "rel": "self"
            },
            "name": "a project name"
        },
        {
            "domain_id": "--domain-id--",
            "enabled": true,
            "id": "--project-id--",
            "link": {
                "href": "http://identity:35357/v3/projects/--project-id--",
                "rel": "self"
            },
            "name": "another domain"
        }
    ]

#### Get project: `GET /projects/{project_id}`

Response:

    Status: 200 OK

    {
        "domain_id": "--domain-id--",
        "enabled": true,
        "id": "--project-id--",
        "link": {
            "href": "http://identity:35357/v3/projects/--project-id--",
            "rel": "self"
        },
        "name": "a project name"
    }

#### Update project: `PATCH /projects/{project_id}`

Response:

    Status: 200 OK

    {
        "domain_id": "--domain-id--",
        "enabled": true,
        "id": "--project-id--",
        "link": {
            "href": "http://identity:35357/v3/projects/--project-id--",
            "rel": "self"
        },
        "name": "a project name"
    }

#### Delete project: `DELETE /projects/{project_id}`

    Status: 204 No Content

#### List project users: `GET /projects/{project_id}/users`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name", "enabled", "email" on user resources (optional)

Response:

    Status: 200 OK

    [
        {
            "description": "a user",
            "email": "...",
            "enabled": true,
            "id": "--user-id--",
            "link": {
                "href": "http://identity:35357/v3/users/--user-id--",
                "rel": "self"
            },
            "name": "admin",
            "project_id": "--default-project-id--"
        },
        {
            "description": "another user",
            "email": "...",
            "enabled": true,
            "id": "--user-id--",
            "link": {
                "href": "http://identity:35357/v3/users/--user-id--",
                "rel": "self"
            },
            "name": "someone",
            "project_id": "--default-project-id--"
        }
    ]

### Users

#### Create user: `POST /users`

Request:

    {
        "description": "...",
        "email": "...",
        "enabled": "...",
        "name": "...",
        "password": "--optional--",
        "project_id": "..."
    }

Response:

    Status: 201 Created
    Location: http://identity:35357/v3/users/--user-id--

    {
        "description": "a user",
        "email": "...",
        "enabled": true,
        "id": "--user-id--",
        "link": {
            "href": "http://identity:35357/v3/users/--user-id--",
            "rel": "self"
        },
        "name": "admin",
        "project_id": "--default-project-id--"
    }

#### Get users: `GET /users`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name", "enabled", "email" (optional)

Response:

    Status: 200 OK

    [
        {
            "description": "a user",
            "email": "...",
            "enabled": true,
            "id": "--user-id--",
            "link": {
                "href": "http://identity:35357/v3/users/--user-id--",
                "rel": "self"
            },
            "name": "admin",
            "project_id": "--default-project-id--"
        },
        {
            "description": "another user",
            "email": "...",
            "enabled": true,
            "id": "--user-id--",
            "link": {
                "href": "http://identity:35357/v3/users/--user-id--",
                "rel": "self"
            },
            "name": "someone",
            "project_id": "--default-project-id--"
        }
    ]

#### Get user: `GET /users/{user_id}`

Response:

    Status: 200 OK

    {
        "description": "a user",
        "email": "...",
        "enabled": true,
        "id": "--user-id--",
        "link": {
            "href": "http://identity:35357/v3/users/--user-id--",
            "rel": "self"
        },
        "name": "admin",
        "project_id": "--default-project-id--"
    }

#### List user projects: `GET /users/{user_id}/projects`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name", "enabled" on project resources (optional)

Response:

    Status: 200 OK

    [
        {
            "domain_id": "--domain-id--",
            "enabled": true,
            "id": "--project-id--",
            "link": {
                "href": "http://identity:35357/v3/projects/--project-id--",
                "rel": "self"
            },
            "name": "a project name"
        },
        {
            "domain_id": "--domain-id--",
            "enabled": true,
            "id": "--project-id--",
            "link": {
                "href": "http://identity:35357/v3/projects/--project-id--",
                "rel": "self"
            },
            "name": "another domain"
        }
    ]

#### Update user: `PATCH /users/{user_id}`

Use this method attempt to update user password or enable/disable the user.
This may return a HTTP 501 Not Implemented if the back-end driver doesn’t allow
for the functionality.

Response:

    Status: 200 OK

    {
        "description": "a user",
        "email": "...",
        "enabled": true,
        "id": "--user-id--",
        "link": {
            "href": "http://identity:35357/v3/users/--user-id--",
            "rel": "self"
        },
        "name": "admin",
        "project_id": "--default-project-id--"
    }

#### Delete user: `DELETE /users/{user_id}`

Response:

    Status: 204 No Content

### Credentials

The key use cases we need to cover:

- CRUD on a credential

#### Create credential: `POST /credentials`

This example shows creating an EC2 style credential where the credentials are a
combination of access_key and secret. Other credentials (such as access_key)
may be supported by simply changing the content of the key data.

Request:

    {
        "data": {
            "access": "...",
            "secret": "..."
        },
        "project_id": "",
        "type": "ec2"
    }

Response:

    Status: 201 Created
    Location: http://identity:35357/v3/credentials/--credential-id--

    {
        "data": {
            "access": "...",
            "secret": "..."
        },
        "id": "--credential-id--",
        "link": {
            "href": "http://identity:35357/v3/credentials/--credential-id--",
            "rel": "self"
        },
        "project_id": "--project-id--",
        "type": "ec2"
    }

#### Get credentials: `GET /credentials`

query_string: page (optional)
query_string: per_page (optional, default 30)

Response:

    Status: 200 OK

    [
        {
            "data": {
                "access": "...",
                "secret": "..."
            },
            "id": "--credential-id--",
            "link": {
                "href": "http://identity:35357/v3/credentials/--credential-id--",
                "rel": "self"
            },
            "project_id": "--project-id--",
            "type": "ec2"
        },
        {
            "data": {
                "access": "...",
                "secret": "..."
            },
            "id": "--credential-id--",
            "link": {
                "href": "http://identity:35357/v3/credentials/--credential-id--",
                "rel": "self"
            },
            "project_id": "--project-id--",
            "type": "ec2"
        }
    ]

#### Get credential: `GET /credentials/{credential_id}`

Response:

    Status: 200 OK

    {
        "data": {
            "access": "...",
            "secret": "..."
        },
        "id": "--credential-id--",
        "link": {
            "href": "http://identity:35357/v3/credentials/--credential-id--",
            "rel": "self"
        },
        "project_id": "--project-id--",
        "type": "ec2"
    }

#### Delete credential: `DELETE /credentials/{credential_id}`

Response:

    Status: 204 No Content

### Roles

The key use cases we need to cover:

- CRUD on a role
- Associating a role with a project or domain

#### Create role: `POST /roles`

Request:

    {
        "name": ""
    }

Response:

    Status: 201 Created
    Location: http://identity:35357/v3/roles/--role-id--

    {
        "id": "--role-id--",
        "link": {
            "href": "http://identity:35357/v3/roles/--role-id--",
            "rel": "self"
        },
        "name": "a role name"
    }

#### List roles: `GET /roles`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name" (optional)

Response:

    Status: 200 OK

    [
        {
            "id": "--role-id--",
            "link": {
                "href": "http://identity:35357/v3/roles/--role-id--",
                "rel": "self"
            },
            "name": "a role name"
        },
        {
            "id": "--role-id--",
            "link": {
                "href": "http://identity:35357/v3/roles/--role-id--",
                "rel": "self"
            },
            "name": "a role name"
        }
    ]

#### Get role: `GET /roles/{role_id}`

Response:

    Status: 200 OK

    {
        "id": "--role-id--",
        "link": {
            "href": "http://identity:35357/v3/roles/--roles-id--",
            "rel": "self"
        },
        "name": "a role name"
    }

#### Update role: `PATCH /roles/{role_id}`

Response:

    Status: 200 OK

    {
        "id": "--role-id--",
        "link": {
            "href": "http://identity:35357/v3/roles/--roles-id--",
            "rel": "self"
        },
        "name": "a role name"
    }

#### Get users with role: `GET /roles/{role_id}/users`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name", "enabled", "email" (optional)

Response:

    Status: 200 OK

    [
        {
            "description": "a user",
            "email": "...",
            "enabled": true,
            "id": "--user-id--",
            "link": {
                "href": "http://identity:35357/v3/users/--user-id--",
                "rel": "self"
            },
            "name": "admin",
            "project_id": "--default-project-id--"
        },
        {
            "description": "another user",
            "email": "...",
            "enabled": true,
            "id": "--user-id--",
            "link": {
                "href": "http://identity:35357/v3/users/--user-id--",
                "rel": "self"
            },
            "name": "someone",
            "project_id": "--default-project-id--"
        }
    ]

#### Delete role: `DELETE /roles/{role_id}`

Response:

    Status: 204 No Content

#### Get user roles: `GET /users/{user_id}/roles`

query_string: page (optional)
query_string: per_page (optional, default 30)

Response:

    Status: 200 OK

    [
        {
            "id": "--role-id--",
            "name": "--role-name--",
            "project_id": "--project-id--"
        },
        {
            "domain_id": "--domain-id--",
            "id": "--role-id--",
            "name": "--role-name--"
        }
    ]

#### Add project role to user: `PUT /projects/{project_id}/users/{user_id}/roles/{role_id}`

Response:

    Status: 201 Created

    {
        "id": "--role-id--",
        "name": "--role-name--",
        "project_id": "--project-id--"
    }

#### Add domain role to user: `PUT /domains/{domain_id}/users/{user_id}/roles/{role_id}`

Response:

    Status: 201 Created

    {
        "domain_id": "--domain-id--",
        "id": "--role-id--",
        "name": "--role-name--"
    }

#### Delete role from user: `DELETE /users/{user_id}/roles/{role_id}`

    Status: 204 No Content

### Policies

The key use cases we need to cover:

- CRUD on a policy

#### Create policy: `POST /policies`

Request:

    {
        "blob": "--serialized-blob--",
        "endpoint_id": "--endpoint-id--",
        "type": "--serialization-mime-type--"
    }

Response:

    Status: 201 Created
    Location: http://identity:35357/v3/policies/--policy-id--

    {
        "blob": "--serialized-blob--",
        "endpoint_id": "--endpoint-id--",
        "id": "--policy-id--",
        "link": {
            "href": "http://identity:35357/v3/policies/--policy-id--",
            "rel": "self"
        },
        "type": "--serialization-mime-type--"
    }

#### List policies: `GET /policies`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "service_name", "service_id", "endpoint_id" (optional)

Response:

    Status: 200 OK

    [
        {
            "blob": "--serialized-blob--",
            "endpoint_id": "--endpoint-id--",
            "id": "--policy-id--",
            "link": {
                "href": "http://identity:35357/v3/policies/--policy-id--",
                "rel": "self"
            },
            "type": "--serialization-mime-type--"
        },
        {
            "blob": "--serialized-blob--",
            "endpoint_id": "--endpoint-id--",
            "id": "--policy-id--",
            "link": {
                "href": "http://identity:35357/v3/policies/--policy-id--",
                "rel": "self"
            },
            "type": "--serialization-mime-type--"
        }
    ]

#### Get policy: `GET /policies/{policy_id}`

Response:

    Status: 200 OK

    {
        "blob": "--serialized-blob--",
        "endpoint_id": "--endpoint-id--",
        "id": "--policy-id--",
        "link": {
            "href": "http://identity:35357/v3/policies/--policy-id--",
            "rel": "self"
        },
        "type": "--serialization-mime-type--"
    }

#### Update policy: `PATCH /policies/{policy_id}`

Response:

    Status: 200 OK

    {
        "blob": "--serialized-blob--",
        "endpoint_id": "--endpoint-id--",
        "id": "--policy-id--",
        "link": {
            "href": "http://identity:35357/v3/policies/--policy-id--",
            "rel": "self"
        },
        "type": "--serialization-mime-type--"
    }

#### Delete policy: `DELETE /policies/{policy_id}`

Response:

    Status: 204 No Content
