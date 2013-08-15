OpenStack Identity API v3 Keystone Profile for Federation
=====================================================

The federated authentication plugin delegates all the protocol dependent
functionality to protocol specific modules. Each federation protocol
needs a profile to describe the required request and response messages.
Note that this is independent of the actual implementation. 
This document describes the profile for a remote Keystone identity
provider.

The Keystone protocol specific module is added by creating a module called "keystone".
In order for this module to be executed, the discovery service must
return the type "keystone".

###### The `keystone` authentication profile


1. No protocol specific request parameters are required for the Keystone profile
to handle the issuing of an authentication request. The request message
should conform to the structure laid out in the federation extension document, viz:

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

    The response for the Keystone profile must contain the endpoint of the remote
    Keystone identity provider.

	For example:

		{
			"provider_id": "123456",
			"endpoint": "https://my-remote-keystone.com:5000/v3/auth",
			"protocol": "keystone"
		}


2. The negotiation phase for Keystone is not used, and if an attempt is made to
perform a negotiation with a Keystone Identity Provider then a NotImplemented
exception is raised.

3. The Keystone profile expects that the data provided during the validation phase
contains a Keystone token either in PKI format or as a UUID. If a PKI token is
returned, then the implementation will need to have access to the CA certificate
and public key certificate of the Keystone IDP. If a UUID token is returned, then
the implementation will need the login details of an admin user for the Keystone IDP.

	A typical request for validating a response from a Keystone IdP is

		{
			"auth": {
				"identity": {
					"methods": [
						"federated"
					],
					"federated": {
						"phase": "validate",
						"provider_id": "123456",
						"data": "<keystone token>"
					}
				}
			}
		}

	The response for the Keystone profile validation is the same as the standard
	response described in the federation extension document.
