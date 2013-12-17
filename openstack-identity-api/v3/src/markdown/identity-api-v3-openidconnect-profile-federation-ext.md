OpenStack Identity API v3 Keystone Profile for Federation
=====================================================

The federated authentication plugin delegates all the protocol dependent
functionality to protocol specific modules. Each federation protocol
needs a profile to describe the required request and response messages.
Note that this is independent of the actual implementation.
This document describes the profile for a remote OpenID Connect identity
provider.

The protocol name used by this module is either "oidc.basic", for the OAuth code
flow, or "oidc.implicit", for the OAuth implicit flow.

###### The `oidc` authentication profile

1. The following protocol specific request parameters are required for the OpenID
   Connect profile to handle the issuing of an authentication request.
   The request message should conform to the structure laid out in the federation
   extension document, viz:

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
						"protocol": "oidc.basic | oidc.implicit",
						"protocol_data": []
					}
				}
			}
		}

    The response for the OpenID Connect profile must contain the endpoint and
	request data of the remote OpenID Connect IdP within the protocol_data field.
	The following example is the basic client profile

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
						"protocol": "oidc.basic",
						"protocol_data": [
							{
								"endpoint": "http://openid-provider.com/authorize",
								"request": "?scope=openid+profile+email+address+phone&state=ABCD1234&redirect_uri=https%3A%2F%2Flocalhost%3A8080%2F&response_type=code&client_id=654321"
							}
						]
					}
				}
			}
		}

		The following example is the implicit client profile

	Response:

		{
			"auth": {
				"message": "Additional authentication steps required.",
				"code": 401,
				"identity": {
					"methods": [
						"federated"
					],
					"federated": {
						"provider_id": "123456",
						"protocol": "oidc.implicit",
						"protocol_data": [
							{
								"endpoint": "http://openid-provider.com/authorize",
								"request": "?nonce=xss3ywSS0CpX&state=y5MADmtJt6u1&redirect_uri=https%3A%2F%2Flocalhost%3A8080%2F&response_type=id_token+token&client_id=2b9ab798-d04e-4131-8764-b63e5a15b68b&scope=openid+profile+email+address+phone"
							}
						]
					}
				}
			}
		}

2. The following protocol specific request parameters are required for the OpenID
   Connect profile to handle the response of the authentication request in the
   validate phase.

	For basic client profile:

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
						"protocol": "oidc.basic",
						"protocol_data":
							[
								{
									"state": "ABCD1234",
									"code" : "EFGH4321"
								}
							]
					}
				}
			}
		}


	For implicit client profile:

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
						"protocol": "oidc.implicit",
						"protocol_data":
							[
								{
									"state": "ABCD1234",
									"access_token": "0011223344556677",
									"token_type": "Bearer",
									"id_token": "8899AABBCCDDEEFF"
								}
							]
					}
				}
			}
		}

The response for the OpenID Connect profile validation is the same as the
	standard response described in Add Support for Federated Authentication (Pt 3)
	document.

