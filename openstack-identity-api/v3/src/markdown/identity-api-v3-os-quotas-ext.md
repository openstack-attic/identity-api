OpenStack Identity API v3 OS-QUOTAS Extension
=============================================

Quotas provide ability to restrict resources for users and projects.
Keystone is used as central quota storage for all components.
All resources and quota limits are stored in keystone. There are
2 types of quotas - per project quotas (project quota) and per user
quotas (user quota). They limit resources for concrete project and user
respectively.

API Resources
-------------

### Resources: `/v3/OS-QUOTAS/resources`

Resource entities represent service resources, which can be distributed
among users and projects.

Resource distribution is made via quotas. This mechanism will be described
in the quotas section of this doc.

Additional required attributes:

- `name` (string)

  Is globally unique.

- `service_id` (string)

  References service which owns this resource.
- `default_limit` (int)

  Default limit value will be used in quotas made for that resource with
  non-specified limit value. For more detail, look through quotas section.


Optional attributes:

- `description` (string)

  Contains short description of resource.

Example entity:

    {
        "resource": {
            "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
            "name": "nova.instances",
            "description": "nova instances",
            "default_limit": 10,
            "service_id": "2adaa8d35afd40219eda6026307ac03e",
            "links": {
                "self": "http..."
            }
        }
    }

### User quotas: `/v3/users/{user_id}/OS-QUOTAS/quotas`

User quota entities represent resource quotas for specific users. Each
user quota characterized by user-resource pair and for each user-resource
pair only one quota can be set.

Additional required attributes:

- `user_id` (string)

- `resource_id` (string)

Optional attributes:

- `limit` (int)

  Limit value for specified resource. If limit value is not specified,
  default_limit value of specified resource is used.

Example entity:

    {
        "quota": {
            "id": "512370b4ea7a40bea5664bc408f0eae8",
            "resource": {
                "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10,
                "service_id": "2adaa8d35afd40219eda6026307ac03e",
                "links": {
                    "self": "http..."
                }
            },
            "limit": 1024,
            "links": {
                "self": "http..."
            }
        }
    }

### Project quotas: `/v3/projects/{project_id}/OS-QUOTAS/quotas`

Project quota entities represent resource quotas for specific projects.
Each project quota characterized by project-resource pair and for each
project-resource pair only one quota can be set.

Additional required attributes:

- `project_id` (string)

- `resource_id` (string)

Optional attributes:

- `limit` (int)

  Limit value for specified resource. If limit value is not specified,
  default_limit value of specified resource is used.

Example entity:

    {
        "quota": {
            "id": "66a66a7f47f24df8978c7bc422007af9",
            "resource": {
                "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10,
                "service_id": "2adaa8d35afd40219eda6026307ac03e",
                "links": {
                    "self": "http..."
                }
            },
            "limit": 1024,
            "links": {
                "self": "http..."
            }
        }
    }

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
                "default_limit": 10,
                "service_id": "2adaa8d35afd40219eda6026307ac03e",
                "links": {
                    "self": "http..."
                }
            },
            {
                "id": "fc4c5140879042c7b0af4618267139cc",
                "name": "nova.ram",
                "description": "nova ram",
                "default_limit": 1,
                "service_id": "2adaa8d35afd40219eda6026307ac03e",
                "links": {
                    "self": "http..."
                }
            },
            {
                "id": "9c3741ced7fd47708d84a9c9f9772f02",
                "name": "cinder.volumes",
                "description": "cinder volumes",
                "default_limit": 3,
                "service_id": "a250d12ddb2240519c16c5971ff58389",
                "links": {
                    "self": "http..."
                }
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http..."
        }
    }

#### Create resource: `POST /OS-QUOTAS/resources`

Response:

    Status: 201 Created
    {
        "resource": {
            "id": "306a2a4a8c2243bd8bdd3b10a6cea9c6",
            "name": "nova.instances",
            "description": "nova instances",
            "default_limit": 10,
            "service_id": "2adaa8d35afd40219eda6026307ac03e",
            "links": {
                "self": "http..."
            }
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
            "default_limit": 10,
            "service_id": "2adaa8d35afd40219eda6026307ac03e",
            "links": {
                "self": "http..."
            }
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
            "default_limit": 10,
            "service_id": "2adaa8d35afd40219eda6026307ac03e",
            "links": {
                "self": "http..."
            }
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
                "limit": 1024,
                "links": {
                    "self": "http..."
                }
            },
            {
                "id": "8a56ef0e7cb04001a522992c4e3a00eb",
                "resource_name": "cinder.volumes",
                "limit": 16,
                "links": {
                    "self": "http..."
                }
            },
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http..."
        }
    }

#### Get project quota list: `GET /projects/{project_id}/OS-QUOTAS/quotas`

Response:

    Status: 200 OK

    {
        "quotas": [
            {
                "id": "efd3cffd14d34afebd5f67c628930428",
                "resource_name": "nova.ram",
                "limit": 1024,
                "links": {
                    "self": "http..."
                }
            },
            {
                "id": "42114cd7ac3f4c61ae32feb2d8d39bf8",
                "resource_name": "cinder.volumes",
                "limit": 16,
                "links": {
                    "self": "http..."
                }
            },
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http..."
        }
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
                "default_limit": 10,
                "service_id": "2adaa8d35afd40219eda6026307ac03e",
                "links": {
                    "self": "http..."
                }
            },
            "limit": 1024,
            "links": {
                "self": "http..."
            }
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
                "default_limit": 10,
                "service_id": "2adaa8d35afd40219eda6026307ac03e",
                "links": {
                    "self": "http..."
                }
            },
            "limit": 1024,
            "links": {
                "self": "http..."
            }
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
                "default_limit": 10,
                "service_id": "2adaa8d35afd40219eda6026307ac03e",
                "links": {
                    "self": "http..."
                }
            },
            "limit": 1024,
            "links": {
                "self": "http..."
            }
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
                "default_limit": 10,
                "service_id": "2adaa8d35afd40219eda6026307ac03e",
                "links": {
                    "self": "http..."
                }
            },
            "limit": 1024,
            "links": {
                "self": "http..."
            }
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
                "default_limit": 10,
                "service_id": "2adaa8d35afd40219eda6026307ac03e",
                "links": {
                    "self": "http..."
                }
            },
            "limit": 1024,
            "links": {
                "self": "http..."
            }
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
                "default_limit": 10,
                "service_id": "2adaa8d35afd40219eda6026307ac03e",
                "links": {
                    "self": "http..."
                }
            },
            "limit": 1024,
            "links": {
                "self": "http..."
            }
        }
    }

#### Delete user quota: `DELETE /users/{user_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 204 No Content

#### Delete project quota: `DELETE /projects/{project_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 204 No Content
