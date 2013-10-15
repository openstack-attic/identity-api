OpenStack Identity API v3 OS-MAP Extension
==========================================

Provide the ability for admin users to establish a set of rules to map
federation protocol attributes to Identity API objects. This extension
requires v3.0+ of the Identity API.

Definitions
-----------

- *Attribute Mapping*: The user information passed by a federation protocol
  for an already authenticated identity are called attributes. Those attributes
  may not align 1:1 with the Identity API concepts. To help overcome such
  mismatches, a mapping can be done either on the sending side (third party
  identity provider) or on the consuming side (Identity API service) or both.

Limitations
-----------

In the current implementation, the following limitations exist:

- The only Identity API service authentication attributes that will support
mapping are: `user.email` and `user.name`.

- The only Identity API service authorization attributes that will support
mapping are: `group_id`.

- `project_id`, `role`, `domain_id` are candidates to be supported in the
future, however, these mappings may be done via assignments against groups.


Conceptual Model
-----------------------

Mappings can be done at different levels:

- *Attribute type mappings:* In these mappings an input Identity API attribute is
  mapped into a Identity API property.

- *Attribute type and value mappings:* In these mappings an input Identity
  attribute type and value is mapped into a Identity API property and value.

- *Object mappings:* In these mappings a set of federated attributes (types or
  types and values) are mapped into a set of Identity API properties (and values).

API Resources
-------------

### Attribute Mappings: `/OS-MAP/attribute_mappings`

An `attribute_mapping` is a set of rules to map federation protocol
attributes to Identity API objects. An Identity Provider can have a multiple
`assertion mappings` specified.

Format:
- A `mapping` has a `name`, `id` and `attribute_mapping`.

- An `attribute_mapping` has the following form:

    {
         "remote": [
             {
                 "type": --string--,
                 "values": --list of strings--,
                 "requirement": --string--
             }
         ],
         "local": --string--
    }

- The local string represents an Identity API attribute.

- The `remote` key is a list of dictionary values, each entry in `remote`
  represents incoming IdP attributes. If multiple entries exist for `remote`
  then the results are an intersection of the entries.

- A `remote` entry has `type`, `value` and `requirement`, which are explained
  below.

- `requirement` is a set of key terms that may be used to further narrow down
  values, if no value is set, it is assumed to be `any_value_of`. The
  following are acceptable values for `requirement`:
    - `not_any_of` - if `type` matches none of `values`, it is mapped to `local`.
    - `any_one_of` - if `type` matches any of `values`, it is mapped to `local`.
    - `any_value_of` - `values` is an empty set, mapping attribute type only.


Mapping API
-----------

### Create a set of attribute type and value mapping: `POST /OS-IDP/attribute_value_mappings`

Request:

    {
        "mapping": {
            "name": "acme's SAML2 mapping",
            "attribute_mapping": [
                {
                    "remote": [
                        {
                            "type": "Email",
                            "values": [],
                            "requirement": "any_value_of"
                        }
                    ],
                    "local": {
                        "group": "user.email"
                    }
                },
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
                        "group": "Internal"
                    }
                },
                {
                    "remote": [
                        {
                            "type": "orgPersonType",
                            "values": [
                                "Contractor",
                                "SubContractor"
                            ],
                            "requirement": "any_one_of"
                        }
                    ],
                    "local": {
                        "group": "Contractors"
                    }
                },
                {
                    "remote": [
                        {
                            "type": "orgPersonType",
                            "values": [
                                "Employee"
                            ],
                            "requirement": "any_one_of"
                        },
                        {
                            "type": "sn",
                            "values": [
                                "Young"
                            ],
                            "requirement": "any_one_of"
                        }
                    ],
                    "local": {
                        "group": "admin"
                    }
                }
            ]
        }
    }

Response:

    Status: 201 Created

    {
        "mapping": {
            "name": "acme's SAML2 mapping",
            "id": "7fea2d",
            "attribute_mapping": [
                {
                    "remote": [
                        {
                            "type": "Email",
                            "values": [],
                            "requirement": "any_value_of"
                        }
                    ],
                    "local": {
                        "group": "user.email"
                    }
                },
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
                        "group": "Internal"
                    }
                },
                {
                    "remote": [
                        {
                            "type": "orgPersonType",
                            "values": [
                                "Contractor",
                                "SubContractor"
                            ],
                            "requirement": "any_one_of"
                        }
                    ],
                    "local": {
                        "group": "Contractors"
                    }
                },
                {
                    "remote": [
                        {
                            "type": "orgPersonType",
                            "values": [
                                "Employee"
                            ],
                            "requirement": "any_value_of"
                        },
                        {
                            "type": "sn",
                            "values": [
                                "Young"
                            ],
                            "requirement": "any_value_of"
                        }
                    ],
                    "local": {
                        "group": "admin"
                    }
                }
            ]
        },
        "links": {
            "self": "http:/identity:35357/v3/OS-IDP/attribute_value_mapping/7fea2d"
        }
    }


### Get an attribute type mapping: `GET /OS-IDP/attribute_mappings/{mapping_id}`

### Update an attribute type mapping: `PATCH /OS-IDP/attribute_mappings/{mapping_id}`

### List all attribute type mappings: `GET /OS-IDP/attribute-mappings`

### Delete an attribute type mapping: `DELETE /OS-IDP/attribute_mappings/{mapping_id}`

Response:

    Status: 204 No Content
