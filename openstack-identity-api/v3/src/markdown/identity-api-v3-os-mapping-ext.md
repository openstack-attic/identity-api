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
mapping are: `user.email` and `user.id`.

- The only Identity API service authorization attributes that will support
mapping are: `group_id`.

- `project`, `role`, `domain` are candidates to be supported in the
future, however, these mappings may be done via assignments against groups.
TODO: (stevemar) ayoung wants domain in now

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

### Attribute Mappings: `/OS-MAP/mappings`

A `mapping` is a set of rules to map federation protocol attributes to
Identity API objects. An Identity Provider can have a single `mapping`
specified. A mapping has a `name` and a list of `rules`.

Attributes:

* `name` is a short string to easily identify the mapping.

* `rule` is a list of dictionary entries that contain rules for mapping
  attributes to Identity API concents. A rule contains both a `local` and
  a `remote` map.

  * `local` is a key-value pair. The key is an Identity concept, and
    can be one of `username`, `userid`, `group` or `domain`.
    The value may be a string literal that will be set directly to the Identity
    concept, if a null value is passed, the assertion value will be used.

  * `remote` is a list of dictionary values, if multiple entries exist
    for `remote` then the results are an intersection of the entries. A `remote`
    entry has `type`, `value` and `requirement`, which are explained below.

      * `type` is a string that represents an assertion type keyword.
      * `requirement` is a string that is used with type and values to find matches.
        The following are acceptable values for `requirement`:

         * `any_value_of` - should return TRUE when the specified `type` is matched
         regardless of the `values`, and FALSE if the attribute `type` is not present.
         * `any_one_of` - should return TRUE if if one or more of the specified
         `values` for the specified `type` is present and otherwise FALSE.
         * `not_any_of` - should return TRUE if none of the specified `values` for
         the specified `type` are present and otherwise FALSE.
         * If no value is set, it is assumed to be `any_value_of`.

      * `values` is a list of strings that represent possible values of assertion types.
        Regular expressions may also be used, the reserved characters are: `*`, `.`,
        `+`, `()`, `[]` and `\`.

         * `*` matches zero or more characters.
         * `.` matches exactly one character.
         * `+` matches one or more characters.
         * `\` is used to escape any of the reserved characters.
         * `()` Parenthesis are used for substring capture.
         * `[]` Parenthesis are used for matching one of the encapsulated values.

Example Rules
-------------

### Mapping any user name

    {
        'rules': [
            {
                'remote': [
                    {
                        'type': 'UserName',
                        'values': [],
                        'requirement': 'any_value_of'
                    }
                ],
                'local': {
                    'username': null
                }
            }
        ]
    }

### Map identities to their own groups

    {
        'rules': [
            {
                'remote': [
                    {
                        'type': 'orgPersonType',
                        'values': [
                            'Contractor',
                            'Guest'
                        ],
                        'requirement': 'not_any_of'
                    }
                ],
                'local': {
                    'group': 'Internal'
                }
            },
            {
                'remote': [
                    {
                        'type': 'orgPersonType',
                        'values': [
                            'Contractor',
                            'SubContractor'
                        ],
                        'requirement': 'any_one_of'
                    }
                ],
                'local': {
                    'group': 'Contractors'
                }
            }
        ]
    }

### Find specific users, set them to admin group

    {
        'rules': [
            {
                'remote': [
                    {
                        'type': 'orgPersonType',
                        'values': [
                            'Employee'
                        ],
                        'requirement': 'any_one_of'
                    },
                    {
                        'type': 'sn',
                        'values': [
                            'Young'
                        ],
                        'requirement': 'any_one_of'
                    }
                ],
                'local': {
                    'group': 'admin'
                }
            }
        ]
    }

Mapping API
-----------

### Create a mapping: `POST /OS-MAP/mappings`

Request:

    {
        'mapping': {
            'name': 'acme's SAML2 mapping',
            'rules': [
                {
                    'remote': [
                        {
                            'type': 'orgPersonType',
                            'values': [
                                'Contractor',
                                'Guest'
                            ],
                            'requirement': 'not_any_of'
                        }
                    ],
                    'local': {
                        'group': 'Internal'
                    }
                }
            ]
        }
    }

Response:

    Status: 201 Created

    {
        'mapping': {
            'name': 'acme's SAML2 mapping',
            'id': '7fea2d',
            'rules': [
                {
                    'remote': [
                        {
                            'type': 'orgPersonType',
                            'values': [
                                'Contractor',
                                'Guest'
                            ],
                            'requirement': 'not_any_of'
                        }
                    ],
                    'local': {
                        'group': 'Internal'
                    }
                }
            ]
        },
        'links': {
            'self': 'http://identity:35357/v3/OS-MAP/mappings/7fea2d'
        }
    }


### Get a mapping: `GET /OS-MAP/mappings/{mapping_id}`

Response:

    Status: 200 OK

    {
        'mapping': {
            'id': '7fea2d',
            'name': 'acme's SAML2 mapping',
            'rules': [
                {
                    'remote': [
                        {
                            'type': 'orgPersonType',
                            'values': [
                                'Contractor',
                                'Guest'
                            ],
                            'requirement': 'not_any_of'
                        }
                    ],
                    'local': {
                        'group': 'Internal'
                    }
                }
            ]
        },
        'links': {
            'self': 'http://identity:35357/v3/OS-MAP/mappings/7fea2d'
        }
    }

### Update a mapping: `PATCH /OS-MAP/mappings/{mapping_id}`

Request:

    {
        'mapping': {
            'name': 'acme's SAML2 mapping',
            'rules': [
                {
                    'remote': [
                        {
                            'type': 'orgPersonType',
                            'values': [
                                'Contractor',
                                'SubContractor'
                            ],
                            'requirement': 'any_one_of'
                        }
                    ],
                    'local': {
                        'group': 'Contractors'
                    }
                }
            ]
        }
    }

Response:

    Status: 200 OK

    {
        'mapping': {
            'id': '7fea2d',
            'name': 'acme's SAML2 mapping',
            'rules': [
                {
                    'remote': [
                        {
                            'type': 'orgPersonType',
                            'values': [
                                'Contractor',
                                'SubContractor'
                            ],
                            'requirement': 'any_one_of'
                        }
                    ],
                    'local': {
                        'group': 'Contractors'
                    }
                }
            ]
        },
        'links': {
            'self': 'http://identity:35357/v3/OS-MAP/mappings/7fea2d'
        }
    }

### List all mappings: `GET /OS-MAP/mappings`

Response:

    Status 200 OK

    {
        "mappings": [
            {
                'id': '7fea2d',
                'name': 'acme's SAML2 mapping',
                'rules': [
                    {
                        'remote': [
                            {
                                'type': 'orgPersonType',
                                'values': [
                                    'Contractor',
                                    'SubContractor'
                                ],
                                'requirement': 'any_one_of'
                            }
                        ],
                        'local': {
                            'group': 'Contractors'
                        }
                    }
                ]
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-MAP/mappings"
        }
    }

### Delete a mapping: `DELETE /OS-MAP/mappings/{mapping_id}`

Response:

    Status: 204 No Content
