OpenStack Identity API v3 Apache Profile for Federation
=======================================================

This document specifies a profile for the federated authentication plugin
described in "Add Support for Federated Authentication (Pt 3)"
The federated authentication plugin delegates all the protocol dependent
functionality to protocol specific modules. Each federation protocol
needs a profile to describe the required request and response messages.
Note that this is independent of the actual implementation.

This document describes the profile for a front end Apache2 server which is acting
as the service provider to the external IdPs. The IdPs are not aware of the
Keystone backend.

The protocol name used by this module is "apache2".

###### The `apache2` authentication profile

1. The issuing of an authentication request message by Keystone is not needed.
   We assume that Apache is able to create its own IDP request messages.

2. 	The protocol_data provided during the validation phase must contain a JSON
	structure containing the attributes asserted by each IDP as well as the user's
	ID and the validity time of the assertion(s). Note. This structure caters for
	attribute aggregation from a set of IdPs.

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
						"protocol": "apache2",
						"protocol_data": [
							{
								"uid": "123456789",
								"user_identity": [
									{
										"attributes": [
											"email": "fred@gmail.com"
											"organisation": "University of Kent"
											"uid": "123456787899"
										],
										"idp_name": "kent.ac.uk"
									},
									{
										"attributes": [
											"membership": "gold"
										],
										"idp_name": "ba.com"
									}
								],
								"validity_time": "20130123T00:00:00Z"
							}
						]
					}
				}
			}
		}

	The response for the apache2 profile validation is the same as the standard
	response described in the Add Support for Federated Authentication (Pt 3)
	document.
