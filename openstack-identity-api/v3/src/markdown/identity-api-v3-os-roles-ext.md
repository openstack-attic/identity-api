OpenStack Identity API v3 OS-ROLES Extension
============================================

Provides an ability to associate a role definition with service_id, this
extension requires v3.0+ of the Identity API and address following issues.

1. System wide role name uniqueness constraint, now roles may be unique per
service.
2. Filtering support for auth_token clients, clients can filter roles based on
service_id.
3. This proposal is backward compatible since service-id is an optional field,
it does not break an existing deployments.


API
---

The following APIs are supported by this extension:

#### Create role: `POST /OS-ROLES/roles`

Request:

    {
        "name": "admin",
        "service_id": "5vc7id"
    }

Response:

    Status: 201 Created

    {
        "id": "76e72a",
        "links": {
            "self": "http://identity:35357/v3/OS-ROLES/roles/76e72a",
            "service": "http://identity:35357/v3/services/5vc7id"
        },
        "name": "admin",
        "OS-ROLES:service_id": "5vc7id"
    }

#### List roles: `GET /OS-ROLES/roles`

query filter for `name` (optional)
query filter for `OS-ROLES:service_id` (optional)

Response:

    Status: 200 OK

    {
      "roles": [
        {
          "id": "76e72a",
          "links": {
            "self": "http://identity:35357/v3/OS-ROLES/roles/76e72a"
            "service": "http://identity:35357/v3/services/5vc7id"
          },
          "name": "admin",
          "OS-ROLES:service_id": "5vc7id"
        },
        {
          "id": "f4f392",
          "links": {
            "self": "http://identity:35357/v3/OS-ROLES/roles/f4f392"
            "service": "http://identity:35357/v3/services/5vc7id"
          },
          "name": "member",
          "OS-ROLES:service_id": "5vc7id"
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
                "id": "76e72a",
                "links": {
                    "self": "http://identity:35357/v3/OS-ROLES/roles/76e72a",
                    "service": "http://identity:35357/v3/services/5vc7id"
                },
                "name": "admin"
                "OS-ROLES:service_id": "5vc7id"
            }
   }
#### Update role: `PATCH /OS-ROLES/roles/{role_id}`

The request block is the same as the one for create role, except that only the
attributes that are being updated need to be included.

Response:

    Status: 200 OK

    {
      "role": {
            "id": "76e72a",
            "links": {
                "self": "http://identity:35357/v3/OS-ROLES/roles/76e72a"
                "service": "http://identity:35357/v3/services/5vc7id"
            },
            "name": "member"
            "OS-ROLES:service_id": "5vc7id"
        }
    }

#### Delete role: `DELETE /OS-ROLES/roles/{role_id}`

Response:

    Status: 204 No Content

Modified APIs
------------

The following APIs are modified by this extension.

##### Authenticate: `POST /auth/tokens`

An existing auth API response will contain "OS-ROLES:service_id" field along
with role name.

Example OpenStack token response: [Various OpenStack token responses](https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses)

Example role list object in a token response:

    "roles": [
        {
            "id": "76e72a",
            "links": {
                "self": "http://identity:35357/v3/roles/76e72a"
                "service": "http://identity:35357/v3/services/5vc7id"
            },
            "name": "admin",
            "OS-ROLES:service_id": "5vc7id"
        },
        {
            "id": "f4f392",
            "links": {
                "self": "http://identity:35357/v3/roles/f4f392"
                "service": "http://identity:35357/v3/services/5vc7id"
            },
            "name": "member",
            "OS-ROLES:service_id": "5vc7id"
        }
    ]

#### Validate token: 'GET /auth/tokens'

The Identity service will return the exact same response as when the subject
token was issued by `POST /auth/tokens` and the response will contain
"OS-ROLES:service_id" field along with role name.

