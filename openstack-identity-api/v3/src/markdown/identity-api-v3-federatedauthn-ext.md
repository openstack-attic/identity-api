Add Support for SAML Authentication (Federation Pt. 3)
======================================================

Provide the ability for remote users who already have an account with an
external trusted SAML identity provider (IdP), to get a token to access
OpenStack services just like a local user.

This extension requires v3.0+ of the Identity API.

API Changes
-----------

### The `saml` authentication method

If the Identity API client has not yet been authenticated then it can request
a SAML AuthnRequest message for a specific identity provider to be created by
OpenStack Identity API service. The response to this request should contain a
`protocol_data` element containing the generated AuthnRequest.

If the Identity API client has been authenticated by a trusted SAML identity
provider, it can request a token from the OpenStack Identity API service by
presenting one or more signed SAML assertions, and based on a successful
validation of the assertion(s), the Identity API client will be given an
Identity API Service token. The client must send a request to the Identity API
service to validate the SAML assertion(s) received from the identity
provider(s). These should be contained in the `protocol_data` element.

1. Request. The client may ask the OpenStack Identity API service to provide it
   with a SAML authentication request for a specific identity
   provider (identified by its unique provider_id) which may have been returned
   in response to a List Identity Providers request - see Add IdP management
   extension (Federation pt1) - http://git.openstack.org/cgit/openstack/identity-api/commit/?id=97cbc67c0e6f8bba6a1e99214af25c5a616fb17a
   A SAML Authentication Request should be provided in the protocol_data field.


    Request:

        {
            "auth": {
                "identity": {
                    "methods": [
                        "saml"
                    ],
                    "saml": {
                        "phase": "request",
                        "provider_id": "<provider-id>"
                    }
                }
            }
        }

    The response contains a SAML AuthnRequest in the "protocol_data"
    element, as well as confirmation of the identity provider. The
    client needs this information to contact the requested Identity Provider.

    Response:

        {
            "error": {
                "code": 401,
                "identity": {
                    "methods": [
                        "saml"
                    ],
                    "saml": {
                        "protocol_data": "<saml-authn-request>",
                        "provider_id": "<provider-id>"
                    }
                },
                "message": "Additional authentications steps required.",
                "title": "Unauthorized"
            }
        }

2. Validate. At the end of the SAML authentication flow, the client may request
   the OpenStack Identity API service to provide a token based on the successful
   validation of the assertion(s) received from the SAML identity provider(s).
   These should be contained in the "protocol_data" element.

    Request:

        {
            "auth": {
                "identity": {
                    "methods": [
                        "saml"
                    ],
                    "saml": {
                        "phase": "validate",
                        "protocol_data": [
                            {"<provider_id>": "<saml_assertion>"},
                            {"<provider_id2>": "<saml_assertion2>"}
                        ]
                    }
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
                            "id": "12dfe2",
                            "links": {
                                "self": "http://identity:35357/v3/projects/12dfe2"
                            },
                            "name": "project-x2"
                        }
                    ]
                }
            }
        }