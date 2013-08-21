OpenStack Identity API v3 OS-QUOTAS Extension
=============================================

Quotas provide ability to restrict resources for users and projects.
Keystone is used as central quota storage for all components.
All resources and quota limits are stored in keystone. There are
2 types of quotas - per project quotas (project quota) and per user
quotas (user quota). They limit resources for concrete project and user
respectively.

New concepts and instances in Keystone
-------------------------

- "Resource": some resource of service which can be limited (RAM, number of CPUs, etc). Resource name is globally unique. Resources will be provided by services and their usage will be mirrored into quotas.
- "Quota": describes resource limitation and resource distribution among users and projects (user quotas and project quotas respectively). Quota will be characterized by subject (concrete user or project), resource and limit for that resource.

API
---

The following APIs are supported by this extension:

#### Get resource list: `GET /OS-QUOTAS/resources`

Response:

    Status: 200 OK

    {
        "resources": [
            {
                "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10
            },
            {
                "id": "fc4c5140879042c7b0af4618267139cc",
                "name": "nova.ram",
                "description": "nova ram",
                "default_limit": 1
            },
            {
                "id": "9c3741ced7fd47708d84a9c9f9772f02",
                "name": "cinder.volumes",
                "description": "cinder volumes",
                "default_limit": 3
            }
        ]
    }

#### Create resource: `POST /OS-QUOTAS/resources`

Response:

    Status: 201 Created
    {
        "resource": {
            "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
            "name": "nova.instances",
            "description": "nova instances",
            "default_limit": 10
        }
    }

#### Get resource: `GET /OS-QUOTAS/resources/{resource_id}`

Response:

    Status: 200 OK

    {
        "resource": {
            "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
            "name": "nova.instances",
            "description": "nova instances",
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
            "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
            "name": "nova.instances",
            "description": "nova instances",
            "default_limit": 10
        }
    }

#### Delete resource: `DELETE /OS-QUOTAS/resources/{resource_id}`

Response:

    Status: 204 No Content

#### Get user quota list: `GET /users/{user_id}/OS-QUOTAS/quotas`

Response:

    Status: 200 OK

    {
        "quotas": [
            {
                "id": "d1862e9fbb66409091c15708adb55379",
                "resource_name": "nova.ram",
                "limit": 1024
            },
            {
                "id": "8a56ef0e7cb04001a522992c4e3a00eb",
                "resource_name": "cinder.volumes",
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
                "id": "efd3cffd14d34afebd5f67c628930428",
                "resource_name": "nova.ram",
                "limit": 1024
            },
            {
                "id": "42114cd7ac3f4c61ae32feb2d8d39bf8",
                "resource_name": "cinder.volumes",
                "limit": 16
            },
        ]
    }

#### Create user quota: `POST /users/{user_id}/OS-QUOTAS/quotas`

Request:

    {
        "quota": {
            "resource_id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
            "limit": 1024
        }
    }

Response:

    Status: 201 Created

    {
        "quota": {
            "id": "512370b4ea7a40bea5664bc408f0eae8",
            "resource": {
                "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10
            },
            "limit": 1024
        }
    }

#### Create project quota: `POST /projects/{project_id}/OS-QUOTAS/quotas`

Request:

    {
        "quota": {
            "resource_id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
            "limit": 1024
        }
    }

Response:

    Status: 201 Created

    {
        "quota": {
            "id": "66a66a7f47f24df8978c7bc422007af9",
            "resource": {
                "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10
            },
            "limit": 1024
        }
    }

#### Get user quota: `GET /users/{user_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 200 OK

    {
        "quota": {
            "id": "512370b4ea7a40bea5664bc408f0eae8",
            "resource": {
                "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10
            },
            "limit": 1024
        }
    }


#### Get project quota: `GET /projects/{project_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 200 OK

    {
        "quota": {
            "id": "66a66a7f47f24df8978c7bc422007af9",
            "resource": {
                "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10
            },
            "limit": 1024
        }
    }

#### Update user quota: `PATCH /users/{user_id}/OS-QUOTAS/quotas/{quota_id}`

Request:

    {
        "quota": {
            "limit": 1024
        }
    }

Response:

    Status: 200 OK

    {
        "quota": {
            "id": "512370b4ea7a40bea5664bc408f0eae8",
            "resource": {
                "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10
            },
            "limit": 1024
        }
    }


#### Update project quota: `PATCH /projects/{project_id}/OS-QUOTAS/quotas/{quota_id}`

Request:

    {
        "quota": {
            "limit": 1024
        }
    }

Response:

    Status: 200 OK

    {
        "quota": {
            "id": "66a66a7f47f24df8978c7bc422007af9",
            "resource": {
                "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10
            },
            "limit": 1024
        }
    }

#### Delete user quota: `DELETE /users/{user_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 204 No Content

#### Delete project quota: `DELETE /projects/{project_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 204 No Content
