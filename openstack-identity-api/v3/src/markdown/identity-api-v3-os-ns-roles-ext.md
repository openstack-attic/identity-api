OpenStack Identity API v3 OS-NS-ROLES Extension
========================================================

This extension allows role creator to optionally link roles with
a name-space to avoid name collision and to make role names globally
unique.
Optionally, this extension will allow role creators to associate
roles with resource for which the role is valid.

These extension will also facilitate

1. Policy based fine grained access control on roles entities.
2. Domain, project and service specific roles.
3. Service scoped authentication tokens.
4. An `Identity API` clients (middle-ware) to filter roles by
name-spaces attributes.

This extension is backward compatible and it will not break
an existing deployments.

This extension requires v3.0+ of the Identity API.

API Resources
-------------

### Roles: `/roles`

Roles are name spaced entities which represents certain capability
within the context of a resource.

Additional required attributes:

- `name` (string)

  Must be globally unique when combined with optional domain, project
  and service ids.

Optional attributes:

- `namespace`

  Defines a name space for roles.

    - `domain_id` (string)

    If present, role is named by specific domain.

    - `project_id` (string)

    If present, role is named by specific project.

    - `service_id` (string)

    If present, role is named by specific service.

- `scope`

   Scope represents a resource for which the role is valid. Existence
   of `scope` in roles does not impact `OS Identity service` execution
   and will be treated as advisory attribute for role creators.

    - `id` (string)

    Resource identifier.

    - `type` (string)

    Resource type (service | file | domain etc...).

    - `endpoint` (string)

    Endpoint of the resource.

Immutable attributes provided by the Identity service:

- `qname`

   A fully qualified role name, which can be used in policy and
   must be globally unique.

Example entity:

    {
      "role": {
        "id": "r1e72a",
        "name": "admin",
        "OS-NS-ROLES:qname": "d1vc7i.p1vc7i.s1vc7i.admin",
        "OS-NS-ROLES:namesapce": {
                "domain_id": "d1vc7i",
                "project_id": "p1vc7i",
                "service_id": "s1vc7i"
         },
         "OS-NS-ROLES:scope": {
                "id": "--resource-id--",
                "type": "--type--",
                "endpoint": "--endpoint--"
         },
        "links": {
                "self": "http://identity:35357/v3/roles/r1e72a"
            }
      }
    }

API
---

#### Create role: `POST /roles`

Request:

    {
      "role": {
        "name": "--role-name--",
         "OS-NS-ROLES:namespace": {
            "domain_id"="--optional--",
            "project_id"="--optional--",
            "service_id"="--optional--"
         },
        "OS-NS-ROLES:scope": {
          "id": "--optional--",
          "type": "--optional--",
          "endpoint": "--optional--"
        }
      }
    }

Response:

    Status: 201 Created

    {
      "role": {
        "id": "r1e72a",
        "name": "admin",
        "OS-NS-ROLES:qname":"--domain_id--.--project_id--.--service_id--.admin",
        "OS-NS-ROLES:namespace": {
            "domain_id"="--domain-id--",
            "project_id"="--project-id--",
            "service_id"="--service-id--"
        },
        "OS-NS-ROLES:scope": {
          "id": "--resource-id--",
          "type": "--type--",
          "endpoint": "--endpoint--"
        },
        "links": {
                "self": "http://identity:35357/v3/roles/r1e72a"
            }
      }
    }

#### List roles: `GET /roles`

query filter for `name` (optional)
query filter for `OS-NS-ROLES:qname` (optional)
query filter for `OS-NS-ROLES:domain_id` (optional)
query filter for `OS-NS-ROLES:project_id` (optional)
query filter for `OS-NS-ROLES:service_id` (optional)

Response:

    Status: 200 OK

    {
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/roles"
        },
        "roles": [
            {
                "id": "r1e72a",
                "name": "admin",
                "OS-NS-ROLES:qname": "d1vc7i.p1vc7i.s1vc7i.admin",
                "OS-NS-ROLES:namesapce": {
                    "domain_id": "d1vc7i",
                    "project_id": "p1vc7i",
                    "service_id": "s1vc7i"
                },
                "OS-NS-ROLES:scope": {
                },
                "links": {
                    "self": "http://identity:35357/v3/roles/r1e72a"
                }
            },
            {
                "id": "r2e72a",
                "name": "member",
                "OS-NS-ROLES:qname": "d2vc7i.p2vc7i.s2vc7i.member",
                "OS-NS-ROLES:namesapce": {
                    "domain_id": "d2vc7i",
                    "project_id": "p2vc7i",
                    "service_id": "s2vc7i"
                },
                "OS-NS-ROLES:scope": {
                },
                "links": {
                    "self": "http://identity:35357/v3/roles/r2e72a"
                }
            }
        ]
    }

#### Get role: `GET /roles/{role_id}`

Response:

    Status: 200 OK

    {
        "role": {
                "id": "r2e72a",
                "name": "member",
                "OS-NS-ROLES:qname": "d2vc7i.p2vc7i.s2vc7i.admin",
                "OS-NS-ROLES:namesapce": {
                    "domain_id": "d2vc7i",
                    "project_id": "p2vc7i",
                    "service_id": "s2vc7i"
                },
                "OS-NS-ROLES:scope": {
                },
                "links": {
                    "self": "http://identity:35357/v3/roles/r2e72a"
                }
        }
    }

#### Update role: `PATCH /roles/{role_id}`

The request block is the same as the one for create role, except that only the
attributes that are being updated need to be included.

Response:

    Status: 200 OK

    {
      "role": {
        "name": "--role-name--",
         "OS-NS-ROLES:namespace": {
            "domain_id"="--optional--",
            "project_id"="--optional--",
            "service_id"="--optional--"
         },
        "OS-NS-ROLES:scope": {
          "id": "--optional--",
          "type": "--optional--",
          "endpoint": "--optional--"
        }
      }
    }

##### Authenticate: `POST /auth/tokens`

An existing auth response will contain "OS-NS-ROLES" fields along with
role name.

Example OpenStack token response: [Various OpenStack token
responses](https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses)

Example role list object in a token response:

    "roles": [
        {
            "id": "76e72a",
            "links": {
                "self": "http://identity:35357/v3/roles/r1e72a"
            },
            "name": "admin",
            "OS-NS-ROLES:qname": "d1vc7i.p1vc7i.s1vc7i.admin"
        },
        {
            "id": "f4f392",
            "links": {
                "self": "http://identity:35357/v3/roles/r2e72a"
            },
            "name": "member",
            "OS-NS-ROLES:qname": "d2vc7i.p2vc7i.s2vc7i.member"
        }
    ]

#### Validate token: 'GET /auth/tokens'

The Identity service will return the exact same response as when the subject
token was issued by `POST /auth/tokens` and the response will contain
`OS-NS-ROLES:qname` attribute along with role `name`.