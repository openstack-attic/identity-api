OpenStack Identity API v3 OS-ROLES Extension
============================================

Thie extension provides an ability to associate a role definition with a
service. This extension requires v3.0+ of the Identity API and address
following issues.

1. System-wide role name uniqueness constraint.
2. Clients can filter roles by `OS-ROLES:service_id`.
3. This specification is backward compatible since `OS-ROLES:service_id` is an
   optional field, it does not break existing deployments.


Modified APIs
------------

The following APIs are modified by this extension.

#### Create role: `POST /roles`

Request:

    {
        "OS-ROLES:service_id": "5vc7id",
        "name": "admin"
    }

Response:

    Status: 201 Created

    {
        "OS-ROLES:service_id": "5vc7id",
        "id": "76e72a",
        "links": {
            "self": "http://identity:35357/v3/roles/76e72a",
            "service": "http://identity:35357/v3/services/5vc7id"
        },
        "name": "admin"
    }

#### List roles: `GET /roles`

query filter for `name` (optional)
query filter for `OS-ROLES:service_id` (optional)

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
                "OS-ROLES:service_id": "5vc7id",
                "id": "76e72a",
                "links": {
                    "self": "http://identity:35357/v3/roles/76e72a",
                    "service": "http://identity:35357/v3/services/5vc7id"
                },
                "name": "admin"
            },
            {
                "OS-ROLES:service_id": "5vc7id",
                "id": "f4f392",
                "links": {
                    "self": "http://identity:35357/v3/roles/f4f392",
                    "service": "http://identity:35357/v3/services/5vc7id"
                },
                "name": "member"
            }
        ]
    }

#### Get role: `GET /roles/{role_id}`

Response:

    Status: 200 OK

    {
        "role": {
            "OS-ROLES:service_id": "5vc7id",
            "id": "76e72a",
            "links": {
                "self": "http://identity:35357/v3/roles/76e72a",
                "service": "http://identity:35357/v3/services/5vc7id"
            },
            "name": "admin"
        }
    }

#### Update role: `PATCH /roles/{role_id}`

The request block is the same as the one for create role, except that only the
attributes that are being updated need to be included.

Response:

    Status: 200 OK

    {
        "role": {
            "OS-ROLES:service_id": "5vc7id",
            "id": "76e72a",
            "links": {
                "self": "http://identity:35357/v3/roles/76e72a",
                "service": "http://identity:35357/v3/services/5vc7id"
            },
            "name": "member"
        }
    }

##### Authenticate: `POST /auth/tokens`

An existing auth response will contain "OS-ROLES:service_id" field along with
role name.

Example OpenStack token response: [Various OpenStack token
responses](https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses)

Example role list object in a token response:

    "roles": [
        {
            "OS-ROLES:service_id": "5vc7id",
            "id": "76e72a",
            "links": {
                "self": "http://identity:35357/v3/roles/76e72a",
                "service": "http://identity:35357/v3/services/5vc7id"
            },
            "name": "admin"
        },
        {
            "OS-ROLES:service_id": "5vc7id",
            "id": "f4f392",
            "links": {
                "self": "http://identity:35357/v3/roles/f4f392",
                "service": "http://identity:35357/v3/services/5vc7id"
            },
            "name": "member"
        }
    ]

#### Validate token: 'GET /auth/tokens'

The Identity service will return the exact same response as when the subject
token was issued by `POST /auth/tokens` and the response will contain
"OS-ROLES:service_id" attribute along with role name.
