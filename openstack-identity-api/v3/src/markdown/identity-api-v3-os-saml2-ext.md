OpenStack Identity API v3 OS-SAML2 Extension
=============================================

Provide the ability for users authenticated via third party identity provider
to get a token to access OpenStack services via the [SAML 2.0 specification]
(https://www.oasis-open.org/committees/download.php/11511/sstc-saml-tech-overview-2.0-draft-03.pdf). 
This extension requires v3.0+ of the Identity API. 

Definitions
-----------

- *Local user:* An identity api service user whose credential and user information 
  is stored within the local keystone instance.
- *Federated User:* An Identity API service user, whose credential and user information is
  located in a trusted identity provider outside of the local keystone instance.
- *Trusted Identity Provider:* An identity provider (location and key) setup within keystone that is 
  trusted to provide authenticated user information via SAML assertions for token generation within keystone
- *Attribute mapping*: The user information passed by SAML assertion for an already authenticated identity is called 
  SAML attributes. Those attributes may not align 1:1 with the keystone concepts. For example, "group" may be sent
  when "role" is expected by Keystone. To help overcome such mismatches, a mapping can be done either on the sending side 
  (third party identity provider) or on the consuming side (keystone).


SAML Setup and Flow
-----------------------------

Enabling SAML in keystone for a domain can be done in 2 steps:
1. An identity api admin user authenticates against keystone (no change in normal operation).
2. The identity api admin user [creates an identity provider for a domain] (#create-identity-provider-post-os-idp-identity-providers)

Access to cloud services can be handled in 4 steps:

1. A user authenticates with their own identity provider.
2. That identity provider [sends a SAML assertion to Keystone](#create-token-from-saml-post-os-saml2-saml-tokens).
3. Keystone returns back a token that can be used for the implemented OpenStack cloud
4. OpenStack services validate the token normally.



API Resources
-------------

### Trusted Identity Providers: `/OS-IDP/identity-providers`

An identity provider is a third party  service that is trusted by keystone to authenticate identities.

Optional attributes:

- `description` (string)
- `saml2` (boolean)

Immutable attributes provided by the Identity service:

- `name` (string)
- `active` (boolean)
- `domainId` (string)


For Openstack, the ID of the identity provider is the key.
An identity provider can be extended in the future to indicate if it supports OpenID, OAuth, AbFab, etc.


Identity Provider API
-------------

### Create Identity Provider: `POST /OS-IDP/identity-providers`

Request:

    {
	“name” :  “acme_idp”
	“description” :  “Stores ACME identities.”
	“active” : true
	“saml” : true
     	“domainId” : “12345”
    } 


Response:


    Status: 201 Created

    {
        "identity-provider": {
            "name": "acme_idp",
	    "active": true,
            "saml": true,
            "description": "Stores ACME identities",
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-IDP/identity-providers/7fea2d"
            }
        }
    }

### List identity providers: `GET /OS-IDP/identity-providers`

Response:

    Status: 200 OK

    {
        "identity-providers": [
            {
                "id": "0c2a74",
            	"name": "acme_idp",
	    	"active": true,
            	"saml": true,
            	"description": "Stores ACME identities",
                "links": {
                    "self": "http://identity:35357/v3/OS-IDP/identity-providers/0c2a74"
                }
            },
            {
                "id": "7fea2d",
                "description": "Beta dev idp",
		"name": "beta_idp",
		"saml": true,
		"active": false,
                "links": {
                    "self": "http://identity:35357/v3/OS-IDP/identity-providers/7fea2d"
                }
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-IDP/identity-providers"
        }
    }

### Get Identity provider: `GET /OS-IDP/identity-providers/{identity_provider_id}`

Response:

    Status: 200 OK

    {
        "identity-provider": {
            "id": "7fea2d",
            "description": "Beta dev idp",
	    "name": "beta_idp",
	    "saml": true,
	    "active": false,
            "links": {
                "self": "http://identity:35357/v3/OS-IDP/identity-providers/7fea2d"
            }
        }
    }

### Delete identity provider: `DELETE /OS-IDP/identity-providers/{identity_provider_id}`

When an identity provider is deleted, any tokens generated due to SAML assertions allowed by that identity
provider will be revoked.

Response:

    Status: 204 No Content

### Update identity provider: `PATCH /OS-IDP/identity-providers/{identity_provider_id}`

Only a identity provider's `description`, `name`, `active` and `saml` is mutable. Attempting to PATCH an immutable
attribute should result in a HTTP 400 Bad Request.

Request:

    {
        "identity-provider": {
            "active": true
        }
    }

Response:

    Status: 200 OK

    {
        "identity-provider": {
            "description": "Beta dev idp",
	    "name": "beta_idp",
	    "saml": true,
	    "active": true,
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH1/consumers/7fea2d"
            }
        }
    }

When an identity provider is made inactive, any tokens generated due to SAML assertions allowed by that identity
provider will be revoked.


### Add/Update public key for identity provider: `PUT /OS-IDP/identity-providers/{identity_provider_id}/public-key`

Request:
    {
	"mQCNAi+UeBsAAAEEAMP0kXU75GQdzwwlMiwZBUKFUDRgR4wH9y5NP9JaZfVX8shT    
  	ESbCTbGSEExB2ktEPh5//dkfftsKNlzlAugKFKTgBv20tQ9lDKfdbPVR0HmTLz0e   
  	wVIeqEue4+Mt/Kq7kMcQy+5sX2RBAiZTYl0n/JdY/WxflU0taq1kH/UUPkklAAUR 
  	tB5NYXJ0eSBNY0ZseSA8bWFydHlAZnV0dXJlLmNvbT6JAJUCBRAvlHhGrWQf9RQ+   
  	SSUBAQX+BACnhx7OTb1SfAcJVF/1kuRPUWuGcl57eZgv4syc1O9T3YNr0terWQBT 
  	K0vFR00FdaBv9X9XwlxaBJHGeiBcmhaiOTwB912ysoteUzZHne3sHPw3MkYboAFx   
 	xHg43Cnj60OeZG2PKp/kU91ipOJP1cs8/xYOGkeoAMqDfwPeFlkBiA== =ddBN”
    } 

Response:

    Status: 200 OK

### Get public key for an identity provider: `GET /OS-IDP/identity-providers/{identity_provider_id}/public-key`

Response:

    Status: 200 OK

    {
	"mQCNAi+UeBsAAAEEAMP0kXU75GQdzwwlMiwZBUKFUDRgR4wH9y5NP9JaZfVX8shT    
  	ESbCTbGSEExB2ktEPh5//dkfftsKNlzlAugKFKTgBv20tQ9lDKfdbPVR0HmTLz0e   
  	wVIeqEue4+Mt/Kq7kMcQy+5sX2RBAiZTYl0n/JdY/WxflU0taq1kH/UUPkklAAUR 
  	tB5NYXJ0eSBNY0ZseSA8bWFydHlAZnV0dXJlLmNvbT6JAJUCBRAvlHhGrWQf9RQ+   
  	SSUBAQX+BACnhx7OTb1SfAcJVF/1kuRPUWuGcl57eZgv4syc1O9T3YNr0terWQBT 
  	K0vFR00FdaBv9X9XwlxaBJHGeiBcmhaiOTwB912ysoteUzZHne3sHPw3MkYboAFx   
 	xHg43Cnj60OeZG2PKp/kU91ipOJP1cs8/xYOGkeoAMqDfwPeFlkBiA== =ddBN”
    } 


### Delete public key for identity provider: `DELETE /OS-IDP/identity-providers/{identity_provider_id}/public-key

Response:

    Status: 204 No Content

### Create/Update SAML configuration for identity provider: `PUT /OS-IDP/identity-providers/{identity_provider_id}/saml-configuration

The SAML configuration of an identity provider points to where the provider is, and can later hold the assertion mappings. 

Request:

    {
     “samlProviderUrl” : “https://external.idp.com/SAML”
    } 

Response:

    Status: 200 OK 

SAML Token Exchange API
-------------------

### Create Token from SAML: `POST /OS-SAML2/saml_tokens`

The trusted identity provider sends a SAML request. Keystone validates the SAML signature
against the trusted identity provider public key stored within Keysotne. If valid, the SAML
request is parsed, locating username, role(s), domain, and project(s). An ephemeral user is created
within keystone and a token generated scoped to those attributes. That token and it's service-catalog
is returned. 

Request:
    {
	SAML (see example below)
    }

Response:
    Status: 200 OK with service catalog & token (regular authN response) or 401 unauthorized or 400 for malformed SAML



SAML Asssertion walk through
-------------------
Full SAML Response example in including assertion:

	<saml2p:Response xmlns:saml2p="urn:oasis:names:tc:SAML:2.0:protocol" ID="bc1c335f-8078-4769-81a1-bb519194279c" IssueInstant="2013-10-01T15:02:42.110Z" Version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	   <saml2:Issuer xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion">http://my.trusted.idp.com</saml2:Issuer>
	   <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
	      <ds:SignedInfo>
		 <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
		 <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
		 <ds:Reference URI="#bc1c335f-8078-4769-81a1-bb519194279c">
		    <ds:Transforms>
		       <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
		       <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
		          <ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="xs"/>
		       </ds:Transform>
		    </ds:Transforms>
		    <ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>
		    <ds:DigestValue>MNSPZoA7K27Mv6oIfePTrMS+W4Y=</ds:DigestValue>
		 </ds:Reference>
	      </ds:SignedInfo>
	      <ds:SignatureValue>LmBStQQ5Xzh/Irlk4/6y123e6xTgvK1xvygCku4qpKoIEgd5vjTVkH7q6ol49Fqe1DcfJ6tYTrmAq9UL+7meGg==</ds:SignatureValue>
	   </ds:Signature>
	   <saml2p:Status>
	      <saml2p:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
	   </saml2p:Status>
	   <saml2:Assertion xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion" ID="461e5f27-3880-4ef3-a51f-8265ef13b7e6" IssueInstant="2013-10-01T15:02:42.107Z" Version="2.0">
	      <saml2:Issuer>http://my.rackspace.com</saml2:Issuer>
	      <saml2:Subject>
		 <saml2:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified">johnny.walker</saml2:NameID>
		 <saml2:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
		    <saml2:SubjectConfirmationData NotOnOrAfter="2013-10-14T17:02:42.101Z"/>
		 </saml2:SubjectConfirmation>
	      </saml2:Subject>
	      <saml2:AuthnStatement AuthnInstant="2013-10-01T15:02:42.103Z" SessionNotOnOrAfter="2013-10-01T15:02:42.103Z">
		 <saml2:AuthnContex t>
		    <saml2:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordPotectedTransport</saml2:AuthnContextClassRef>
		 </saml2:AuthnContext>
	      </saml2:AuthnStatement>
	      <saml2:AttributeStatement>
		 <saml2:Attribute Name="roles">
		    <saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">role1@projectA</saml2:AttributeValue>
		    <saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">role2@projectB</saml2:AttributeValue>
		   <saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">role3</saml2:AttributeValue>
		 </saml2:Attribute>
		 <saml2:Attribute Name="domain">
		    <saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">ACME-DOMAIN</saml2:AttributeValue>
		 </saml2:Attribute>
	      </saml2:AttributeStatement>
	   </saml2:Assertion>
	</saml2p:Response>


*Issuer:*
Identifies the identity provider name that was used to authenticate the identity and send the assertion. Keystone should use this name to lookup the public key and
validate the SAML assertion signature.

	   <saml2:Issuer xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion">http://my.trusted.idp.com</saml2:Issuer>

*Signature:*
The signature value is the SAML payload provided by the identity provider and encrypted using their private key. Keystone uses the public key for the identity provider
to decrypt that value and compare to the SAML payload sent. If any changes are detected, Keystone should reject (401) the assertion.

   <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
      <ds:SignedInfo>
	 <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
	 <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
	 <ds:Reference URI="#bc1c335f-8078-4769-81a1-bb519194279c">
	    <ds:Transforms>
	       <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
	       <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
	          <ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="xs"/>
	       </ds:Transform>
	    </ds:Transforms>
	    <ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>
	    <ds:DigestValue>MNSPZoA7K27Mv6oIfePTrMS+W4Y=</ds:DigestValue>
	 </ds:Reference>
      </ds:SignedInfo>
      <ds:SignatureValue>LmBStQQ5Xzh/Irlk4/6y123e6xTgvK1xvygCku4qpKoIEgd5vjTVkH7q6ol49Fqe1DcfJ6tYTrmAq9UL+7meGg==</ds:SignatureValue>
   </ds:Signature>

*Status:*
The status is used to indicate if the SAML request (against the third party identity provider) was successful, a requestor error, a responder error, or a version mismatch. 
For the sake of Keysotne, all but status:Success will return 400. 

   <saml2p:Status>
      <saml2p:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
   </saml2p:Status>

*Name:*
The name indicates the username for the ephemeral identity created within keystone
   <saml2:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified">johnny.walker</saml2:NameID>

*Token Expiration:*
SessionNotOnOrAfter specifies a time at which the session between the principal (username) and SAML authority issuing the statement (identity provider) must be considered ended. 
This value is encoded in UTC.
   <saml2:AuthnStatement AuthnInstant="2013-10-01T15:02:42.103Z" SessionNotOnOrAfter="2013-10-01T15:02:42.103Z">

*Roles:*
Roles can be passed as attirbutes. Keystone will use these to setup the token scope and service catalog. Since roles can be assigned to a user on a project, there
is an option to append @ and the projectID to the end of the role name. Not doing so will grant the role to a user on the domain. 

   <saml2:Attribute Name="roles">
    <saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">role1@projectA</saml2:AttributeValue>
    <saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">role2@projectB</saml2:AttributeValue>
    <saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">role3</saml2:AttributeValue>
   </saml2:Attribute>

*Domain:*
Domain can also be passed in as an attribute

   <saml2:Attribute Name="domain">
    <saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">ACME-DOMAIN</saml2:AttributeValue>
   </saml2:Attribute>

