OpenStack Identity API v3 SAML Profile for Federation
=====================================================

This document specifies a profile for the federated authentication plugin
described in "Add Support for Federated Authentication (Pt 3)"
The federated authentication plugin delegates all the protocol dependent
functionality to protocol specific modules. Each federation protocol
needs a profile to describe the required request and response messages.
Note that this is independent of the actual implementation.

This document describes the profile for a remote SAML identity provider.

The protocol name used by this module is either "saml.websso" or "saml.ecp"
depending upon the client's requirements. These refer to the 'Web Browser SSO
Profile' or 'Enhanced Client or Proxy Profile' respectively as defined in the OASIS
standard "Profiles for the OASIS Security Assertion Markup Language (SAML) V2.0"
OASIS Standard, 15 March 2005.

###### The `saml` authentication profile

1. No protocol specific request parameters are required for the SAML profile
   to handle the issuing of an authentication request. The request message should
   conform to the structure laid out in the federated authentication plugin
   document, viz:

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
                        "protocol": "saml.websso",
                        "protocol_data": []
                    }
                }
            }
        }

    The response for the SAML profile must contain the endpoint of the
    remote SAML identity provider, and the SAMLRequest for authentication (which
    should be a Base 64 encoded SAML AuthnRequest conforming to either the Web
	browser SSO or ECP profile as requested by the client) within the
	protocol_data field.

    Response:

        {
            "error": {
                "message": "Additional authentication steps required.",
                "code": 401,
                "identity": {
                    "methods": [
                        "federated"
                    ],
                    "federated": {
                        "provider_id": "123456",
                        "protocol": "saml.websso",
                        "protocol_data": [
                            {
                                    "endpoint": "https://samlidp.com/SSOLogin.php",
                                    "SAMLRequest": "GR..CD7=..."
                            }
                        ]
                    }
                },
                "title": "Unauthorized"
            }
        }

2.  The SAML profile expects that the protocol_data provided during the
    validation phase contains a Base 64 encoded SAML assertion signed using the
    private key of the SAML IdP used to authenticate. The corresponding public
    key should be provided in the stored identity provider data.

    Request:

        {
            "auth": {
                "identity": {
                    "methods": [
                        "federated"
                    ],
                    "federated": {
                        "phase": "validate",
                        "provider_id": "123456",
                        "protocol": "saml.websso",
                        "protocol_data": [
                                {
                                        "data": "HJ..RF8="
                                }
                        ]
                    }
                }
            }
        }

    The response for the http profile validation is the same as the standard
	response described in the Add Support for Federated Authentication (Pt 3)
	document.
