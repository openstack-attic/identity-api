OpenStack Identity API v3 OS-EP-FILTER Extension
================================================

This extension enables creation of ad-hoc catalogs for each project-scoped
token request. To do so, this extension uses either static project-endpoint
associations or dynamic custom endpoints groups to associate service endpoints
with projects.

API Resources
-------------

### Endpoint Group

Represents a dynamic collection of service endpoints having the same
characteristics, such as service, type, or region. Indeed, any endpoint
attribute could be used as part of a filter. A classic use case is to filter
endpoints based on region. For example, suppose I want to filter service
endpoints returned in the service catalog by region:

    {
        "endpoint_group": {
            "description": "Example Endpoint Group",
            "filters": {
                "region": "US-West"
            },
            "name": "EP-GROUP-1"
        }
    }

This implies an Endpoint Group with filtering criteria of the form:

    region = "US-West"

API
---

### Project-Endpoint Associations

If a valid X-Auth-Token token in not present in the HTTP header and/or the user
does not have the right authorization a HTTP 401 Unauthorized is returned.

#### Create Association: `PUT /OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}`

Modifies the endpoint resource adding an association between the project and
the endpoint.

Response:

    Status: 204 No Content

#### Check Association: `HEAD /OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}`

Verifies the existence of an association between a project and an endpoint.

Response:

    Status: 204 No Content

#### List Associations for Project: `GET /OS-EP-FILTER/projects/{project_id}/endpoints`

Returns all the endpoints that are currently associated with a specific project.

Response:

    Status: 200 OK
    {
        "endpoints":
        [
            {
                "id": "--endpoint-id--",
                "interface": "public",
                "url": "http://identity:35357/",
                "region": "north",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/--endpoint-id--"
                },
                "service_id": "--service-id--"
            },
            {
                "id": "--endpoint-id--",
                "interface": "internal",
                "region": "south",
                "url": "http://identity:35357/",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/--endpoint-id--"
                },
                "service_id": "--service-id--"
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/OS-EP-FILTER/projects/{project_id}/endpoints",
            "previous": null,
            "next": null
        }
    }

#### Delete Association: `DELETE /OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}`

Eliminates a previously created association between a project and an endpoint.

Response:

    Status: 204 No Content

#### Get projects associated with endpoint: `GET /OS-EP-FILTER/endpoints/{endpoint_id}/projects`

Returns a list of projects that are currently associated with the given endpoint.

Response:

    Status: 200 OK

    {
        "projects":
        [
            {
                "domain_id": "--domain-id--",
                "enabled": true,
                "id": "--project-id--",
                "links": {
                     "self": "http://identity:35357/v3/projects/--project-id--"
                },
                "name": "a project name 1",
                "description": "a project description 1"
            },
            {
                "domain_id": "--domain-id--",
                "enabled": true,
                "id": "--project-id--",
                "links": {
                     "self": "http://identity:35357/v3/projects/--project-id--"
                },
                "name": "a project name 2",
                "description": "a project description 2"
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/OS-EP-FILTER/endpoints/--endpoint-id--/projects",
            "previous": null,
            "next": null
        },
   }

### Endpoint Groups

#### Create Endpoint Group Filter: `POST /OS-EP-FILTER/endpoint_groups`

Request:

    {
        "endpoint_group": {
            "description": "Example Endpoint Group",
            "filters": {
                "interface": "admin",
                "service_id": "2942f5baccdf4384b5d58adfd3de86d2"
            }
            "name": "EP-FILTER-1",
        }
    }

Response:

    Status: 201 Created

    {
        "endpoint_group": {
            "description": "Example Endpoint Group",
             "filters": {
                "interface": "admin",
                "service_id": "2942f5baccdf4384b5d58adfd3de86d2"
            },
            "id": "c8fcf2a34c8440b9894356e42bab11ca",
            "links": {
                "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/c8fcf2a34c8440b9894356e42bab11ca"
            },
            "name": "EP-FILTER-1"
        }
    }

#### Get Endpoint Group: `GET /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}`

Response:

    Status: 200 OK

    {
        "endpoint_group": {
            "description": "Example Endpoint Group",
            "filters": {
                "interface": "admin",
                "service_id": "2942f5baccdf4384b5d58adfd3de86d2"
            },
            "id": "c8fcf2a34c8440b9894356e42bab11ca",
            "links": {
                "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/c8fcf2a34c8440b9894356e42bab11ca"
            },
            "name": "EP-FILTER-1"
        }
    }

#### Update Endpoint Group: `PATCH /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}`

The request block is the same as the one for create endpoint group, except
that only the attributes that are being updated need to be included.

Request:

    {
        "endpoint_group": {
            "description": "Example Endpoint Group",
            "filters": {
                "interface": "internal",
                "service_id": "2942f5baccdf4384b5d58adfd3de86d2"
            },
            "name": "EPG1"
        }
    }

Response:

    Status: 200 OK

    {
        "endpoint_group": {
            "description": "Example Endpoint Group",
            "filters": {
                "interface": "admin",
                "service_id": "2942f5baccdf4384b5d58adfd3de86d2"
            },
            "id": "c8fcf2a34c8440b9894356e42bab11ca",
            "links": {
                "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/c8fcf2a34c8440b9894356e42bab11ca"
            },
            "name": "EPG1"
        }
    }

#### Remove Endpoint Group: `DELETE /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}`

Response:

    Status: 204 No Content

#### List All Endpoint Groups: `GET /OS-EP-FILTER/endpoint_groups`

Optional query parameters:

* project_id (string)

Response:

    Status: 200 OK

    {
        "endpoint_groups": [
            {
                "endpoint_group": {
                    "description": "Demo",
                    "filters": {
                        "interface": "admin",
                        "service_id": "2942f5baccdf4384b5d58adfd3de86d2"
                    },
                    "id": "c8fcf2a34c8440b9894356e42bab11ca",
                    "links": {
                        "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/115c9932ab514862b36b9358841e593b"
                    },
                    "name": "EPG-Test1"
                }
            },
            {
                "endpoint_group": {
                    "description": "Demo2",
                    "filters": {
                        "interface": "admin"
                    },
                    "id": "fd74093dff874850af7eafea4e593f55",
                    "links": {
                        "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/115c9932ab514862b36b9358841e593b"
                    },
                    "name": "EPG-Test2"
                }
            }
        ]
    }

### Project to Endpoint Group Relationship

#### Create Endpoint Group to Project Association: `PUT /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}`

Response:

    Status: 204 No Content

#### Get Endpoint Group to Project Association: `GET /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}`

Response:

    Status: 200 OK

    {
        "project_id": "c2a6276042e841c2a3a201990e5a0499"
    }

#### Check Endpoint Group to Project Association: `HEAD /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}`

Response:

    Status: 200 OK

#### Delete Endpoint Group to Project Association: `DELETE /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}`

Response:

    Status: 204 No Content

#### List Projects Associated with Endpoint Group: `GET /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects`

Response:

    Status: 200 OK

    {
        "endpoint_group_id": "b4f31c9de61a46e5bfa53a83e4b02ce7",
        "projects": [
            {
                "project_id": "c2a6276042e841c2a3a201990e5a0499"
            }
        ]
    }

#### List Service Endpoints Associated with Endpoint Group: `GET /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/endpoints`

Response:

    Status: 200 OK

    [
        {
            "enabled": true,
            "id": "03ea620d1d5d45c7b559d3cf7942eccc"
            "interface": "admin",
            "legacy_endpoint_id": "12c2404183044e27a6ee2d19f77e4b77",
            "region": "RegionOne",
            "service_id": "49ba741863044724a7f34b87b3bfebe0",
            "url": "http://localhost:9292"
        },
        {
            "enabled": true,
            "id": "0a990d304b27444bab0c08f6b02aae34"
            "interface": "internal",
            "legacy_endpoint_id": "12c2404183044e27a6ee2d19f77e4b77",
            "region": "RegionOne",
            "service_id": "49ba741863044724a7f34b87b3bfebe0",
            "url": "http://localhost:9292"
        },
            {
            "enabled": true,
            "id": "88a9fca7969043c7a539b65b4a06dd57"
            "interface": "public",
            "legacy_endpoint_id": "12c2404183044e27a6ee2d19f77e4b77",
            "region": "RegionOne",
            "service_id": "49ba741863044724a7f34b87b3bfebe0",
            "url": "http://localhost:9292"
        }
    ]
