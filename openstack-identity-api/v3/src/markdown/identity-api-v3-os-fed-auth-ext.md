OpenStack Identity API v3 OS-FED-AUTH Extension
===============================================

Provide the ability for federated users to get a token to access OpenStack
services via a federated protocol like the [SAML 2.0 specification](https://www.oasis-open.org/committees/download.php/11511/sstc-saml-tech-overview-2.0-draft-03.pdf).
This extension requires v3.0+ of the Identity API.

Definitions
-----------

- *Local user:* An identity api service user whose credential and user
  information is stored within the local keystone instance.
- *Federated User:* An Identity API service user, whose credential and user
  information is located in a trusted identity provider outside of the local
  Keystone instance.

Setup and Flow
--------------

Prerequisite:

1. An identity API admin user must [create a mapping policy]
1. An identity API admin user must [create an identity provider]

Access to cloud services can be handled in 4 steps:

1. A user authenticates with their own identity provider.
2. That identity provider sends a federation protocol assertion to Keystone.
3. Keystone returns back a token that can be used for OpenStack.
4. OpenStack services validate the token normally.


SAML Token Exchange API
-----------------------

### Create Token from SAML: `POST /OS-FED-SAML2/saml_tokens`

The trusted identity provider sends a SAML request. Keystone validates the
SAML signature against the trusted identity provider public key stored within
Keystone. If valid, the SAML request is parsed, locating username, role(s),
domain, and project(s). An ephemeral user is created within Keystone and a
token generated scoped to those attributes. That token and it's service-catalog
is returned.

Request:
    {
        SAML (see example below)
    }

Response:
    Status: 200 OK with service catalog & token (regular authN response) or
    401 unauthorized or 400 for malformed SAML

