OpenStack Identity API v3 OS-FEDERATION Extension
=================================================

Provide the ability for users to manage Identity Providers (IdPs) and establish
a set of rules to map federation protocol attributes to Identity API
attributes. This extension requires v3.0+ of the Identity API.

Definitions
-----------

- *Trusted Identity Provider*: An identity provider setup within the Identity
  Service API that is trusted to provide authenticated user information.
- *Service Provider*: A system entity that provides services to principals or
  other system entities, in this case, the OpenStack Identity Service API is
  the Service Provider.
- *Attribute Mapping*: The user information passed by a federation protocol for
  an already authenticated identity are called `attributes`. Those `attributes`
  may not align 1:1 with the Identity API concepts. To help overcome such
  mismatches, a mapping can be done either on the sending side (third party
  identity provider), on the consuming side (Identity API service), or both.

API Resources
-------------

### Identity Providers: `/OS-FEDERATION/identity_providers`

An Identity Provider is a third party service that is trusted by the Identity
Service to authenticate identities.

Optional attributes:

- `description` (string)

  Describes the identity provider.

  If a value is not specified by the client, the service may default this value
  to either an empty string or `null`.

- `enabled` (boolean)

  Indicates whether this identity provider should accept federated
  authentication requests.

  If a value is not specified by the client, the service may default this to
  either `true` or `false`.

### Protocols: `/OS-FEDERATION/identity_providers/{idp_id}/protocols`

A protocol entry contains information that dictates which mapping rules
to use for a given incoming request. An IdP may have multiple supported
protocols.

Required attributes:

- `mapping_id` (string)

  Indicates which mapping should be used to process federated authentication
  requests.

### Mappings: `/OS-FEDERATION/mappings`

A `mapping` is a set of rules to map federation protocol attributes to Identity
API objects. An Identity Provider can have a single `mapping` specified per
protocol. A mapping is simply a list of `rules`. The only Identity API objects
that will support mapping are: `group`.

Required attributes::

- `rules` (list of objects)

  Each object contains a rule for mapping attributes to Identity API concepts.
  A rule contains a `remote` attribute description and the destination `local`
  attribute.

  - `local` (object)

    References a local Identity API resource, such as a `group` or `user` to
    which the remote attributes will be mapped.

    The object itself contains one of two structures, described below.

    To map a remote attribute value directly to a local attribute, identify the
    local resource type and attribute:

        {
            "user": "name"
        }

    This assigns identity attributes to ephemeral users.

    Alternatively, for attribute type and value mapping, identify the local
    resource type, attribute, and value:

        {
            "group": {
                "id": "89678b"
            }
        }

    This assigns authorization attributes, by way of role assignments on the
    specified group, to ephemeral users.

  - `remote` (list of objects)

    At least one object must be included.

    If more than one object is included, the local attribute is applied only if
    all remote attributes match.

    The value identified by `type` is always passed through unless a constraint
    is specified using either `any_one_of` or `not_one_of`.

    - `type` (string)

      This represents an assertion type keyword.

    - `any_one_of` (list of strings)

      This is mutually exclusive with `not_any_of`.

      The rule is matched only if any of the specified strings appear in the
      remote attribute `type`.

    - `not_any_of` (list of strings)

      This is mutually exclusive with `any_one_of`.

      The rule is not matched if any of the specified strings appear in the
      remote attribute `type`.

    - `regex` (boolean)

      If `true`, then each string will be evaluated as a [regular
      expression](http://docs.python.org/2/library/re.html) search against the
      remote attribute `type`.

Identity Provider API
---------------------

### Register an Identity Provider: `PUT /OS-FEDERATION/identity_providers/{idp_id}`

Request:

    {
        "identity_provider": {
            "description": "Stores ACME identities.",
            "enabled": true
        }
    }

Response:

    Status: 201 Created

    {
        "identity_provider": {
            "description": "Stores ACME identities",
            "enabled": true,
            "id": "ACME",
            "links": {
                "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME"
            }
        }
    }

### List identity providers: `GET /OS-FEDERATION/identity_providers`

Response:

    Status: 200 OK

    {
        "identity_providers": [
            {
                "description": "Stores ACME identities",
                "enabled": true,
                "id": "ACME",
                "links": {
                    "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols",
                    "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME"
                }
            },
            {
                "description": "Stores contractor identities",
                "enabled": false,
                "id": "ACME-contractors",
                "links": {
                    "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME-contractors/protocols",
                    "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME-contractors"
                }
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers"
        }
    }

### Get Identity provider: `GET /OS-FEDERATION/identity_providers/{idp_id}`

Response:

    Status: 200 OK

    {
        "identity_provider": {
            "description": "Stores ACME identities",
            "enabled": false,
            "id": "ACME",
            "links": {
                "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME"
            }
        }
    }

### Delete identity provider: `DELETE /OS-FEDERATION/identity_providers/{idp_id}`

When an identity provider is deleted, any tokens generated by that identity
provider will be revoked.

Response:

    Status: 204 No Content

### Update identity provider: `PATCH /OS-FEDERATION/identity_providers/{idp_id}`

Request:

    {
        "identity_provider": {
            "enabled": true
        }
    }

Response:

    Status: 200 OK

    {
        "identity_provider": {
            "description": "Beta dev idp",
            "enabled": true,
            "id": "ACME",
            "links": {
                "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME"
            }
        }
    }

When an identity provider is disabled, any tokens generated by that identity
provider will be revoked.

### Add a supported protocol and attribute mapping combination to an identity provider: `PUT /OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}`

Request:

    {
        "protocol": {
            "mapping_id": "xyz234"
        }
    }

Response:

    Status: 201 Created

     {
        "protocol": {
            "id": "saml2",
            "mapping_id": "xyz234",
            "links": {
                "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols/saml2"
            }
        }
    }

### List all supported protocol and attribute mapping combinations of an identity provider: `GET /OS-FEDERATION/identity_providers/{idp_id}/protocols`

Response:

    Status: 200 OK

    {
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols"
        },
        "protocols": [
            {
                "id": "saml2",
                "links": {
                    "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME",
                    "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols/saml2"
                },
                "mapping_id": "xyz234"
            }
        ]
    }

### Get a supported protocol and attribute mapping combination for an identity provider: `GET /OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}`

Response:

    Status: 200 OK

     {
        "protocol": {
            "id": "saml2",
            "mapping_id": "xyz234",
            "links": {
                "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols/saml2"
            }
        }
    }

### Update the attribute mapping for an identity provers and protocol combination: `PATCH /OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}`

Request:

    {
        "protocol": {
            "mapping_id": "xyz234"
        }
    }

Response:

    Status: 200 OK

     {
        "protocol": {
            "id": "saml2",
            "mapping_id": "xyz234",
            "links": {
                "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols/saml2"
            }
        }
    }

### Delete a supported protocol and attribute mapping combination from an identity provider: `DELETE /OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}`

Response:

    Status: 204 No Content

Mapping API
-----------

### Create a mapping: `PUT /OS-FEDERATION/mappings/{mapping_id}`

Request:

    {
        "mapping": {
            "rules": [
                {
                    "local": {
                        "group": {
                            "id": "0cd5e9"
                        }
                    },
                    "remote": [
                        {
                            "type": "orgPersonType",
                            "not_any_of": [
                                "Contractor",
                                "Guest"
                            ]
                        }
                    ]
                }
            ]
        }
    }

Response:

    Status: 201 Created

    {
        "links": {
            "self": "http://identity:35357/v3/OS-FEDERATION/mappings/ACME"
        },
        "mapping": {
            "id": "ACME",
            "rules": [
                {
                    "local": {
                        "group": {
                            "id": "0cd5e9"
                        }
                    },
                    "remote": [
                        {
                            "type": "orgPersonType",
                            "not_any_of": [
                                "Contractor",
                                "Guest"
                            ]
                        }
                    ]
                }
            ]
        }
    }

### Get a mapping: `GET /OS-FEDERATION/mappings/{mapping_id}`

Response:

    Status: 200 OK

    {
        "links": {
            "self": "http://identity:35357/v3/OS-FEDERATION/mappings/ACME"
        },
        "mapping": {
            "id": "ACME",
            "rules": [
                {
                    "local": {
                        "group": {
                            "id": "0cd5e9"
                        }
                    },
                    "remote": [
                        {
                            "type": "orgPersonType",
                            "not_any_of": [
                                "Contractor",
                                "Guest"
                            ]
                        }
                    ]
                }
            ]
        }
    }

### Update a mapping: `PATCH /OS-FEDERATION/mappings/{mapping_id}`

Request:

    {
        "mapping": {
            "id": "ACME",
            "rules": [
                {
                    "local": {
                        "group": {
                            "id": "0cd5e9"
                        }
                    },
                    "remote": [
                        {
                            "type": "orgPersonType",
                            "any_one_of": [
                                "Contractor",
                                "SubContractor"
                            ]
                        }
                    ]
                }
            ]
        }
    }

Response:

    Status: 200 OK

    {
        "links": {
            "self": "http://identity:35357/v3/OS-FEDERATION/mappings/ACME"
        },
        "mapping": {
            "id": "ACME",
            "rules": [
                {
                    "local": {
                        "group": {
                            "id": "0cd5e9"
                        }
                    },
                    "remote": [
                        {
                            "type": "orgPersonType",
                            "any_one_of": [
                                "Contractor",
                                "SubContractor"
                            ]
                        }
                    ]
                }
            ]
        }
    }

### List all mappings: `GET /OS-FEDERATION/mappings`

Response:

    Status 200 OK

    {
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-FEDERATION/mappings"
        },
        "mappings": [
            {
                "id": "ACME",
                "rules": [
                    {
                        "local": {
                            "group": {
                                "id": "0cd5e9"
                            }
                        },
                        "remote": [
                            {
                                "type": "orgPersonType",
                                "any_one_of": [
                                    "Contractor",
                                    "SubContractor"
                                ]
                            }
                        ]
                    }
                ]
            }
        ]
    }

### Delete a mapping: `DELETE /OS-FEDERATION/mappings/{mapping_id}`

Response:

    Status: 204 No Content

Example Mapping Rules
---------------------

### Mapping any user name

This is an example of *Attribute type mappings*, where an attribute type is
mapped into a Identity API property.

    {
        "rules": [
            {
                "local": {
                    "user": {
                        "name": "{0}"
                    }
                },
                "remote": [
                    {
                        "type": "UserName"
                    }
                ]
            }
        ]
    }

### Map identities to their own groups

This is an example of *Attribute type and value mappings*, where an attribute
type and value are mapped into a Identity API property and value.

    {
        "rules": [
            {
                "local": {
                    "group": {
                        "id": "0cd5e9"
                    }
                },
                "remote": [
                    {
                        "type": "orgPersonType",
                        "not_any_of": [
                            "Contractor",
                            "SubContractor"
                        ]
                    }
                ]
            },
            {
                "local": {
                    "group": {
                        "id": "85a868"
                    }
                },
                "remote": [
                    {
                        "type": "orgPersonType",
                        "any_one_of": [
                            "Contractor",
                            "SubContractor"
                        ]
                    }
                ]
            }
        ]
    }

### Find specific users, set them to admin group

This is an example that is similar to the previous, but displays how multiple
`remote` properties can be used to narrow down on a property.

    {
        "rules": [
            {
                "local": {
                    "group": {
                        "id": "85a868"
                    }
                },
                "remote": [
                    {
                        "type": "orgPersonType",
                        "any_one_of": [
                            "Employee"
                        ]
                    },
                    {
                        "type": "sn",
                        "any_one_of": [
                            "Young"
                        ]
                    }
                ]
            }
        ]
    }
