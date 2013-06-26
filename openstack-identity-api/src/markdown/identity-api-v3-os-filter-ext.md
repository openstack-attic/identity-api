OpenStack Identity API v3 OS-FILTER Extension
============================================

Filter provides associations between service endpoints and projects. 
These assciations are then used to create ad-hoc catalogs for each project-scoped
token request.

API
---

### Project-Endpoint Associations

If a valid X-Auth-Token token in not present in the HTTP header and/or the user
does not have the right authorization a HTTP 401 Unauthorized is returned.

#### Create Association: `PUT /OS-FILTER/projects/{project_id}/endpoints/{endpoint_id}`

Creates an association between the project and the endpoint.

Response:

    Status: 204 No Content

#### Check Association: `HEAD /OS-FILTER/projects/{project_id}/endpoints/{endpoint_id}`

Verifies the existence of an association between a project and an endpoint.

Response:

    Status: 204 No Content

#### List Associations for Project: `GET /OS-FILTER/projects/{project_id}/endpoints`

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
            "self": "http://identity:35357/v3/OS-FILTER/projects/{project_id}/endpoints",
            "previous": null,
            "next": null
        }
    }

#### Delete Association: `DELETE /OS-FILTER/projects/{project_id}/endpoints/{endpoint_id}`

Eliminates a previously created association between a project and an endpoint.

Response:

    Status: 204 No Content

#### Get projects associated with endpoint: `GET /OS-FILTER/endpoints/{endpoint_id}/projects`

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
            "self": "http://identity:35357/v3/OS-FILTER/endpoints/--endpoint-id--/projects",
            "previous": null,
            "next": null
        },
   }
