Add Support for SAML Authentication (Federation Pt. 3)
======================================================

Provide the ability for remote users who already have an account with an
external trusted SAML identity provider (IdP), to get a token to access
OpenStack services just like a local user.

This extension requires v3.0+ of the Identity API. OpenStack Identity V3 API

Definitions
-----------

API Changes
-------------

### The `saml` authentication method

If the Identity API client has been authenticated by a trusted identity provider,
it can request a token from the OpenStack Identity API service by presenting
assertions, and based on a successful validation of the assertions, the Identity
API client will be given an Identity API Service token. The client must send a
request to the Identity API service to validate the assertions received from the
identity provider. These should be contained in the `protocol_data` element.


1. Request. The client may ask the OpenStack Identity API service to provide it
   with a SAML authentication request for a specific identity
   provider(identified by its unique provider_id) which may have been returned in
   response to a List Identity Providers request - see Add IdP management
   extension (Federation pt1) - https://review.openstack.org/#/c/59846/.
   A SAML Authentication Assertion should be provided in the protocol_data field.


    Request:

        {
            "auth": {
                "identity": {
                    "saml": {
                        "phase": "request",
                        "protocol_data": [<any protocol specific data>],
                        "provider_id": "<provider-id>"
                    },
                    "methods": [
                        "saml"
                    ]
                }
            }
        }

    The response contains a SAML AuthnRequest in the "protocol_data"
    element, as well as confirmation of the identity provider and protocol. The
    client needs this information to contact the requested Identity Provider.

    Response:

        {
            "error": {
                "code": 401,
                "identity": {
                    "saml": {
                        "protocol_data": "<saml-authn-request>",
                        "provider_id": "<provider-id>"
                    },
                    "methods": [
                        "saml"
                    ]
                },
                "message": "Additional authentications steps required.",
                "title": "Unauthorized"
            }
        }

2. At the end of the SAML authentication flow, the client must request the OpenStack
   Identity API service to validate the assertions received from the identity
   provider. These should be contained in the "protocol_data" element.

    Request:

        {
            "auth": {
                "identity": {
                    "methods": [
                        "saml"
                    ],
                    "federated": {
                        "phase": "validate",
                        "provider_id": "<provider-id>",
                        "protocol_data": <saml-response>
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


### Tokens

Additional use case:

- Given a set of authentication and attribute assertions from one or more
  federated Identity Providers, get a token to represent the user.


#### Scope: `scope`

For federated authentication, scope is ignored in all phases except validate.

#### Authentication responses

Unless scope was specified in the request, a response to a federated
authentication validation request contains a token with a list of available
projects and domains.
