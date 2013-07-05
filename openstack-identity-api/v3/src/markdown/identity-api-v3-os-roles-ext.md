OpenStack Identity API v3 OS-ROLES Extension
============================================

Provides an ability to associate a role definition with service_id, this extension address following issues.

1. System wide role name uniqueness constraint, now roles will be unique per service.
1. Filtering support for auth_token clients, clients can filter roles based on service_id.


API
---

The following APIs are supported by this extension:

#### Create role: `POST /OS-ROLES/roles`

Request:

    {
        "name": "",
        "service_id": "--id--",
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

query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "name" (optional)
query filter for "service_id" (optional)

Response:

    Status: 200 OK

    [
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
    ]
    
#### Get role: `GET /OS-ROLES/roles/{role_id}`

Response:

    Status: 200 OK

    {
        "id": "--role-id--",
        "links": {
            "self": "http://identity:35357/v3/OS-ROLES/roles/--roles-id--"
        },
        "name": "a role name"
        "OS-ROLES:service_id": "--service_id--"
    }

#### Update role: `PATCH /OS-ROLES/roles/{role_id}`

Response:

    Status: 200 OK

    {
        "id": "--role-id--",
        "links": {
            "self": "http://identity:35357/v3/OS-ROLES/roles/--roles-id--"
        },
        "name": "a role name"
        "OS-ROLES:service_id": "--service_id--"
    }
    
#### Delete role: `DELETE /OS-ROLES/roles/{role_id}`

Response:

    Status: 204 No Content
    
##### Authentication responses

A token scoped to a `project` will also have a service `catalog`, along with
the user's roles applicable to the `project`. Example response:

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

A token scoped to a `domain` will also have a service `catalog` along with the
user's roles applicable to the `domain`. Example response:

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
            "domain": {
                "id": "1789d1",
                "links": {
                    "self": "http://identity:35357/v3/domains/1789d1"
                },
                "name": "example.com"
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
    
    Note: Auth response will contain "OS-ROLES:service_id" along with role name, which is a modification over existing auth API.
    