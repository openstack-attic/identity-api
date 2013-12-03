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
Service to authenticate identities. For OpenStack, the ID of the identity
provider is the key. Each IdP the `protocol_data` field can be used to add IdP
specific metadata that is needed to talk to this IdP.

Attributes:

- `description` (string)
- `enabled` (boolean)
- `name` (string)

### Protocols: `/OS-FEDERATION/identity_providers/{idp_id}/protocols`

A protocol entry contains information that dictates which mapping rules
to use for a given incoming request. An IdP may have multiple supported
protocols.

Attributes:

- `mapping_id` (string)

### Mappings: `/OS-FEDERATION/mappings`

A `mapping` is a set of rules to map federation protocol attributes to Identity
API objects. An Identity Provider can have a single `mapping` specified. A
mapping has a `name` and a list of `rules`. The only Identity API objects
that will support mapping are: `group`.

Attributes:

- `name` is a short string to easily identify the mapping.

- `rule` is a list of dictionary entries that contain rules for mapping
  attributes to Identity API concepts. A rule contains both a `local` and a
  `remote` map.

  - `local` is a key-value pair. The key is an Identity concept, such as
    `group`. The value may be a string literal that will be set directly to the
    Identity concept, if a null value is passed, the assertion value will be
    used.

  - `remote` is a list of dictionary values, if multiple entries exist for
    `remote` then the results are an intersection of the entries. A `remote`
    entry has `type`, `value` and `requirement`, which are explained below.

    - `type` is a string that represents an assertion type keyword.

    - `requirement` is a string that is used with type and values to find
      matches. The following are acceptable values for `requirement`:

      - `any_value_of` - should return TRUE when the specified `type` is
        matched regardless of the `values`, and FALSE if the attribute `type`
        is not present.

      - `any_one_of` - should return TRUE if if one or more of the specified
        `values` for the specified `type` is present and otherwise FALSE.

      - `not_any_of` - should return TRUE if none of the specified `values` for
        the specified `type` are present and otherwise FALSE.

      - If no value is set, it is assumed to be `any_value_of`.

    - `values` is a list of strings that represent possible values of assertion
      types. [Regular expressions](http://docs.python.org/2/library/re.html)
      may also be used.

Identity Provider API
---------------------

### Register an Identity Provider: `POST /OS-FEDERATION/identity_providers`

Request:

    {
        "identity_provider": {
            "description": "Stores ACME identities.",
            "enabled": true,
            "name": "acme_idp"
        }
    }


Response:

    Status: 201 Created

    {
        "identity_provider": {
            "description": "Stores ACME identities",
            "enabled": true,
            "id": "7fea2d",
            "links": {
                "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d/protocols",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d"
            },
            "name": "acme_idp"
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
                "id": "0c2a74",
                "links": {
                    "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/0c2a74/protocols",
                    "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/0c2a74"
                },
                "name": "acme_idp"
            },
            {
                "description": "Stores contractor identities",
                "enabled": false,
                "id": "7fea2d",
                "links": {
                    "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d/protocols",
                    "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d"
                },
                "name": "beta_idp"
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
            "id": "7fea2d",
            "links": {
                "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d/protocols",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d"
            },
            "name": "beta_idp"
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
            "id": "7fea2d",
            "links": {
                "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d/protocols",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d"
            },
            "name": "beta_idp"
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
                "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d/protocols/saml2"
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
            "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d/protocols"
        },
        "protocols": [
            {
                "id": "saml2",
                "links": {
                    "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d",
                    "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d/protocols/saml2"
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
                "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d/protocols/saml2"
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
                "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/7fea2d/protocols/saml2"
            }
        }
    }

### Delete a supported protocol and attribute mapping combination from an identity provider: `DELETE /OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}`

Response:

    Status: 204 No Content

Mapping API
-----------

### Create a mapping: `POST /OS-FEDERATION/mappings`

Request:

    {
        "mapping": {
            "name": "ACME's SAML v2 mapping",
            "rules": [
                {
                    "local": {
                        "group": {
                            "id": "0cd5e9"
                        }
                    },
                    "remote": [
                        {
                            "requirement": "not_any_of",
                            "type": "orgPersonType",
                            "values": [
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
            "self": "http://identity:35357/v3/OS-FEDERATION/mappings/7fea2d"
        },
        "mapping": {
            "id": "7fea2d",
            "name": "ACME's SAML v2 mapping",
            "rules": [
                {
                    "local": {
                        "group": {
                            "id": "0cd5e9"
                        }
                    },
                    "remote": [
                        {
                            "requirement": "not_any_of",
                            "type": "orgPersonType",
                            "values": [
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
        "mapping": {
            "id": "7fea2d",
            "name": "ACME's SAML v2 mapping",
            "rules": [
                {
                    "remote": [
                        {
                            "type": "orgPersonType",
                            "values": [
                                "Contractor",
                                "Guest"
                            ],
                            "requirement": "not_any_of"
                        }
                    ],
                    "local": {
                        "group": {
                            "id": "0cd5e9"
                        }
                    }
                }
            ]
        },
        "links": {
            "self": "http://identity:35357/v3/OS-FEDERATION/mappings/7fea2d"
        }
    }

### Update a mapping: `PATCH /OS-FEDERATION/mappings/{mapping_id}`

Request:

    {
        "mapping": {
            "name": "ACME's SAML v2 mapping",
            "rules": [
                {
                    "local": {
                        "group": {
                            "id": "0cd5e9"
                        }
                    },
                    "remote": [
                        {
                            "requirement": "any_one_of",
                            "type": "orgPersonType",
                            "values": [
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
            "self": "http://identity:35357/v3/OS-FEDERATION/mappings/7fea2d"
        },
        "mapping": {
            "id": "7fea2d",
            "name": "ACME's SAML v2 mapping",
            "rules": [
                {
                    "local": {
                        "group": {
                            "id": "0cd5e9"
                        }
                    },
                    "remote": [
                        {
                            "requirement": "any_one_of",
                            "type": "orgPersonType",
                            "values": [
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
                "id": "7fea2d",
                "name": "ACME's SAML v2 mapping",
                "rules": [
                    {
                        "local": {
                            "group": {
                                "id": "0cd5e9"
                            }
                        },
                        "remote": [
                            {
                                "requirement": "any_one_of",
                                "type": "orgPersonType",
                                "values": [
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
                    "username": null
                },
                "remote": [
                    {
                        "type": "UserName",
                        "values": [],
                        "requirement": "any_value_of"
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
                        "values": [
                            "Contractor",
                            "SubContractor"
                        ],
                        "requirement": "not_any_of"
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
                        "values": [
                            "Contractor",
                            "SubContractor"
                        ],
                        "requirement": "any_one_of"
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
                        "requirement": "any_one_of",
                        "type": "orgPersonType",
                        "values": [
                            "Employee"
                        ]
                    },
                    {
                        "requirement": "any_one_of",
                        "type": "sn",
                        "values": [
                            "Young"
                        ]
                    }
                ]
            }
        ]
    }
