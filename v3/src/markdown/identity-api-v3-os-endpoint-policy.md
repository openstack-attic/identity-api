OpenStack Identity API v3 OS-ENDPOINT-POLICY Extension
======================================================

This extension provides associations between service endpoints and policies
that are already stored in the Identity server and referenced by policy ID.
Such associations enable an endpoint to request the appropriate policy for
itself.  Three types of association are supported:

- A policy associated to a specific endpoint
- A policy associated to any endpoint of a given service type in a given
region
- A policy associated to any endpoint of a given service type

When an endpoint requests the appropriate policy for itself, the extension will
look for an association *in the order given above* and select the first one
it finds. For region associations, any parent regions will also be examined
in ascending order. No combination of polices will occur.

---

### Policy-Endpoint Associations

If a valid X-Auth-Token token in not present in the HTTP header and/or the user
does not have the right authorization a HTTP 401 Unauthorized is returned. If
any of the entity IDs included in the API urls are not found, an HTTP 404 Not
Found will be returned.

#### Create association with endpoint: `PUT /OS-ENDPOINT-POLICY/policies/{policy_id}/endpoints/{endpoint_id}`

Creates an association between the policy and the endpoint. If another
association already existed for the specified endpint, this will be
overwritten.

Response:

    Status: 204 No Content

#### Check association with endpoint: `HEAD /OS-ENDPOINT-POLICY/policies/{policy_id}/endpoints/{endpoint_id}`

Verifies the existence of an association between a policy and an endpoint.

Response:

    Status: 200 OK

#### Delete association with endpoint: `DELETE /OS-ENDPOINT-POLICY/policies/{policy_id}/endpoints/{endpoint_id}`

Deletes an association between the policy and the endpoint.

Response:

    Status: 204 No Content

#### Create association with service: `PUT /OS-ENDPOINT-POLICY/policies/{policy_id}/services/{service_id}`

Creates an association between the policy and the service. If another
association already existed for the specified service, this will be
overwritten.

Response:

    Status: 204 No Content

#### Check association with service: `HEAD /OS-ENDPOINT-POLICY/policies/{policy_id}/services/{service_id}`

Verifies the existence of an association between a policy and a service.

Response:

    Status: 200 OK

#### Delete association with service: `DELETE /OS-ENDPOINT-POLICY/policies/{policy_id}/services/{service_id}`

Deletes an association between the policy and the service.

Response:

    Status: 204 No Content

#### Create association with service in a region: `PUT /OS-ENDPOINT-POLICY/policies/{policy_id}/services/{service_id}/regions/{region_id}`

Creates an association between the policy and the service in the given region.
If another association already existed for the specified service and region,
this will be overwritten.

Response:

    Status: 204 No Content

#### Check association with service in a region: `HEAD /OS-ENDPOINT-POLICY/policies/{policy_id}/services/{service_id}/regions/{region_id}`

Verifies the existence of an association between a policy and a service in the
given region.

Response:

    Status: 200 OK

#### Delete association with service in a region: `DELETE /OS-ENDPOINT-POLICY/policies/{policy_id}/services/{service_id}/regions/{region_id}`

Deletes an association between the policy and the service in the given region.

Response:

    Status: 204 No Content

#### List effective enpoint associations for policy: `GET /OS-ENDPOINT-POLICY/policies/{policy_id}/endpoints`

Returns all the endpoints that are currently associated with a specific policy
via any of the association methods.

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
            "self": "http://identity:35357/v3/OS-ENDPOINT-POLICY/policies/{policy_id}/endpoints",
            "previous": null,
            "next": null
        }
    }

#### Get effective policy associated with endpoint: `GET /OS-ENDPOINT-POLICY/endpoints/{endpoint_id}/policy`

Returns the policy that is currently associated with the given endpoint, by
working through the ordered sequence of methods of association. The first
association that is found will be returned. If the region of the endpoint has
a parent, then region associations will be examined up the region tree in
ascending order.

Response:

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
