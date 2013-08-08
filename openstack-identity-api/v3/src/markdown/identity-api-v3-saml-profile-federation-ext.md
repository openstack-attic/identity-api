OpenStack Identity API v3 SAML Profile for Federation
=====================================================

The federated authentication plugin delegates certain functionality to
protocol specific modules, or profiles. Namely: the request, negotiate
and validate phases are delegated. This document describes the expected
parameters and return values for the SAML profile.

The SAML protocol specific module is added by creating a module called "saml"
which implements the protocol specific phases, namely: request, negotiate and validate.
In order for this module to be executed, the discovery service must
return the type "idp.saml".

###### The `saml` authentication profile


1. The interrogate phase is optional and protocol independent.
No handling for this phase is required in the SAML profile.

2. The discovery phase is optional and protocol independent.
No handling for this phase is required in the SAML profile.

3. No protocol specific request parameters are required for the SAML profile
to handle the issuing of an authentication request. The request message
should conform to the structure laid out in the federation extension document.

{
    "auth": {
        "identity": {
            "methods": [
                "federated"
            ],
            "federated": {
                "phase": "request",
                "provider_id": "123456"
            }
        }
    }
}

The response from the SAML profile must contain a "data" element
which should contain a URL encoded SAML Authentication Request.
For example:

{
    "data": "SAMLRequest=..nVRdc..",
    "provider_id": "1",
    "endpoint": "https://my-saml-idp.com/SSO/login",
    "protocol": "saml"
}


4. The negotiation phase for SAML is not used, and if an attempt is made to
perform a negotiation with a SAML Identity Provider then a NotImplemented
exception is raised.

5. The SAML profile expects that the data provided during the validation phase
contains a SAML attribute assertion wrapped in a URL encoded SAML response signed
using a private key which corresponds to the public certificate retrievable
from the discovery service. (In the default discovery service this certificate is
stored in Keystone's service catalog, specifically, in the "extras" data for
the Identity Provider's endpoint.)

An example of a validation element is below

{ 
    "validation" : {
        "certdata": "/etc/keystone/idp-certs/my-saml-idp.pem"
    }
}

A typical request for validating a response from a SAML IdP is

{
        "auth": {
            "identity": {
                "methods": [
                    "federated"
                ],
                "federated": {
                    "phase": "validate",
                    "provider_id": "123456",
                    "data": "SAMLResponse=£12tr.."
                }
            }
        }
    }


The response for the SAML profile validation is the same as the standard
response described in the federation extension document.
