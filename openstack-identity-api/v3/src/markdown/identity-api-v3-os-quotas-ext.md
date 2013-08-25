OpenStack Identity API v3 OS-QUOTAS Extension
=============================================

Quotas provide the ability to restrict resources for users and projects.
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
            "id": "cea9c6",
            "name": "nova.instances",
            "description": "nova instances",
            "default_limit": 10,
            "service_id": "7ac03e",
            "links": {
                "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
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
  `default_limit` value of specified resource is used.

Example entity:

    {
        "quota": {
            "id": "f0eae8",
            "resource": {
                "id": "cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10,
                "service_id": "7ac03e",
                "links": {
                    "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
                }
            },
            "limit": 1024,
            "links": {
                "self": "http://identity:35357/v3/users/6ed0b4/OS-QUOTAS/quotas/f0eae8"
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
  `default_limit` value of specified resource is used.

Example entity:

    {
        "quota": {
            "id": "007af9",
            "resource": {
                "id": "cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10,
                "service_id": "7ac03e",
                "links": {
                    "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
                }
            },
            "limit": 1024,
            "links": {
                "self": "http://identity:35357/v3/projects/133f61/OS-QUOTAS/quotas/007af9"
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
                "id": "cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10,
                "service_id": "7ac03e",
                "links": {
                    "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
                }
            },
            {
                "id": "7139cc",
                "name": "nova.ram",
                "description": "nova ram",
                "default_limit": 1,
                "service_id": "7ac03e",
                "links": {
                    "self": "http://identity:35357/v3/OS-QUOTA/resources/7139cc"
                }
            },
            {
                "id": "772f02",
                "name": "cinder.volumes",
                "description": "cinder volumes",
                "default_limit": 3,
                "service_id": "f58389",
                "links": {
                    "self": "http://identity:35357/v3/OS-QUOTA/resources/772f02"
                }
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-QUOTA/resources"
        }
    }

#### Create resource: `POST /OS-QUOTAS/resources`

Request:

    {
        "resource": {
            "name": "nova.instances",
            "description": "nova instances",
            "default_limit": 10,
            "service_id": "7ac03e"
        }
    }

Response:

    Status: 201 Created

    {
        "resource": {
            "id": "cea9c6",
            "name": "nova.instances",
            "description": "nova instances",
            "default_limit": 10,
            "service_id": "7ac03e",
            "links": {
                "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
            }
        }
    }

#### Get resource: `GET /OS-QUOTAS/resources/{resource_id}`

Response:

    Status: 200 OK

    {
        "resource": {
            "id": "cea9c6",
            "name": "nova.instances",
            "description": "nova instances",
            "default_limit": 10,
            "service_id": "7ac03e",
            "links": {
                "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
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
            "id": "cea9c6",
            "name": "nova.instances",
            "description": "nova instances",
            "default_limit": 10,
            "service_id": "7ac03e",
            "links": {
                "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
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
                "id": "b55379",
                "resource": {
                    "id": "cea9c6",
                    "name": "nova.instances",
                    "description": "nova instances",
                    "default_limit": 10,
                    "service_id": "7ac03e",
                    "links": {
                        "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
                    }
                },
                "limit": 100,
                "links": {
                    "self": "http://identity:35357/v3/users/6ed0b4/OS-QUOTAS/quotas/b55379"
                }
            },
            {
                "id": "3a00eb",
                "resource": {
                    "id": "53bd34",
                    "name": "nova.ram",
                    "description": "nova instances",
                    "default_limit": 1024,
                    "service_id": "7ac03e",
                    "links": {
                        "self": "http://identity:35357/v3/OS-QUOTA/resources/53bd34"
                    }
                },
                "limit": 2048,
                "links": {
                    "self": "http://identity:35357/v3/users/6ed0b4/OS-QUOTAS/quotas/3a00eb"
                }
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/users/6ed0b4/OS-QUOTAS/quotas"
        }
    }

#### Get project quota list: `GET /projects/{project_id}/OS-QUOTAS/quotas`

Response:

    Status: 200 OK

    {
        "quotas": [
            {
                "id": "930428",
                "resource": {
                    "id": "cea9c6",
                    "name": "nova.instances",
                    "description": "nova instances",
                    "default_limit": 10,
                    "service_id": "7ac03e",
                    "links": {
                        "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
                    }
                },
                "limit": 100,
                "links": {
                    "self": "http://identity:35357/v3/projects/133f61/OS-QUOTAS/quotas/930428"
                }
            },
            {
                "id": "d39bf8",
                "resource": {
                    "id": "53bd34",
                    "name": "nova.ram",
                    "description": "nova instances",
                    "default_limit": 1024,
                    "service_id": "7ac03e",
                    "links": {
                        "self": "http://identity:35357/v3/OS-QUOTA/resources/53bd34"
                    }
                },
                "limit": 1024,
                "links": {
                    "self": "http://identity:35357/v3/projects/133f61/OS-QUOTAS/quotas/d39bf8"
                }
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/projects/133f61/OS-QUOTAS/quotas"
        }
    }

#### Create user quota: `POST /users/{user_id}/OS-QUOTAS/quotas`

Request:

    {
        "quota": {
            "resource_id": "cea9c6",
            "limit": 1024
        }
    }

Response:

    Status: 201 Created

    {
        "quota": {
            "id": "f0eae8",
            "resource": {
                "id": "cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10,
                "service_id": "7ac03e",
                "links": {
                    "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
                }
            },
            "limit": 100,
            "links": {
                "self": "http://identity:35357/v3/projects/133f61/OS-QUOTAS/quotas/f0eae8"
            }
        }
    }

#### Create project quota: `POST /projects/{project_id}/OS-QUOTAS/quotas`

Request:

    {
        "quota": {
            "resource_id": "cea9c6",
            "limit": 1024
        }
    }

Response:

    Status: 201 Created

    {
        "quota": {
            "id": "007af9",
            "resource": {
                "id": "cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10,
                "service_id": "7ac03e",
                "links": {
                    "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
                }
            },
            "limit": 1024,
            "links": {
                "self": "http://identity:35357/v3/projects/23cad3/OS-QUOTAS/quotas/007af9"
            }
        }
    }

#### Get user quota: `GET /users/{user_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 200 OK

    {
        "quota": {
            "id": "f0eae8",
            "resource": {
                "id": "cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10,
                "service_id": "7ac03e",
                "links": {
                    "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
                }
            },
            "limit": 1024,
            "links": {
                "self": "http://identity:35357/v3/users/6c9d43/OS-QUOTAS/quotas/007af9"
            }
        }
    }


#### Get project quota: `GET /projects/{project_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 200 OK

    {
        "quota": {
            "id": "007af9",
            "resource": {
                "id": "cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10,
                "service_id": "7ac03e",
                "links": {
                    "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
                }
            },
            "limit": 1024,
            "links": {
                "self": "http://identity:35357/v3/projects/133f61/OS-QUOTAS/quotas/007af9"
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
            "id": "f0eae8",
            "resource": {
                "id": "cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10,
                "service_id": "7ac03e",
                "links": {
                    "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
                }
            },
            "limit": 1024,
            "links": {
                "self": "http://identity:35357/v3/users/6c9d43/OS-QUOTAS/quotas/f0eae8"
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
            "id": "007af9",
            "resource": {
                "id": "cea9c6",
                "name": "nova.instances",
                "description": "nova instances",
                "default_limit": 10,
                "service_id": "7ac03e",
                "links": {
                    "self": "http://identity:35357/v3/OS-QUOTA/resources/cea9c6"
                }
            },
            "limit": 1024,
            "links": {
                "self": "http://identity:35357/v3/projects/f7b9d2/OS-QUOTAS/quotas/007af9"
            }
        }
    }

#### Delete user quota: `DELETE /users/{user_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 204 No Content

#### Delete project quota: `DELETE /projects/{project_id}/OS-QUOTAS/quotas/{quota_id}`

Response:

    Status: 204 No Content
