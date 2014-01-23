OpenStack Identity API v3 Federated Keystone Authentication Plugin
==================================================================

### The `keystone-ext` authentication method

The `keystone-ext` authentication method expects a valid scoped token issued by
an external trusted Keystone Identity Service to be passed in the `protocol_data`
parameter of the authentication request. Calls to validate a token should return
an unscoped token with a list of valid projects, or if scope was specified in
the request, a scoped token for the specified project.

If the user has not yet authenticated with the external service they may make a
call to the `keystone-ext` plugin specifying the phase to be 'request' to
retrieve authentication endpoint data about the external service.

1. No protocol specific request parameters are required for the Keystone
   profile to handle the issuing of an authentication request.

   Request:

        {
            "auth": {
                "identity": {
                    "keystone-ext": {
                        "phase": "request",
                        "provider_id": "123456"
                    },
                    "methods": [
                        "keystone-ext"
                    ]
                }
            }
        }

    The response for the Keystone profile must contain the endpoint of the
    remote Keystone identity provider within the protocol_data field.

    Response:

        {
            "error": {
                "code": 401,
                "identity": {
                    "keystone-ext": {
                        "protocol_data": [
                            {
                                "endpoint": "https://keystoneZ.com:5000/v3/auth"
                            }
                        ],
                        "provider_id": "123456"
                    },
                    "methods": [
                        "keystone-ext"
                    ]
                },
                "message": "Additional authentication steps required.",
                "title": "Unauthorized"
            }
        }

2. The `keystone-ext` plugin expects that the `protocol_data` provided during
   the validation phase contains a Keystone token either in PKI format or as a
   UUID. If a PKI token is returned, then the implementation will need to have
   access to the CA certificate and public key certificate of the Keystone IDP.
   If a UUID token is returned, then the implementation will need the login
   details of an admin user for the Keystone IDP in order to check that the
   token is valid.

   Request:

        {
            "auth": {
                "identity": {
                    "keystone-ext": {
                        "phase": "validate",
                        "protocol_data": [
                            {"<provider_id>": "<keystone token>"}
                        ],
                    },
                    "methods": [
                        "keystone-ext"
                    ]
                }
            }
        }

    The response contains an unscoped token with a list of available projects
    and domains nested in the "OS-FEDERATED" element, unless scope was specified
    in the request, then a normal scoped token is returned instead. An example
    response to validate a request (where the scope was not specified) is

    Response:

        {
            "token": {
                "comment": "Example OpenStack token responses can be found
                [here] (https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses)",
                "OS-FEDERATED": {
                    "projects": [
                        {
                            "domain": {
                                "id": "1789d1",
                                "links": {
                                    "self": "http://identity:35357/v3/domains/1789d1"
                                },
                                "name": "example.com"
                            },
                            "id": "263fd9",
                            "links": {
                                "self": "http://identity:35357/v3/projects/263fd9"
                            },
                            "name": "project-x"
                        },
                        {
                            "domain": {
                                "id": "1789d1",
                                "links": {
                                    "self": "http://identity:35357/v3/domains/1789d1"
                                },
                                "name": "example.com"
                            },
                            "id": "123456",
                            "links": {
                                "self": "http://identity:35357/v3/projects/123456"
                            },
                            "name": "project-x2"
                        }
                    ]
                }
            }
        }

