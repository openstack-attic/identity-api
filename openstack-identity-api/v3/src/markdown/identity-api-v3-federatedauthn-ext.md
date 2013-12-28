Add Support for Federated Authentication (Pt 3)
===============================================

Provide the ability for remote users who already have an account with an
external trusted identity provider (IdP), to get a token to access OpenStack
services just like a local user.

This extension requires v3.0+ of the Identity API. OpenStack Identity V3 API
is playing the role of the federated service provider (SP).

Definitions
-----------

*Local Identity:* An Identity managed internally by Keystone or OpenStack
  Identity API service instance.
*Remote Identity:* An Identity managed by a trusted identity provider.

Support for different federation protocols
------------------------------------------

This document describes federation in a protocol independent way. 'Federated
authentication and authorization' comprises of up to three phases, namely:
request, negotiate and validate. Only two phases will be supported initially,
namely request and validate.

'Federated Authentication and Authorization' has been designed so that it can
support any federation protocol. Each federation protocol needs an extension
profile document to describe the specific details of its parameters and
protocol messages e.g. which of the phases are supported, and what are
the protocol specific contents of each message.

API Changes
-------------

Federation does not change the CRUD operations or the routing in Keystone, but
adds new parameters to the JSON (or XML) http message body for the authenticate
function. A new 'federated' authentication plugin, similar to the existing
password and token plugins, is used to process the new message body. The
processing done by the federated plugin is concerned with federation trust
management. Specifically the federated plugin checks that the IdP is trusted,
that the identity attributes it issues (i.e. the remote identity) are trusted,
and that the remote identity can be mapped into a local identity.

Federation has been designed in this way so that minimal configuration changes
are needed in order to add federation to the core Keystone release, or to add a
new federation protocol. Adding federated authentication becomes as simple as
adding a new authentication plugin to Keystone. Adding a federation protocol
becomes as simple as adding a new plugin to the federated authentication plugin.

### The `federated` authentication method

If the Identity API client has been authenticated by a trusted identity provider,
it can request a token from the OpenStack Identity API service by presenting
assertions, and based on a successful validation of the assertions, the Identity
API client will be given an Identity API Service token. The client must send a
request to the Identity API service to validate the assertions received from the
identity provider. These are normally contained in the `protocol_data` element.


1. Request. The client may ask the OpenStack Identity API service to provide it
   with a federated authentication request for a specific protocol and identity
   provider(identified by its unique provider_id) which may have been returned in
   response to a List Identity Providers request - see Add IdP management
   extension (Federation pt1) - https://review.openstack.org/#/c/59846/.
   Any protocol specific parameters may be provided in the protocol_data field.


    Request:

        {
            "auth": {
                "identity": {
                    "federated": {
                        "phase": "request",
                        "protocol": "<protocol>",
                        "protocol_data": [<any protocol specific data>],
                        "provider_id": "<provider-id>"
                    },
                    "methods": [
                        "federated"
                    ]
                }
            }
        }

    The response contains the protocol specific details in the "protocol_data"
    element, as well as confirmation of the identity provider and protocol. The
    client needs this information to contact the requested Identity Provider.

    Response:

        {
            "error": {
                "code": 401,
                "identity": {
                    "federated": {
                        "protocol": "<protocol>",
                        "protocol_data": [<any protocol specific data>],
                        "provider_id": "<provider-id>"
                    },
                    "methods": [
                        "federated"
                    ]
                },
                "message": "Additional authentications steps required.",
                "title": "Unauthorized"
            }
        }

2. At the end of the protocol exchange, the client must request the OpenStack
   Identity API service to validate the assertions received from the identity
   provider. These are normally contained in the "protocol_data" element.

    Request:

        {
            "auth": {
                "identity": {
                    "methods": [
                        "federated"
                    ],
                    "federated": {
                        "phase": "validate",
                        "provider_id": "<provider-id>",
                        "protocol": "<protocol>",
                        "protocol_data": [<any specific protocol data>]
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
