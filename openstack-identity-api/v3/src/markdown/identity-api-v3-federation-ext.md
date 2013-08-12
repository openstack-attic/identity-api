Authentication Plugin For Federations
=====================================

Federation provides a way for users who do not have an account in Keystone, but
who already have an account with an external trusted identity provider, to
authenticate with their identity provider and then be auto-provisioned with an
entry in Keystone so that they can then use OpenStack services just like a
locally provisioned user.

Notes:

1.  A user who is auto-provisioned in this way will still need to be removed by
    an administrator in the usual way.
2.  Once pluggable token provisioning has been enabled, auto-provisioning
    of user entries can be removed, or disabled, or made an optional extra as we
    decide.


Support for different federation protocols
------------------------------------------

This document describes federation in a protocol independent way. 'Federated
authentication and authorization' comprises of up to three phases, namely:
request, negotiate and validate.

'Federated Authentication and Authorization' has been designed so that it can
support any federation protocol. Each federation protocol needs an extension
profile document to describe the specific details of its parameters and
protocol messages e.g. which of the 3 phases are supported, and what are
the protocol specific contents of each message.

API Changes
-------------

Federation does not change the CRUD operations or the routing in Keystone, but
adds new parameters to the JSON (or XML) http message body for the authenticate
function. A new 'federated' authentication plugin, similar to the existing
password and token plugins, is used to process the new message body. Federation
has been designed in this way so that minimal configuration changes are needed
in order to add federation to a core Keystone release. Adding federation
becomes as simple as adding a new authentication plugin.

### The `federated` authentication method

If the user has been authenticated by a federated identity provider, it can
present its assertions to federated Keystone for validation, and on the strength
of this, the user will be given an authorization token.

Federated authentication and authorization comprises of up to three phases,
which are:

1.  Request. The client may ask Keystone to provide it with a federated
    authentication request for a specific protocol and identity provider
    (identified by its unique provider_id) which may have been returned in
    response to a Protocol Discovery request - see [Protocol Discovery Extension
    for (Federated) Authentication](https://review.openstack.org/#/c/41907/)).
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

2.  The client may request further protocol negotiation within the federated
    authentication exchange when the federation protocol requires multiple round
    trips. The "protocol_data" element contains the protocol dependent message
    from the client to Keystone.

    Request:

        {
            "auth": {
                "identity": {
                    "federated": {
                        "phase": "negotiation",
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

    The response is protocol specific and the "protocol_data" element contains
    the next message in the negotiation sequence for the client.

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

3.  At the end of the protocol exchange, the client must request Keystone to
    validate the assertions received from the identity provider. These are
    normally contained in the "protocol_data" element.

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

    Response (Example OpenStack token responses can be found
    [here](https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses)):

        {
            "token": {
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
