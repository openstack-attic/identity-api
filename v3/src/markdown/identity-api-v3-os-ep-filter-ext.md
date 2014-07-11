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
characteristics, such as service_id, interface, or region. Indeed, any
endpoint attribute could be used as part of a filter.

A classic use case is token filter endpoints based on region. For example,
suppose I want to filter service endpoints returned in the service catalog by
region:

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
        "endpoints": [
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
        "projects": [
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
        }
   }

### Endpoint Groups

#### Create Endpoint Group Filter: `POST /OS-EP-FILTER/endpoint_groups`

Request:

    {
        "endpoint_group": {
            "description": "endpoint group description",
            "filters": {
                "interface": "admin",
                "service_id": "--service-id"
            }
            "name": "endpoint group name",
        }
    }

Response:

    Status: 201 Created

    {
        "endpoint_group": {
            "description": "endpoint group description",
             "filters": {
                "interface": "admin",
                "service_id": "--service-id"
            },
            "id": "--endpoint-group-id--",
            "links": {
                "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/--endpoint-group-id--"
            },
            "name": "endpoint group name"
        }
    }

#### Get Endpoint Group: `GET /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}`

Response:

    Status: 200 OK

    {
        "endpoint_group": {
            "description": "endpoint group description",
            "filters": {
                "interface": "admin",
                "service_id": "--service-id"
            },
            "id": "--endpoint-group-id--",
            "links": {
                "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/--endpoint-group-id--"
            },
            "name": "endpoint group name"
        }
    }

#### Check Endpoint Group: `HEAD /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}`

Response:

    Status: 200 OK

#### Update Endpoint Group: `PATCH /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}`

The request block is the same as the one for create endpoint group, except
that only the attributes that are being updated need to be included.

Request:

    {
        "endpoint_group": {
            "description": "endpoint group description",
            "filters": {
                "interface": "admin",
                "service_id": "--service-id"
            },
            "name": "endpoint group name"
        }
    }

Response:

    Status: 200 OK

    {
        "endpoint_group": {
            "description": "endpoint group description",
            "filters": {
                "interface": "admin",
                "service_id": "--service-id"
            },
            "id": "--endpoint-group-id--",
            "links": {
                "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/--endpoint-group-id--"
            },
            "name": "endpoint group name"
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
                    "description": "endpoint group description #1",
                    "filters": {
                        "interface": "admin",
                        "service_id": "--service-id--"
                    },
                    "id": "--endpoint-group-id--",
                    "links": {
                        "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/--endpoint-group-id--"
                    },
                    "name": "endpoint group name #1"
                }
            },
            {
                "endpoint_group": {
                    "description": "endpoint group description #2",
                    "filters": {
                        "interface": "admin"
                    },
                    "id": "--endpoint-group-id--",
                    "links": {
                        "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/--endpoint-group-id--"
                    },
                    "name": "endpoint group name #2"
                }
            }
        ],
        "links": {
            "self": "https://identity:35357/v3/OS-EP-FILTER/endpoint_groups",
            "previous": null,
            "next": null
        }
    }

### Project to Endpoint Group Relationship

#### Create Endpoint Group to Project Association: `PUT /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}`

Response:

    Status: 204 No Content

#### Get Endpoint Group to Project Association: `GET /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}`

Response:

    Status: 200 OK

    {
        "project": {
            "domain_id": "--domain-id--",
            "enabled": true,
            "id": "--project-id--",
            "links": {
                "self": "http://identity:35357/v3/projects/--project-id--"
            },
            "name": "project name #1",
            "description": "project description #1"
        }
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
        "projects": [
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
            "self": "http://identity:35357/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects",
            "previous": null,
            "next": null
        }
    }

#### List Service Endpoints Associated with Endpoint Group: `GET /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/endpoints`

Response:

    Status: 200 OK

    {
        "endpoints": [
            {
                "enabled": true,
                "id": "--endpoint-id--"
                "interface": "admin",
                "legacy_endpoint_id": "--endpoint-id--",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/--endpoint-id--"
                },
                "region": "RegionOne",
                "service_id": "--service-id--",
                "url": "http://localhost:9292"
            },
            {
                "enabled": true,
                "id": "--endpoint-id--"
                "interface": "internal",
                "legacy_endpoint_id": "--endpoint-id--",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/--endpoint-id--"
                },
                "region": "RegionOne",
                "service_id": "--service-id--",
                "url": "http://localhost:9292"
            },
            {
                "enabled": true,
                "id": "--endpoint-id--"
                "interface": "public",
                "legacy_endpoint_id": "--endpoint-id--",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/--endpoint-id--"
                },
                "region": "RegionOne",
                "service_id": "--service-id--",
                "url": "http://localhost:9292"
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/endpoints",
            "previous": null,
            "next": null
        }
    }
