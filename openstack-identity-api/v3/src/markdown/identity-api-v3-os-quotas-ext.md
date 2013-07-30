OpenStack Identity API v3 OS-QUOTAS Extension
=============================================

Quotas provide ability to restrict resources for users and projects.

API
---

The following additional APIs are supported by this extension:

#### Get resource list: `GET /OS-QUOTAS/resources`

Response:

    Status: 200 OK

    {
        "resources": [
            {
                "id": "123-id-123",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10
            },
            {
                "id": "234-id-234",
                "name": "nova.ram",
                "description": "nova ram",
                "default_limit": 1
            },
            {
                "id": "345-id-345",
                "name": "cinder.volumes",
                "description": "cinder volumes",
                "default_limit": 3
            }
        ]
    }

#### Create resource: `POST /OS-QUOTAS/resources`

Response:

    Status: 200 OK
    {
        "resource": {
            "name": "nova.instances",
            "default_limit": 10
        }
    }

#### Get resource: `GET /OS-QUOTAS/resources/{resource_id}`

Response:

    Status: 200 OK

    {
        "resource": {
            "name": "nova.instances",
            "default_limit": 10
        }
    }

#### Update resource: `PATCH /OS-QUOTAS/resources/{resource_id}`

Request:

    {
        "resource": {
            "name": "nova.instances",
            "default_limit": 10
        }
    }

Response:

    Status: 200 OK

    {
        "resource": {
            "name": "nova.instances",
            "default_limit": 10
        }
    }

#### Delete resource: `DELETE /OS-QUOTAS/resources/{resource_id}`

Response:

    Status: 200 OK

#### Get user quota list: `GET /users/{user_id}/OS-QUOTAS/quotas`

Response:

    Status: 200 OK

    {
        "quotas": [
            {
                "id": "000-id-000",
                "resource_name": "nova.ram",
                "limit": 1024
            },
            {
                "id": "111-id-111",
                "resource_name": "nova.vcpu",
                "limit": 16
            },
        ]
    }

#### Get project quota list: `GET /projects/{project_id}/OS-QUOTAS/quotas`

Response:

    Status: 200 OK

    {
        "quotas": [
            {
                "id": "000-id-000",
                "resource_name": "nova.ram",
                "limit": 1024
            },
            {
                "id": "111-id-111",
                "resource_name": "nova.vcpu",
                "limit": 16
            },
        ]
    }

#### Create user quota: `POST /users/{user_id}/OS-QUOTAS/quotas`

Request:

    {
        "quota": {
            "resource_name": "nova.ram",
            "limit": 1024
        }
    }

Response:

    Status: 200 OK

    {
        "quota": {
            "resource_name": "nova.ram",
            "limit": 1024
        }
    }

#### Create project quota: `POST /projects/{project_id}/OS-QUOTAS/quotas`

Request:

    {
        "quota": {
            "resource_name": "nova.ram",
            "limit": 1024
        }
    }

Response:

    Status: 200 OK

    {
        "quota": {
            "resource_name": "nova.ram",
            "limit": 1024
        }
    }

#### Get user quota: `GET /users/{user_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 200 OK

    {
        "quota": {
            "resource_name": "nova.ram",
            "limit": 1024
        }
    }


#### Get project quota: `GET /projects/{project_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 200 OK

    {
        "quota": {
            "resource_name": "nova.ram",
            "limit": 1024
        }
    }

#### Update user quota: `PATCH /users/{user_id}/OS-QUOTAS/quotas/{quota_id}`

Request:

    {
        "quota": {
            "resource_name": "nova.ram",
            "limit": 1024
        }
    }

Response:

    Status: 200 OK

    {
        "quota": {
            "id": "000-id-000",
            "resource-name": "nova.ram",
            "limit": 1024
        }
    }


#### Update project quota: `PATCH /projects/{project_id}/OS-QUOTAS/quotas/{quota_id}`

Request:

    {
        "quota": {
            "resource_name": "nova.ram",
            "limit": 1024
        }
    }

Response:

    Status: 200 OK

    {
        "quota": {
            "id": "000-id-000",
            "resource-name": "nova.ram",
            "limit": 1024
        }
    }

#### Delete user quota: `DELETE /users/{user_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 200 OK

#### Delete project quota: `DELETE /projects/{project_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 200 OK
