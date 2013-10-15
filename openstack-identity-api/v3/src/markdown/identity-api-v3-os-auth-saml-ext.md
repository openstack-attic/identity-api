OpenStack Identity API v3 OS-AUTH-SAML Extension
================================================

Provide the ability for federated users to get a token to access OpenStack
services via the SAML 2.0 protocol. [SAML 2.0 specification](https://www.oasis-open.org/committees/download.php/11511/sstc-saml-tech-overview-2.0-draft-03.pdf).
This extension requires v3.0+ of the Identity API.

Definitions
-----------

- *Trusted Identity Provider:* An identity provider setup within the
  Identity Service that is trusted to provide authenticated user information
  for token generation.
- *Local user:* An identity api service user whose credential and user
  information is stored within the local keystone instance.
- *Federated User:* An Identity API service user, whose credential and user
  information is located in a trusted identity provider outside of the local
  Keystone instance. A federated user will need to be removed by an admin
  in the usual way.

API Changes
-----------

### Authenticate with the `saml2` method: `POST /auth/tokens`

If the user has been authenticated by a federated identity provider, it can
present its assertions to Keystone for validation, and if valid the user will
be given a Keystone token. The client must request Keystone to validate the
assertions received from the identity provider. These are normally contained
in the "protocol_data" element.
It is important to note, that for now, only the `validate` phase will be
supported. Multi-stage protocols are not yet supported.

    Request:

    {
        "auth": {
            "identity": {
                "methods": [
                    "saml2"
                ],
                "saml2": {
                    "phase": "validate",
                    "provider_id": "7fea2d",
                    "protocol": "saml2",
                    "protocol_data": [<any specific protocol data>]
                }
            }
        }
    }

The response contains an project scoped token with a an "OS-FEDERATED"
element, that contains information about the IDP.

    Response:

    "OS-FEDERATED": {
        "provider_id": "7fea2d",
        "protocol": "saml2"
    }
