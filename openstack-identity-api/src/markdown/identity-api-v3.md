OpenStack Identity API v3
=========================

The Identity API primarily fulfills authentication and authorization needs
within OpenStack, and is intended to provide a programmatic facade in front of
existing authentication and authorization system(s).

The Identity API also provides endpoint discovery through a service catalog,
identity management, project management, and a centralized repository for
policy engine rule sets.

What's New in Version 3
-----------------------

- Former "Service" and "Admin" APIs (including CRUD operations previously
  defined in the v2 OS-KSADM extension) are consolidated into a single core API
- "Tenants" are now known as "projects"
- "Domains": a high-level container for projects and users
- "Groups": a container representing a collection of users
- "Policies": a centralized repository for policy engine rule sets
- "Credentials": generic credential storage per user (e.g. EC2, PKI, SSH, etc)
- Roles can be granted at either the domain or project level
- Retrieving your list of projects (previously `GET /tenants`) is now
  explicitly based on your user ID: `GET /users/{user_id}/projects`
- Tokens explicitly represent user+project pairs
- Partial updates are performed using the HTTP `PATCH` method
- Token ID values no longer appear in URLs

API Conventions
---------------

The Identity API provides a RESTful JSON interface.

Each REST resource contains a canonically unique identifier (ID) defined by the
Identity service implementation and is provided as the `id` attribute; Resource
ID's are strings of non-zero length.

The resource paths of all collections are plural and are represented at the
root of the API (e.g. `/v3/policies`).

TCP port 35357 is designated by the Internet Assigned Numbers Authority
("IANA") for use by OpenStack Identity services. Example API requests &
responses in this document therefore assume that the Identity service
implementation is deployed at the root of `http://identity:35357/`.

### Required Attributes

For collections:

- `links` (object)

  Specifies a list of relational links to the collection.

  - `self` (url)

    A self-relational link provided as an absolute URL. This attribute is
    provided by the identity service implementation.

  - `previous` (url)

    A relational link to the previous page of the list, provided as an absolute
    URL. This attribute is provided by the identity service implementation. May
    be null.

  - `next` (url)

    A relational to the next page of the list, provided as an absolute URL.
    This attribute is provided by the identity service implementation. May be
    null.

For members:

- `id` (string)

  Globally unique resource identifier. This attribute is provided by the
  identity service implementation.

- `links` (object)

  Specifies a set of relational links relative to the collection member.

  - `self` (url)

    A self-relational link provided as an absolute URL. This attribute is
    provided by the identity service implementation.

### CRUD Operations

Unless otherwise documented (tokens being the notable exception), all resources
provided by the Identity API support basic CRUD operations (create, read,
update, delete).

The examples in this section utilize a resource collection of Entities on
`/v3/entities` which is not actually a part of the Identity API, and is used
for illustrative purposes only.

#### Create an Entity

When creating an entity, you must provide all required attributes (except those
provided by the Identity service implementation, such as the resource ID):

Request:

    POST /entities

    {
        "entity": {
            "name": string,
            "description": string,
            "enabled": boolean
        }
    }

The full entity is returned in a successful response (including the new
resource's ID and a self-relational link), keyed by the singular form of the
resource name:

    201 Created

    {
        "entity": {
            "id": string,
            "name": string,
            "description": string,
            "enabled": boolean,
            "links": {
                "self": url
            }
        }
    }

#### List Entities

Request the entire collection of entities:

    GET /entities

A successful response includes a list of anonymous dictionaries, keyed by the
plural form of the resource name (identical to that found in the resource URL):

    200 OK

    {
        "entities": [
            {
                "id": string,
                "name": string,
                "description": string,
                "enabled": boolean,
                "links": {
                    "self": url
                }
            },
            {
                "id": string,
                "name": string,
                "description": string,
                "enabled": boolean,
                "links": {
                    "self": url
                }
            }
        ],
        "links": {
            "self": url,
            "next": url,
            "previous": url
        }
    }

##### List Entities filtered by attribute

Beyond each resource's canonically unique identifier (the `id` attribute), not
all attributes are guaranteed unique on their own. To list resources which match
a specified attribute value, we can perform a filter query using a query string
with one or more attribute/value pairs:

    GET /entities?name={entity_name}&enabled={entity_enabled}

The response is a subset of the full collection:

    200 OK

    {
        "entities": [
            {
                "id": string,
                "name": string,
                "description": string,
                "enabled": boolean,
                "links": {
                    "self": url
                }
            }
        ],
        "links": {
            "self": url,
            "next": url,
            "previous": url
        }
    }

#### Get an Entity

Request a specific entity by ID:

    GET /entities/{entity_id}

The full resource is returned in response:

    200 OK

    {
        "entity": {
            "id": string,
            "name": string,
            "description": string,
            "enabled": boolean,
            "links": {
                "self": url
            }
        }
    }

#### Update an Entity

Partially update an entity (unlike a standard `PUT` operation, only the
specified attributes are replaced):

    PATCH /entities/{entity_id}

    {
        "entity": {
            "description": string,
        }
    }

The full entity is returned in response:

    200 OK

    {
        "entity": {
            "id": string,
            "name": string,
            "description": string,
            "enabled": boolean,
            "links": {
                "self": url
            }
        }
    }

#### Delete an Entity

Delete a specific entity by ID:

    DELETE /entities/{entity_id}

A successful response does not include a body:

    204 No Content

### HTTP Status Codes

The Identity API uses a subset of the available HTTP status codes to
communicate specific success and failure conditions to the client.

#### 200 OK

This status code is returned in response to successful `GET` and `PATCH
operations.

#### 201 Created

This status code is returned in response to successful `POST` operations.

#### 204 No Content

This status code is returned in response to successful `HEAD`, `PUT` and
`DELETE` operations.

#### 300 Multiple Choices

This status code is returned by the root identity endpoint, with references to
one or more Identity API versions (such as ``/v3/``).

#### 400 Bad Request

This status code is returned when the Identity service fails to parse the
request as expected. This is most frequently returned when a required attribute
is missing, a disallowed attribute is specified (such as an `id` on `POST` in a
basic CRUD operation), or an attribute is provided of an unexpected data type.

The client is assumed to be in error.

#### 401 Unauthorized

This status code is returned when either authentication has not been performed,
the provided X-Auth-Token is invalid or authentication credentials are invalid
(including the user, project or domain having been disabled).

#### 403 Forbidden

This status code is returned when the request is successfully authenticated but
not authorized to perform the requested action.

#### 404 Not Found

This status code is returned in response to failed `GET`, `HEAD`, `POST`,
`PUT`, `PATCH` and `DELETE` operations when a referenced entity cannot be found
by ID. In the case of a `POST` request, the referenced entity may be in the
request body as opposed to the resource path.

#### 409 Conflict

This status code is returned in response to failed `POST` and `PATCH`
operations. For example, when a client attempts to update an entity's unique
attribute which conflicts with that of another entity in the same collection.

Alternatively, a client should expect this status code when attempting to
perform the same create operation twice in a row on a collection with a
user-defined and unique attribute. For example, a User's `name` attribute is
defined to be unique and user-defined, so making the same ``POST /users``
request twice in a row will result in this status code.

The client is assumed to be in error.

#### 500 Internal Server Error

This status code is returned when an unexpected error has occurred in the
Identity service implementation.

#### 501 Not Implemented

This status code is returned when the Identity service implementation is unable
to fulfill the request because it is incapable of implementing the entire API
as specified.

For example, an Identity service may be incapable of returning an exhaustive
collection of Projects with any reasonable expectation of performance, or lack
the necessary permission to create or modify the collection of users (which may
be managed by a remote system); the implementation may therefore choose to
return this status code to communicate this condition to the client.

#### 503 Service Unavailable

This status code is returned when the Identity service is unable to communicate
with a backend service, or by a proxy in front of the Identity service unable
to communicate with the Identity service itself.

API Resources
-------------

### Users: `/v3/users`

User entities represent individual API consumers and are owned by a specific
domain.

Role grants explicitly associate users with projects or domains. Each
user-project or user-domain pair can have a unique set of roles granted on them.

A user without any role grants is effectively useless from the perspective of
an OpenStack service and should never have access to any resources. It is
allowed, however, as a means of acquiring or loading users from external
sources prior to mapping them to projects.

Additional required attributes:

- `name` (string)

  Globally unique username.

Optional attributes:

- `domain_id` (string)

  References the domain which owns the user; if a domain is not specified by
  the client, the Identity service implementation **must** automatically assign
  one.

- `project_id` (string)

  References the user's default project against which to authorize, if the API
  user does not explicitly specify one. Setting this attribute does not grant
  any actual authorization on the project, and is merely provided for the
  user's convenience. Therefore, the referenced project does not need to exist
  within the user's domain.

- `description` (string)

- `enabled` (boolean)

  Setting this value to `false` prevents the user from authenticating or
  receiving authorization. Additionally, all pre-existing tokens held by the
  user are immediately invalidated. Re-enabling a user does not re-enable
  pre-existing tokens.

- `password` (string)

  The default form of credential used during authentication.

Example entity:

    {
        "user": {
            "domain_id": "1789d1",
            "email": "joe@example.com",
            "enabled": true,
            "id": "0ca8f6",
            "links": {
                "self": "http://identity:35357/v3/users/0ca8f6"
            },
            "name": "Joe",
            "project_id": "263fd9"
        }
    }

### Groups: `/v3/groups`

Group entities represent a collection of Users and are owned by a specific domain.
As with individual users, role grants explicitly associate groups with projects
or domains. A group role grant onto a project/domain is the equivilent of granting
each individual member of the group the role on that project/domain. Once a group
role grant has been made, the addition or removal of a user to such a group will
result in the automatic granting/revoking of that role to the user, which will
also cause any token containing that user and project/domain to be revoked.

As with users, a group entity without any role grants is effectively useless from the
perspective an OpenStack service and should never have access to any resources. It is
allowed, however, as a means of acquiring or loading users/groups from external
sources prior to mapping them to projects/domains.

Additional required attributes:

- `name` (string)

  Unique group name, within the owning domain.

Optional attributes:

- `domain_id` (string)

  References the domain which owns the group; if a domain is not specified by
  the client, the Identity service implementation **must** automatically assign
  one.

- `description` (string)

Example entity:

    {
        "group": {
            "description": "Developers cleared for work on all general projects"
            "domain_id": "1789d1",
            "id": "70febc",
            "links": {
                "self": "http://identity:35357/v3/groups/70febc"
            },
            "name": "Developers"
        }
    }


### Credentials: `/v3/credentials`

Credentials represent arbitrary authentication credentials associated with a
user. A user may have zero or more credentials, each optionally scoped to a
specific project.

Additional required attributes:

- `user_id` (string)

  References the user which owns the credential.

- `type` (string)

  Representing the credential type, such as `ec2` or `cert`. A specific
  implementation may determine the list of supported types.

- `data` (blob)

  Arbitrary blob of the credential data, to be parsed according to the `type`.

Optional attributes:

- `project_id` (string)

  References a project which limits the scope the credential applies to.

Example entity:

    {
        "credential": {
            "data": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
            "id": "80239a",
            "links": {
                "self": "http://identity:35357/v3/credentials/80239a"
            },
            "project_id": "263fd9",
            "type": "ec2",
            "user_id": "0ca8f6"
        }
    }

### Projects: `/v3/projects`

Projects represent the base unit of "ownership" in OpenStack, in that all
resources in OpenStack should be owned by a specific project ("projects" were
also formerly known as "tenants"). A project itself must be owned by a specific
domain.

Required attributes:

- `name` (string)

  Globally unique project name.

- `domain_id` (string)

  References the domain which owns the project.

Optional attributes:

- `description` (string)

- `enabled` (boolean)

  Setting this attribute to 'false' prevents users from authorizing against
  this project. Additionally, all pre-existing tokens authorized for the tenant
  are immediately invalidated. Re-enabling a project does not re-enable
  pre-existing tokens.

Example entity:

    {
        "project": {
            "domain_id": "1789d1",
            "enabled": true,
            "id": "263fd9",
            "name": "project-x",
            "links": {
                "self": "http://identity:35357/v3/projects/263fd9"
            }
        }
    }

### Domains: `/v3/domains`

Domains represent collections of both projects and users. Each project or user
is owned by exactly one domain. Users, however, can be associated with multiple
projects by granting roles to the user on a project (including projects owned
by other domains).

Additional required attributes:

- `name` (string)

  Globally unique name.

Optional attributes:

- `description` (string)

- `enabled` (boolean)

  Setting this value to `false` also disables all projects and users owned by
  the domain, and therefore implies the same effects of disabling all of those
  entities individually.

Example entity:

    {
        "domain": {
            "enabled": true,
            "id": "1789d1",
            "links": {
                "self": "http://identity:35357/v3/domains/1789d1"
            },
            "name": "example.com"
        }
    }

### Roles: `/v3/roles/`

Roles entities are named identifiers used to map a collection of actions from a
user to either a specific project or across an entire domain.

Additional required attributes:

- `name` (string)

  Globally unique name of the role.

Example entity:

    {
        "role": {
            "id": "76e72a",
            "links": {
                "self": "http://identity:35357/v3/roles/76e72a"
            },
            "name": "admin"
        }
    }

### Services: `/v3/services`

Service entities represent web services in the OpenStack deployment. A service
may have zero or more endpoints associated with it, although a service with zero
endpoints is essentially useless in an OpenStack configuration.

Additional required attributes:

- `type` (string)

  Describes the API implemented by the service. The following values are
  recognized within the OpenStack ecosystem: `compute`, `image`, `ec2`,
  `identity`, `volume`, `network`. To support non-core and future projects, the
  value should not be validated against this list.

Optional attributes:

- `name` (string)

  User-facing name of the service.

- `enabled` (boolean)

  Setting this value to `false` prevents the service and its endpoints from
  appearing in the service catalog.

Example entity:

    {
        "service": {
            "enabled": true,
            "id": "ee057c",
            "links": {
                "self": "http://identity:35357/v3/services/ee057c"
            },
            "name": "Keystone",
            "type": "identity"
        }
    }

### Endpoints: `/v3/endpoints`

Endpoint entities represent URL endpoints for OpenStack web services.

Additional required attributes:

- `service_id` (string)

  References the service to which the endpoint belongs.

- `interface` (string)

  Describes the visibility of the endpoint according to one of the following
  values:

    - `public`: intended for consumption by end users, generally on a publicly
      available network interface

    - `internal`: intended for consumption by end users, generally on an
      unmetered internal network interface

    - `admin`: intended only for consumption by those needing administrative
      access to the service, generally on a secure network interface

- `url` (string)

  Fully qualified URL of the service endpoint.

Optional attributes:

- `region` (string)

  Represents the geographic location of the service endpoint, if relevant to
  the deployment. The value of this attribute is intended to be implementation
  specific in meaning.

- `enabled` (boolean)

  Setting this value to `false` prevents the endpoint from appearing in the
  service catalog.

Example entity:

    {
        "endpoint": {
            "enabled": true,
            "id": "6fedc0",
            "interface": "internal",
            "links": {
                "self": "http://identity:35357/v3/endpoints/6fedc0"
            },
            "region": "north",
            "service_id": "ee057c",
            "url": "http://identity:35357/"
        }
    }

### Tokens

Tokens represent an authenticated user's identity and, potentially, explicit
authorization on a specific project. Colloquially, when we refer to "tokens" we
are referring to a token's ID value; this document is explicit in that "tokens"
refer to token resources.

Tokens are generated by the Identity service via authentication, and may be
subsequently validated and/or revoked.

Unlike all other resources in the Identity API, Token ID values are not passed
in resource URL's, but instead are passed in the `X-Auth-Token` and
`X-Subject-Token` headers, along with a `Vary: X-Auth-Token, X-Subject-Token`
header to inform caches of this pattern.

Additional required attributes:

- `expires` (string, ISO 8601 timestamp)

  FIXME(dolph): ISO 8601 defines a few levels of precision... which one are we
                referring to? May need to update the example below.

  Specifies the expiration time of the token. Once established, a token's
  expiration may not be changed. A token may be revoked ahead of expiration. If
  the value represents a time in the past, the token is invalid.

- `user` (object)

  References the user to which the token belongs.

  Includes the full resource description of a user.

- `project` (object)

  Specifies the authorization scope of the token. If this attribute is not
  provided, then the token is not authorized to access any projects.

  Includes the full resource description of a project.

- `catalog` (object)

  Specifies all endpoints available to/for the token.

Example entity:

    {
        "token": {
            "catalog": {
                "FIXME(dolph)": "need an example here"
            },
            "expires": "1999-12-31T24:59:59.999999",
            "id": "28ad60",
            "links": {
                "self": "http://identity:35357/v3/tokens",
                "x-subject-token": "28ad60"
            },
            "project": {
                "domain_id": "1789d1",
                "enabled": true,
                "id": "263fd9",
                "links": {
                    "self": "http://identity:35357/v3/projects/263fd9"
                },
                "name": "project-x"
            },
            "user": {
                "domain_id": "1789d1",
                "email": "joe@example.com",
                "enabled": true,
                "id": "0ca8f6",
                "links": {
                    "self": "http://identity:35357/v3/users/0ca8f6"
                },
                "name": "Joe",
                "project_id": "263fd9"
            }
        }
    }

### Policy

Policies represent arbitrarily serialized policy engine rule sets to be
consumed by remote services.

Additional required attributes:

- `blob` (string)

  The policy rule set itself, as a serialized blob.

- `type` (string)

  The MIME Media Type of the serialized policy blob.

Example entity:

    {
        "policy": {
            "blob": "{\"default\": false}",
            "id": "c41a4c",
            "links": {
                "self": "http://identity:35357/v3/policies/c41a4c"
            },
            "type": "application/json"
        }
    }

Core API
--------

### Versions

#### List versions; `GET /`

(TBD: This needs additional definition to match the detail below)

### Tokens

The key use cases we need to cover:

- given a user name & password, get a token to represent the user
- given a token, get a list of other projects the user can access
- given a token ID, validate the token and return user, projects, roles, and
  potential endpoints that token provides access to
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
with one or more  project_names or project_ids. If a project_name or project_id is NOT
provided, the system will use the default projects associated with the user, or
return a 401 Not Authorized if a default project is not found or unable to be
used. If multiple project_names or project_ids are provided a token will be returned
that allows access to those projects simultaneously. The list of services and endpoints
that this token has access to is reflected in the service catalog.

Request:

    {
        "auth": {
            "password_credentials": {
                "username": "--user-name--",
                "password": "--password--",
                "user_id": "--optional-user-id--"
            },
        "projects" : [{
             "name": "--optional-project-name--",
             "id": "--optional-project-id--"}]
        }
    }

For the use case where we already have a token, but are requesting
authorization to a different project_id. If project_id or project_name is not
specified, default_project will be used.

Request:

    {
        "auth": {
            "projects" : [{
              "id": "--optional-project-id--",
              "name": "--optional-project-name--"}],
            "token": {
                "id": "--token-id--"
            }
        }
    }

Response:

    Status: 200
    Location: https://identity:35357/v3/tokens/--token-id--

    {
        "projects": [
          {
              "domain": {
                  "enabled": true,
                  "id": "--domain-id--",
                  "name": "--domain-name--"
              },
              "enabled": true,
              "id": "--project-id--",
              "name": "--project-name--",
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
          },
          {
              "domain": {
                  "enabled": true,
                  "id": "--domain-id--",
                  "name": "--domain-name--"
              },
              "enabled": true,
              "id": "--project-id--",
              "name": "--project-name--",
              "roles": [
                  {
                      "id": "...",
                      "name": "Member",
                      "project_id": "c5271357278e4a2094a96e0e6856c5cf"
                  }
              ],
              "roles_links": []
          }
        ],
        "services": [
            {
                "endpoints": [
                    {
                        "interface": "public",
                        "id": "--endpoint-id--",
                        "name": null,
                        "region": "RegionOne",
                        "project-id": "--project-id--",
                        "url": "http://external:8776/v1/--project-id--"
                    },
                    {
                        "interface": "internal",
                        "id": "--endpoint-id--",
                        "name": null,
                        "region": "RegionOne",
                        "project-id": "--project-id--",
                        "url": "http://internal:8776/v1/--project-id--"
                    }
                ],
                "id": "--service-id--",
                "type": "volume"
            },
            {
                "endpoints": [
                    {
                        "interface": "public",
                        "id": "--endpoint-id--",
                        "name": null,
                        "region": "RegionOne",
                        "url": "http://external:9292/v1"
                    },
                    {
                        "interface": "internal",
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
            "project_id": "--default-project-id--"
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
                            "interface": "public",
                            "id": "--endpoint-id--",
                            "name": null,
                            "region": "RegionOne",
                            "project-id": "--project-id--",
                            "url": "http://external:8776/v1/--project-id--"
                        },
                        {
                            "interface": "internal",
                            "id": "--endpoint-id--",
                            "name": null,
                            "region": "RegionOne",
                            "project-id": "--project-id--",
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
                            "interface": "public",
                            "id": "--endpoint-id--",
                            "name": null,
                            "region": "RegionOne",
                            "url": "http://external:9292/v1"
                        },
                        {
                            "interface": "internal",
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
        "projects": [
          {
              "domain": {
                  "enabled": true,
                  "id": "--domain-id--",
                  "name": "--domain-name--"
              },
              "enabled": true,
              "id": "--project-id--",
              "name": "--project-name--",
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
          },
          {
              "domain": {
                  "enabled": true,
                  "id": "--domain-id--",
                  "name": "--domain-name--"
              },
              "enabled": true,
              "id": "--project-id--",
              "name": "--project-name--",
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
        ],
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
            "project_id": "--default-project-id--"
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

A project id may be specified as a query parameter to check whether a
token is valid for a particular project:

    HEAD /tokens?project_id=1232

Multiple projects may be specified simultaneously:

    HEAD /tokens?project_id=1232&project_id=1234&project_id=9923


#### Remove token: `DELETE /tokens`

- token to be used to validate the call in X-Auth-Token
- token to be deleted is set in X-Subject-Token HTTP header

Response:

    Status: 204 No Content

### Catalog

The key use cases we need to cover:

- CRUD for services and endpoints
- Retrieving an endpoint URL by service, region, and interface

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
            "id": "--endpoint-id--",
            "interface": "public",
            "link": {
                "href": "http://identity:35357/v3/endpoints/--endpoint-id--",
                "rel": "self"
            },
            "name": "the public volume endpoint",
            "service_id": "--service-id--"
        },
        {
            "id": "--endpoint-id--",
            "interface": "internal",
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
        "interface": "[admin|public|internal]",
        "name": "name",
        "url": "..."
    }

Response:

    Status: 201 Created
    Location: https://identity:35357/v3/endpoints/--endpoint-id--

    {
        "id": "--endpoint-id--",
        "interface": "internal",
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
        "id": "--endpoint-id--",
        "interface": "internal",
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

#### List users: `GET /users`

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

#### List groups of which a user is a member: `GET /users/{user_id}/groups`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name" (optional)

Response:

    Status: 200 OK

    [
        {
            "description": "Developers cleared for work on all general projects"
            "domain_id": "--domain-id--",
            "id": "--group-id--",
            "links": {
                "href": "http://identity:35357/v3/groups/--group-id--",
                "rel": "self"
            },
            "name": "Developers"
        },
        {
            "description": "Developers cleared for work on secret projects"
            "domain_id": "--domain-id--",
            "id": "--group-id--",
            "links": {
                "href": "http://identity:35357/v3/groups/--group-id--",
                "rel": "self"
            },
            "name": "Secure Developers"
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

### Groups

#### Create group: `POST /groups`

Request:

    {
        "description": "--optional--",
        "domain_id": "--optional--",
        "name": "..."
    }

Response:

    Status: 201 Created
    Location: http://identity:35357/v3/groups/--group-id--

    {
        "description": "Developers cleared for work on secret projects",
        "id": "--group-id--",
        "link": {
            "href": "http://identity:35357/v3/groups/--group-id--",
            "rel": "self"
        },
        "name": "admin",
        "project_id": "--default-project-id--"
    }

#### List groups: `GET /groups`

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name", domain_id (optional)

Response:

    Status: 200 OK

    [
        {
            "description": "Developers cleared for work on all general projects"
            "domain_id": "--domain-id--",
            "id": "--group-id--",
            "links": {
                "href": "http://identity:35357/v3/groups/--group-id--",
                "rel": "self"
            },
            "name": "Developers"
        },
        {
            "description": "Developers cleared for work on secret projects"
            "domain_id": "--domain-id--",
            "id": "--group-id--",
            "links": {
                "href": "http://identity:35357/v3/groups/--group-id--",
                "rel": "self"
            },
            "name": "Secure Developers"
        },
        {
            "description": "Testers cleared for work on all general projects"
            "domain_id": "--domain-id--",
            "id": "--group-id--",
            "links": {
                "href": "http://identity:35357/v3/groups/--group-id--",
                "rel": "self"
            },
            "name": "Testers"
        }
   ]

#### Get group: `GET /groups/{group_id}`

Response:

    Status: 200 OK

    {
        "description": "Developers cleared for work on secret projects",
        "id": "--group-id--",
        "link": {
            "href": "http://identity:35357/v3/groups/--group-id--",
            "rel": "self"
        },
        "name": "admin",
        "project_id": "--default-project-id--"

#### List users who are members of a group: `GET /groups/{group_id}/users`

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

#### Update group: `PATCH /groups/{group_id}`

Use this method attempt to update name and/or description of group.
This may return a HTTP 501 Not Implemented if the back-end driver doesn’t allow
for the functionality.

Response:

    Status: 200 OK

    {
        "description": "Developers cleared for work on secret projects",
        "id": "--group-id--",
        "link": {
            "href": "http://identity:35357/v3/groups/--group-id--",
            "rel": "self"
        },
        "name": "admin",
        "project_id": "--default-project-id--"
    }

#### Delete group: `DELETE /groups/{group_id}`

Response:

    Status: 204 No Content

#### Add user to group: `PUT /groups/{group_id}/users/{user_id}`

Response:

    Status: 204 No Content

#### Remove user from group: `DELETE /groups/{group_id}/users/{user_id}`

Response:

    Status: 204 No Content

#### Check if user is member of group: `HEAD /groups/{group_id}/users/{user_id}`

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

#### Update credential: `PATCH /credentials/{credential_id}`

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

#### Grant role to user on domain: `PUT /domains/{domain_id}/users/{user_id}/roles/{role_id}`

Response:

    Status: 204 No Content

#### Grant role to group on domain: `PUT /domains/{domain_id}/groups/{group_id}/roles/{role_id}`

Response:

    Status: 204 No Content

#### List user's roles on domain: `GET /domains/{domain_id}/users/{user_id}/roles`

Response:

    Status: 200 OK

    [
        {
            "id": "--role-id--",
            "name": "--role-name--",
        },
        {
            "id": "--role-id--",
            "name": "--role-name--"
        }
    ]

#### List group's roles on domain: `GET /domains/{domain_id}/groups/{group_id}/roles`

Response:

    Status: 200 OK

    [
        {
            "id": "--role-id--",
            "name": "--role-name--",
        },
        {
            "id": "--role-id--",
            "name": "--role-name--"
        }
    ]

#### Check if user has role on domain: `HEAD /domains/{domain_id}/users/{user_id}/roles/{role_id}`

Response:

    Status: 204 No Content

#### Check if group has role on domain: `HEAD /domains/{domain_id}/groups/{group_id}/roles/{role_id}`

Response:

    Status: 204 No Content

#### Revoke role from user on domain: `DELETE /domains/{domain_id}/users/{user_id}/roles/{role_id}`

Response:

    Status: 204 No Content

#### Revoke role from group on domain: `DELETE /domains/{domain_id}/groups/{group_id}/roles/{role_id}`

Response:

    Status: 204 No Content

#### Grant role to user on project: `PUT /projects/{project_id}/users/{user_id}/roles/{role_id}`

Response:

    Status: 204 No Content

#### Grant role to group on project: `PUT /projects/{project_id}/groups/{group_id}/roles/{role_id}`

Response:

    Status: 204 No Content

#### List user's roles on project: `GET /projects/{project_id}/users/{user_id}/roles`

Response:

    Status: 200 OK

    [
        {
            "id": "--role-id--",
            "name": "--role-name--",
        },
        {
            "id": "--role-id--",
            "name": "--role-name--"
        }
    ]

#### List group's roles on project: `GET /projects/{project_id}/groups/{group_id}/roles`

Response:

    Status: 200 OK

    [
        {
            "id": "--role-id--",
            "name": "--role-name--",
        },
        {
            "id": "--role-id--",
            "name": "--role-name--"
        }
    ]

#### Check if user has role on project: `HEAD /projects/{project_id}/users/{user_id}/roles/{role_id}`

Response:

    Status: 204 No Content

#### Check if group has role on project: `HEAD /projects/{project_id}/groups/{group_id}/roles/{role_id}`

Response:

    Status: 204 No Content


#### Revoke role from user on project: `DELETE /projects/{project_id}/users/{user_id}/roles/{role_id}`

Response:

    Status: 204 No Content

#### Revoke role from group on project: `DELETE /projects/{project_id}/groups/{group_id}/roles/{role_id}`

Response:

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
