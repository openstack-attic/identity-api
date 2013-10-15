OpenStack Identity API v3 OS-AUTH-SAML Extension
================================================

Provide the ability for remote users to get a token to access OpenStack
services via the SAML 2.0 protocol. [SAML 2.0 specification](https://www.oasis-open.org/committees/download.php/11511/sstc-saml-tech-overview-2.0-draft-03.pdf).
This extension requires v3.0+ of the Identity API.
OpenStack Identity V3 API is playing the role of the service provider (SP)
in a SAML POST profile flow.
The implementation will support SAML v2.0, POST profiles, sender vouches.

Definitions
-----------

*Local Identity:* An Identity managed by service provider or OpenStack
  Identity API service instance.
*Remote Identity:* An Identity managed by a trusted identity provider.

API Changes
-----------

### Authenticate with the `saml2` method: `POST /auth/tokens`

If the user has been authenticated by a trusted identity provider, it can
request a token from the OpenStack Identity API service by presenting
assertions, and based on a successful validation of the assertions, the user
will be given an Identity API Service token. The client must send a request
to the Identity API service to validate the assertions received from the
identity provider. These are normally contained in the `protocol_data` element.
It is important to note, that for now, only the `request` and `validate`
phases will be supported.

    Request:

    {
        "auth": {
            "identity": {
                "methods": [
                    "federated"
                ],
                "federated": {
                    "phase": "validate",
                    "protocol_data": [<SAML request>]
                }
            }
        }
    }

The response contains a project scoped token with a an "OS-FEDERATED"
element, which contains information about the IdP.

    Response:

    "OS-AUTH-SAML": {
        "provider_id": "7fea2d",
        "protocol": "saml2"
    }
