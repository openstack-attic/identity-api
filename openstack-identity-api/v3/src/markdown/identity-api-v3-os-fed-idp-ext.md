OpenStack Identity API v3 OS-FED-IDP Extension
==============================================

Provide the ability for users to manage identity providers, establish a set
of rules to map federation protocol attributes to Keystone objects, and the
ability for federated users to get a token to access OpenStack services via
a federated protocol. This extension requires v3.0+ of the Identity API.

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
- *Assertion Mappings*: The user information passed by a federation protocol
  for an already authenticated identity are called attributes. Those attributes
  may not align 1:1 with the Keystone concepts. To help overcome such
  mismatches, a mapping can be done either on the sending side (third party
  identity provider) or on the consuming side (Keystone), or both. This
  specification is only concerned with mapping on the Keystone side,
  regardless of what prior mappings may have taken place on the sending side.

API Resources
-------------

### Identity Providers: `/OS-FED-IDP/identity-providers`

An `identity provider` is a third party service that is trusted by the
Identity Service to authenticate identities. For OpenStack, the ID of
the identity provider is the key. Each IDP the protocol_data field
can be used to add IDP specific metadata that is needed to talk to
this IDP.

Optional attributes:

- `description` (string)
- `supported_protocols` (list)
- `protocol_data` : (list)

Immutable attributes:

- `name` (string)
- `active` (boolean)
- `domain_id` (string)

### Assertion Mappings: `/OS-FED-IDP/identity-providers/{idp_id}/assertion-mappings`

An `assertion mapping` is a set of rules to map federation protocol
attributes to Keystone objects. An `identity provider` can have a multiple
`assertion mappings` specified.

Attributes:

- `assertion-mapping` (list)

Immutable attributes:

- `name` (string)
- `id` (boolean)

Identity Provider API
---------------------

### Create an Identity Provider: `POST /OS-FED-IDP/identity-providers`

Request:

    {
        “name” :  “acme_idp”,
        “description” :  “Stores ACME identities.”,
        “active” : true,
        “supported_protocols” : ['saml2'],
        "protocol_data" : "[<protocol specific data>]",
        “domain_id” : “12345”
    }


Response:

    Status: 201 Created

    {
        "identity-provider": {
            "name": "acme_idp",
            "active": true,
            “supported_protocols” : ['saml2'],
            "protocol_data" : "[<protocol specific data>]",
            "description": "Stores ACME identities",
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-FED-IDP/identity-providers/7fea2d"
            }
        }
    }

### List identity providers: `GET /OS-FED-IDP/identity-providers`

Response:

    Status: 200 OK

    {
        "identity-providers": [
            {
                "id": "0c2a74",
                "name": "acme_idp",
                "active": true,
                “supported_protocols” : ['saml2'],
                "protocol_data" : "[<protocol specific data>]",
                "description": "Stores ACME identities",
                "links": {
                    "self": "http://identity:35357/v3/OS-FED-IDP/identity-providers/0c2a74"
                }
            },
            {
                "id": "7fea2d",
                "description": "Beta dev idp",
                "name": "beta_idp",
                “supported_protocols” : ['saml2'],
                "protocol_data" : "[<protocol specific data>]",
                "active": false,
                "links": {
                    "self": "http://identity:35357/v3/OS-FED-IDP/identity-providers/7fea2d"
                }
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-FED-IDP/identity-providers"
        }
    }

### Get Identity provider: `GET /OS-FED-IDP/identity-providers/{identity_provider_id}`

Response:

    Status: 200 OK

    {
        "identity-provider": {
            "id": "7fea2d",
            "description": "Beta dev idp",
            "name": "beta_idp",
            “supported_protocols” : ['saml2'],
            "protocol_data" : "[<protocol specific data>]",
            "active": false,
            "links": {
                "self": "http://identity:35357/v3/OS-FED-IDP/identity-providers/7fea2d"
            }
        }
    }

### Delete identity provider: `DELETE /OS-FED-IDP/identity-providers/{identity_provider_id}`

When an identity provider is deleted, any tokens generated by that identity
provider will be revoked.

Response:

    Status: 204 No Content

### Update identity provider: `PATCH /OS-FED-IDP/identity-providers/{identity_provider_id}`

Only a identity providers `description`, `name`, `active` and
`supported_protocols` are mutable. Attempting to PATCH an immutable attribute
should result in a HTTP 400 Bad Request.

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
            “supported_protocols” : ['saml2'],
            "protocol_data" : "[<protocol specific data>]",
            "active": true,
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH1/consumers/7fea2d",
            }
        }
    }

When an identity provider is made inactive, any tokens generated by that identity
provider will be revoked.


### Add/Update public key for identity provider: `PUT /OS-FED-IDP/identity-providers/{identity_provider_id}/public-key`

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

### Get public key for an identity provider: `GET /OS-FED-IDP/identity-providers/{identity_provider_id}/public-key`

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


### Delete public key for identity provider: `DELETE /OS-FED-IDP/identity-providers/{identity_provider_id}/public-key

Response:

    Status: 204 No Content


Mapping API
-----------

### Create/Update an assertion mapping for an identity provider: `PUT /OS-FED-IDP/identity-providers/{idp_id}/assertion-mappings

Request:

    {
        "name": "ACME mapping",
        "id": "7fea2d",
        “assertion-mappings” : [
            {
                “property” : “CompanyName”,
                “mappedProperty” : “domain.name”
            },
            {
                “property” : “AccountId”,
                “mappedProperty” : “domain.id”
            },
            {
                “property” : “FirstName”,
                “mappedProperty” : “user.username”
            },
            {
                “property” : “Email”,
                “mappedProperty” : “user.email”
            },
            {
                “property” : “role.name”,
                “mappedProperty” : “RoleName”,
                “mappedValues“: [
                    {
                        from: 'admin',
                        to: 'sysadmin'
                    },
                    {
                        from: 'tech',
                        to: 'technician'
                    }
                ]
            }
        ]
    }


Response:

    Status: 200 OK

### Retrieve an assertion mapping for an identity provider: `GET /OS-FED-IDP/identity-providers/{idp_id}/assertion-mappings/{mapping_id}

Response:

    {
        "name": "ACME mapping",
        "id": "7fea2d",
        “assertion-mappings” : [
            {
                “property” : “CompanyName”,
                “mappedProperty” : “domain.name”
            },
            {
                “property” : “AccountId”,
                “mappedProperty” : “domain.id”
            },
            {
                “property” : “FirstName”,
                “mappedProperty” : “user.username”
            },
            {
                “property” : “Email”,
                “mappedProperty” : “user.email”
            },
            {
                “property” : “role.name”,
                “mappedProperty” : “RoleName”,
                “mappedValues“: [
                    {
                        from: 'admin',
                        to: 'sysadmin'
                    },
                    {
                        from: 'tech',
                        to: 'technician'
                    }
                ]
            }
        ]
    }


### Delete an assertion mapping for an identity provider: `Delete /OS-FED-IDP/identity-providers/{idp_id}/assertion-mappings/{mapping_id}

Response:

    Status: 204 No Content


API Changes
-----------

### Authenticate with the `federated` method: `POST /auth/tokens`

If the user has been authenticated by a federated identity provider, it can
present its assertions to Keystone for validation, and if valid the user will
be given a Keystone token. The client must request Keystone to validate the
assertions received from the identity provider. These are normally contained
in the "protocol_data" element.

    Request:

    {
        "auth": {
            "identity": {
                "methods": [
                    "federated"
                ],
                "federated": {
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
    