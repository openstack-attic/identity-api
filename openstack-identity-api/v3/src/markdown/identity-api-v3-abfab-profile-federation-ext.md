OpenStack Identity API v3 ABFAB Profile for Federation
=====================================================

The federated authentication plugin delegates all the protocol dependent
functionality to protocol specific modules. Each federation protocol
needs a profile to describe the required request and response messages.
Note that this is independent of the actual implementation.
This document describes the profile for an IETF ABFAB conforming identity
provider. For an overview of the protocol see:
https://wiki.auckland.ac.nz/display/BeSTGRID/Moonshot+For+Grid

The ABFAB protocol specific module is added by creating a module called "abfab".
In order for this module to be executed, the discovery service must
return the type "abfab".

###### The `abfab` authentication profile

1.  No protocol specific request parameters are required for the ABFAB profile
    to handle the issuing of an authentication request. However the protocol
    parameter must be set to "abfab".

    Request:

        {
            "auth": {
                "identity": {
                    "methods": [
                        "federated"
                    ],
                    "federated": {
                        "phase": "request",
                        "provider_id": "123456",
                        "protocol": "abfab",
                        "protocol_data": []
                    }
                }
            }
        }

    The response for the abfab profile must contain the service name of the
    Keystone service, and the object identifier of the preferred GSS mechanism
    within the protocol_data field.

    Response:

       {
            "error": {
                "message": "Additional authentications steps required.",
                "code": 401,
                "identity": {
                    "methods": [
                        "federated"
                    ],
                    "federated": {
                        "provider_id": "123456",
                        "protocol": "abfab",
                        "protocol_data": [
                            {
                                "service_name": "keystone@moonshot",
                                "mechanism": "{1 3 6 1 5 5 15 1 1 18}"
                            }
                        ]
                    }
                },
                "title": "Unauthorized"
            }
        }

2.  The negotiation phase for Abfab is used to relay messages between the IdP
    and the client. During this exchange the client and the abfab protocol
    module in Keystone exchange GSS-API messages. The protocol specific
    parameters are:
      - negotiation: this contains the GSS-API message
      - cid: the client identifier

    Request:

        {
            "auth": {
                "identity": {
                    "methods": ["federated"],
                    "federated": {
                        "phase": "negotiate",
                        "provider_id": "123456",
                        "protocol": "abfab",
                        "protocol_data": [
                            {
                                "negotiation": "YCYGCSsGAQUF==",
                                "cid": "aea885aa-dfcd-11e2-b3c3-000c296102eb"
                            }
                        ]
                    }
                }
            }
        }

    Response:

        {
            "error": {
                "message": "Additional authentications steps required.",
                "code": 401,
                "identity": {
                    "methods": ["federated"],
                    "federated": {
                        "provider_id": "123456",
                        "protocol": "abfab",
                        "protocol_data": [
                            {
                                "negotiation": "YDoGCSsGAQUFDwh",
                                "cid": "aea885aa-dfcd-11e2-b3c3-000c296102eb"
                            }
                        ]
                    }
                },
                "title": "Unauthorized"
            }
        }

3.  The validation request for the abfab protocol should contain the client
    identifier within the protocol_data field. No other protocol specific
    parameters are required.

    Request:

        {
            "auth": {
                "identity": {
                    "methods": ["federated"],
                    "federated": {
                        "phase": "validate",
                        "provider_id": "36fe70842e2d47a0a9667f401fb5f9c0",
                        "protocol": "abfab",
                        "protocol_data": [
                            {
                                "cid": "aea885aa-dfcd-11e2-b3c3-000c296102eb"
                            }
                        ]
                    }
                }
            }
        }

    The response for the ABFAB profile validation is the same as the standard
    response described in the authentication plugin for federations document.
