OpenStack Identity API v3 OS-ROLES Extension
============================================

Provides an ability to associate a role definition with service_id, this extension requires v3.0+ of the Identity API and address following issues.

1. System wide role name uniqueness constraint, now roles will be unique per service.
2. Filtering support for auth_token clients, clients can filter roles based on service_id.
3. This proposal is backward compatible since service-id is an optional filed, it does not break an existing deployments.


API
---

The following APIs are supported by this extension:

#### Create role: `POST /OS-ROLES/roles`

Request:

    {
        "name": "",
        "service_id": "--id--"
    }

Response:

    Status: 201 Created

    {
        "id": "--role-id--",
        "links": {
            "self": "http://identity:35357/v3/OS-ROLES/roles/--role-id--"
        },
        "name": "a role name",
        "OS-ROLES:service_id": "--service_id--"
    }

#### List roles: `GET /OS-ROLES/roles`

query filter for `name` (optional)
query filter for `OS-ROLES:service_id` (optional)

Response:

    Status: 200 OK

    {
    "roles": [
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:35357/v3/OS-ROLES/roles/--role-id--"
                },
                "name": "a role name"
                "OS-ROLES:service_id": "--service_id--"
            },
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:35357/v3/OS-ROLES/roles/--role-id--"
                },
                "name": "a role name"
                "OS-ROLES:service_id": "--service_id--"
            }
        ],
        "links": {
            "self": "http://identity:35357/OS-ROLES/v3/roles",
            "previous": null,
            "next": null
        }
    }
#### Get role: `GET /OS-ROLES/roles/{role_id}`

Response:

    Status: 200 OK

    {
        "role": {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:35357/v3/OS-ROLES/roles/--roles-id--"
                },
                "name": "a role name"
                "OS-ROLES:service_id": "--service_id--"
            }
   }
#### Update role: `PATCH /OS-ROLES/roles/{role_id}`

The request block is the same as the one for create role, except that only the attributes that are being updated need to be included.

Response:

    Status: 200 OK

    {
      "role": {
            "id": "--role-id--",
            "links": {
                "self": "http://identity:35357/v3/OS-ROLES/roles/--roles-id--"
            },
            "name": "a role name"
            "OS-ROLES:service_id": "--service_id--"
        }
    }

#### Delete role: `DELETE /OS-ROLES/roles/{role_id}`

Response:

    Status: 204 No Content

Modified APIs
------------

The following APIs are modified by this extension.

##### Authenticate: `POST /auth/tokens`

An existing auth API response will contain "OS-ROLES:service_id" field along with role name.

    Headers: X-Subject-Token

    X-Subject-Token: e80b74

    {
        "token": {
            "catalog": "FIXME(dolph): need an example here",
            "expires_at": "2013-02-27T18:30:59.999999Z",
            "issued_at": "2013-02-27T16:30:59.999999Z",
            "methods": [
                "password"
            ],
            "project": {
                "domain": {
                    "id": "1789d1",
                    "links": {
                        "self": "http://identity:35357/v3/domains/1789d1"
                    },
                    "name": "example.com"
                },
                "id": "263fd9",
                "links": {
                    "self": "http://identity:35357/v3/projects/263fd9"
                },
                "name": "project-x"
            },
            "roles": [
                {
                    "id": "76e72a",
                    "links": {
                        "self": "http://identity:35357/v3/roles/76e72a"
                    },
                    "name": "admin",
                    "OS-ROLES:service_id": "--service_id--"
                },
                {
                    "id": "f4f392",
                    "links": {
                        "self": "http://identity:35357/v3/roles/f4f392"
                    },
                    "name": "member",
                    "OS-ROLES:service_id": "--service_id--"
                }
            ],
            "user": {
                "domain": {
                    "id": "1789d1",
                    "links": {
                        "self": "http://identity:35357/v3/domains/1789d1"
                    },
                    "name": "example.com"
                },
                "id": "0ca8f6",
                "links": {
                    "self": "http://identity:35357/v3/users/0ca8f6"
                },
                "name": "Joe"
            }
        }
    }
#### Validate token: 'GET /auth/tokens'

The Identity service will return the exact same response as when the subject token was issued by `POST /auth/tokens` and the response will contain "OS-ROLES:service_id" field along with role name.