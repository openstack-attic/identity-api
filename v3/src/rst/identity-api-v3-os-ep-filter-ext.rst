OpenStack Identity API v3 OS-EP-FILTER Extension
================================================

This extension enables creation of ad-hoc catalogs for each
project-scoped token request. To do so, this extension uses either
static project-endpoint associations or dynamic custom endpoints groups
to associate service endpoints with projects.

What's New in Version 1.1
-------------------------

These features are not yet considered stable (expected September 4th,
2014).

-  Introduced support for Endpoint Groups

API Resources
-------------

*New in version 1.1*

Endpoint Group
~~~~~~~~~~~~~~

Represents a dynamic collection of service endpoints having the same
characteristics, such as service\_id, interface, or region. Indeed, any
endpoint attribute could be used as part of a filter.

A classic use case is to filter endpoints based on region. For example,
suppose a user wants to filter service endpoints returned in the service
catalog by region, the following endpoint group may be used:

::

    {
        "endpoint_group": {
            "description": "Example Endpoint Group",
            "filters": {
                "region_id": "e68c72"
            },
            "name": "EP-GROUP-1"
        }
    }

This implies an Endpoint Group with filtering criteria of the form:

::

    region_id = "e68c72"

API
---

Project-Endpoint Associations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If a valid X-Auth-Token token in not present in the HTTP header and/or
the user does not have the right authorization a HTTP 401 Unauthorized
is returned.

Create Association
^^^^^^^^^^^^^^^^^^

::

    PUT /OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/project_endpoint``

Modifies the endpoint resource adding an association between the project
and the endpoint.

Response:

::

    Status: 204 No Content

Check Association
^^^^^^^^^^^^^^^^^

::

    HEAD /OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/project_endpoint``

Verifies the existence of an association between a project and an
endpoint.

Response:

::

    Status: 204 No Content

List Associations for Project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /OS-EP-FILTER/projects/{project_id}/endpoints

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/project_endpoints``

Returns all the endpoints that are currently associated with a specific
project.

Response:

::

    Status: 200 OK
    {
        "endpoints": [
            {
                "id": "6fedc0",
                "interface": "public",
                "url": "http://identity:35357/",
                "region": "north",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/6fedc0"
                },
                "service_id": "1b501a"
            },
            {
                "id": "6fedc0",
                "interface": "internal",
                "region": "south",
                "url": "http://identity:35357/",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/6fedc0"
                },
                "service_id": "1b501a"
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/OS-EP-FILTER/projects/{project_id}/endpoints",
            "previous": null,
            "next": null
        }
    }

Delete Association
^^^^^^^^^^^^^^^^^^

::

    DELETE /OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/project_endpoint``

Eliminates a previously created association between a project and an
endpoint.

Response:

::

    Status: 204 No Content

Get projects associated with endpoint
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /OS-EP-FILTER/endpoints/{endpoint_id}/projects

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_projects``

Returns a list of projects that are currently associated with the given
endpoint.

Response:

::

    Status: 200 OK

    {
        "projects": [
            {
                "domain_id": "1789d1",
                "enabled": true,
                "id": "263fd9",
                "links": {
                     "self": "http://identity:35357/v3/projects/263fd9"
                },
                "name": "a project name 1",
                "description": "a project description 1"
            },
            {
                "domain_id": "1789d1",
                "enabled": true,
                "id": "61a1b7",
                "links": {
                     "self": "http://identity:35357/v3/projects/61a1b7"
                },
                "name": "a project name 2",
                "description": "a project description 2"
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/OS-EP-FILTER/endpoints/6fedc0/projects",
            "previous": null,
            "next": null
        }

}

Endpoint Groups
~~~~~~~~~~~~~~~

*New in version 1.1*

Required attributes:

-  ``name`` (string)

User-facing name of the service.

-  ``filters`` (object)

Describes the filtering performed by the endpoint group. The filter used
must be an ``endpoint`` property, such as ``interface``, ``service_id``,
``region_id`` and ``enabled``. Note that if using ``interface`` as a
filter, the only available values are ``public``, ``internal`` and
``admin``.

Optional attributes:

-  ``description`` (string)

User-facing description of the service.

Create Endpoint Group Filter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    POST /OS-EP-FILTER/endpoint_groups

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_groups``

Request:

::

    {
        "endpoint_group": {
            "description": "endpoint group description",
            "filters": {
                "interface": "admin",
                "service_id": "1b501a"
            }
            "name": "endpoint group name",
        }
    }

Response:

::

    Status: 201 Created

    {
        "endpoint_group": {
            "description": "endpoint group description",
             "filters": {
                "interface": "admin",
                "service_id": "1b501a"
            },
            "id": "ac4861",
            "links": {
                "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/ac4861"
            },
            "name": "endpoint group name"
        }
    }

Get Endpoint Group
^^^^^^^^^^^^^^^^^^

::

    GET /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_group``

Response:

::

    Status: 200 OK

    {
        "endpoint_group": {
            "description": "endpoint group description",
            "filters": {
                "interface": "admin",
                "service_id": "1b501a"
            },
            "id": "ac4861",
            "links": {
                "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/ac4861"
            },
            "name": "endpoint group name"
        }
    }

Check Endpoint Group
^^^^^^^^^^^^^^^^^^^^

::

    HEAD /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_group``

Response:

::

    Status: 200 OK

Update Endpoint Group
^^^^^^^^^^^^^^^^^^^^^

::

    PATCH /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_group``

The request block is the same as the one for create endpoint group,
except that only the attributes that are being updated need to be
included.

Request:

::

    {
        "endpoint_group": {
            "description": "endpoint group description",
            "filters": {
                "interface": "admin",
                "service_id": "1b501a"
            },
            "name": "endpoint group name"
        }
    }

Response:

::

    Status: 200 OK

    {
        "endpoint_group": {
            "description": "endpoint group description",
            "filters": {
                "interface": "admin",
                "service_id": "1b501a"
            },
            "id": "ac4861",
            "links": {
                "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/ac4861"
            },
            "name": "endpoint group name"
        }
    }

Remove Endpoint Group
^^^^^^^^^^^^^^^^^^^^^

::

    DELETE /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_group``

Response:

::

    Status: 204 No Content

List All Endpoint Groups
^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /OS-EP-FILTER/endpoint_groups

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_groups``

Response:

::

    Status: 200 OK

    {
        "endpoint_groups": [
            {
                "endpoint_group": {
                    "description": "endpoint group description #1",
                    "filters": {
                        "interface": "admin",
                        "service_id": "1b501a"
                    },
                    "id": "ac4861",
                    "links": {
                        "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/ac4861"
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
                    "id": "3de68c",
                    "links": {
                        "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/3de68c"
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

List Endpoint Groups Associated with Project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /OS-EP-FILTER/endpoint_groups/projects/{project_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/project_endpoint_groups``

Response:

::

    Status: 200 OK

    {
        "endpoint_groups": [
            {
                "endpoint_group": {
                    "description": "endpoint group description #1",
                    "filters": {
                        "interface": "admin",
                        "service_id": "1b501a"
                    },
                    "id": "ac4861",
                    "links": {
                        "self": "http://localhost:35357/v3/OS-EP-FILTER/endpoint_groups/ac4861"
                    },
                    "name": "endpoint group name #1"
                }
            }
        ],
        "links": {
            "self": "https://identity:35357/v3/OS-EP-FILTER/endpoint_groups",
            "previous": null,
            "next": null
        }
    }

Project to Endpoint Group Relationship
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create Endpoint Group to Project Association
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    PUT /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_group_project``

Response:

::

    Status: 204 No Content

Get Endpoint Group to Project Association
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_group_project``

Response:

::

    Status: 200 OK

    {
        "project": {
            "domain_id": "1789d1",
            "enabled": true,
            "id": "263fd9",
            "links": {
                "self": "http://identity:35357/v3/projects/263fd9"
            },
            "name": "project name #1",
            "description": "project description #1"
        }
    }

Check Endpoint Group to Project Association
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    HEAD /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_group_project``

Response:

::

    Status: 200 OK

Delete Endpoint Group to Project Association
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    DELETE /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_group_project``

Response:

::

    Status: 204 No Content

List Projects Associated with Endpoint Group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_group_projects``

Response:

::

    Status: 200 OK

    {
        "projects": [
            {
                "domain_id": "1789d1",
                "enabled": true,
                "id": "263fd9",
                "links": {
                     "self": "http://identity:35357/v3/projects/263fd9"
                },
                "name": "a project name 1",
                "description": "a project description 1"
            },
            {
                "domain_id": "1789d1",
                "enabled": true,
                "id": "61a1b7",
                "links": {
                     "self": "http://identity:35357/v3/projects/61a1b7"
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

List Service Endpoints Associated with Endpoint Group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/endpoints

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-EP-FILTER/1.0/rel/endpoint_group_endpoints``

Response:

::

    Status: 200 OK

    {
        "endpoints": [
            {
                "enabled": true,
                "id": "6fedc0"
                "interface": "admin",
                "legacy_endpoint_id": "6fedc0",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/6fedc0"
                },
                "region": "RegionOne",
                "service_id": "1b501a",
                "url": "http://localhost:9292"
            },
            {
                "enabled": true,
                "id": "b501aa"
                "interface": "internal",
                "legacy_endpoint_id": "b501aa",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/b501aa"
                },
                "region": "RegionOne",
                "service_id": "1b501a",
                "url": "http://localhost:9292"
            },
            {
                "enabled": true,
                "id": "b7c573"
                "interface": "public",
                "legacy_endpoint_id": "b7c573",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/b7c573"
                },
                "region": "RegionOne",
                "service_id": "1b501a",
                "url": "http://localhost:9292"
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/endpoints",
            "previous": null,
            "next": null
        }
    }

