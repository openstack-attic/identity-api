OpenStack Identity API v3 OS-ENDPOINT-POLICY Extension
======================================================

This extension provides associations between service endpoints and
policies that are already stored in the Identity server and referenced
by policy ID. Such associations enable an endpoint to request the
appropriate policy for itself. Three types of association are supported:

-  A policy associated to a specific endpoint
-  A policy associated to any endpoint of a given service type in a
   given region
-  A policy associated to any endpoint of a given service type

When an endpoint requests the appropriate policy for itself, the
extension will look for an association *in the order given above* (which
is essentially in order from most specific to least specific) and select
the first one it finds. For region associations, any parent regions will
also be examined in ascending order. No combination of polices will
occur.

Policy-Endpoint Associations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create association with endpoint
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    PUT /policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}

Creates an association between the policy and the endpoint. If another
association already existed for the specified endpoint, this will
replace that association. Any body supplied with this API will be
ignored.

Response:

::

    Status: 204 No Content

Check association with endpoint
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}

Verifies the existence of an association between a policy and an
endpoint. A HEAD version of this API is also supported.

Response:

::

    Status: 204 No Content

Delete association with endpoint
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    DELETE /policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}

Deletes an association between the policy and the endpoint.

Response:

::

    Status: 204 No Content

Create association with service
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    PUT /policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}

Creates an association between the policy and the service. If another
association already existed for the specified service, this will replace
that association. Any body supplied with this API will be ignored.

Response:

::

    Status: 204 No Content

Check association with service
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}

Verifies the existence of an association between a policy and a service.
A HEAD version of this API is also supported.

Response:

::

    Status: 204 No Content

Delete association with service
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    DELETE /policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}

Deletes an association between the policy and the service.

Response:

::

    Status: 204 No Content

Create association with service in a region
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    PUT /policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}

Creates an association between the policy and the service in the given
region. If another association already existed for the specified service
and region, this will replace that association. Any body supplied with
this API will be ignored.

Response:

::

    Status: 204 No Content

Check association with service in a region
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}

Verifies the existence of an association between a policy and a service
in the given region. A HEAD version of this API is also supported.

Response:

::

    Status: 204 No Content

Delete association with service in a region
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    DELETE /policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}

Deletes an association between the policy and the service in the given
region.

Response:

::

    Status: 204 No Content

List effective endpoint associations for policy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints

Returns all the endpoints that are currently associated with a specific
policy via any of the association methods.

Response:

::

    Status: 200 OK

    {
        "endpoints": [
            {
                "id": "--endpoint-id--",
                "interface": "public",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/--endpoint-id--"
                },
                "region": "north",
                "service_id": "--service-id--",
                "url": "http://identity:35357/"
            },
            {
                "id": "--endpoint-id--",
                "interface": "internal",
                "links": {
                    "self": "http://identity:35357/v3/endpoints/--endpoint-id--"
                },
                "region": "south",
                "service_id": "--service-id--",
                "url": "http://identity:35357/"
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-ENDPOINT-POLICY/policies/{policy_id}/endpoints"
        }
    }

Get effective policy associated with endpoint
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /endpoints/{endpoint_id}/OS-ENDPOINT-POLICY/policy

Returns the policy that is currently associated with the given endpoint,
by working through the ordered sequence of methods of association. The
first association that is found will be returned. If the region of the
endpoint has a parent, then region associations will be examined up the
region tree in ascending order.

Response:

::

    Status: 200 OK

    {
        "policy": {
            "blob": "--serialized-blob--",
            "id": "--policy-id--",
            "links": {
                "self": "http://identity:35357/v3/policies/--policy-id--"
            },
            "type": "--serialization-mime-type--"
        }
    }

Check if a policy is associated with endpoint
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    HEAD /endpoints/{endpoint_id}/OS-ENDPOINT-POLICY/policy

Checks if a policy is currently associated with the given endpoint.

Response:

::

    Status: 200 OK

