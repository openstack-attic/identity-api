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

### Assertion Mappings: `/OS-IDP/assertion_mappings`

An `assertion_mapping` is a set of rules to map federation protocol
attributes to Identity API objects. An Identity Provider can have a multiple
`assertion mappings` specified.

Attributes:

- `assertion_mapping` (list)

Immutable attributes:

- `name` (string)

Mapping API
-----------

### Create an attribute type mapping: `POST /OS-IDP/attribute_mappings`

Request:

    {
        "name": "SAML2 attribute type mapping",
        “attribute_mapping” : {
            {
                “remote” : “Email”
            },
            {
                “local” : “user.email”
            }
        }
    }

Response:

    Status: 201 Created

    {
        "name": "SAML2 attribute type mapping",
        "id": "7fea2d",
        “attribute_mapping” : {
            {
                “remote” : “Email”
            },
            {
                “local” : “user.email”
            }
        },
        "links": {
            "self": "http:/identity:35357/v3/OS-IDP/attribute_mappings/7fea2d"
        }
    }

### Create a set of attribute type and value mapping: `POST /OS-IDP/attribute_value_mappings`

Request:

    {
        "name": "SAML2 attribute type and value mapping",
        "attribute_value_mapping": [
            {
                "remote": {
                    "orgPersonType": "Employee",
                    "sn": "Young"
                },
                "local": {
                    "group": "admin"
                }
            },
            {
                "remote": {
                    "orgPersonType": "Contractor"
                },
                "local": {
                    "group": "Contractor"
                }
            }
        ]
    }

Response:

    Status: 201 Created

    {
        "name": "SAML2 attribute type and value mapping",
        "id": "7fea2d",
        "attribute_value_mapping": [
            {
                "remote": {
                    "orgPersonType": "Employee",
                    "sn": "Young"
                },
                "local": {
                    "group": "admin"
                }
            },
            {
                "remote": {
                    "orgPersonType": "Contractor"
                },
                "local": {
                    "group": "Contractor"
                }
            }
        ],
        "links": {
            "self": "http:/identity:35357/v3/OS-IDP/attribute_value_mapping/7fea2d"
        }
    }

### Get an attribute type mapping: `GET /OS-IDP/attribute_mappings/{mapping_id}`

### Get a set of attribute type and value mapping: `GET /OS-IDP/attribute_value_mappings/{mapping_id}`

### Update an attribute type mapping: `PATCH /OS-IDP/attribute_mappings/{mapping_id}`

### Update a set of attribute type and value mapping: `PATCH /OS-IDP/attribute_value_mappings/{mapping_id}`

### List all attribute type mappings: `GET /OS-IDP/attribute-mappings`

### List all attribute type and value mappings: `GET /OS-IDP/attribute_value_mappings`

### Delete an attribute type mapping: `DELETE /OS-IDP/attribute_mappings/{mapping_id}`

Response:

    Status: 204 No Content

### Delete a set of attribute type and value mapping: `DELETE /OS-IDP/attribute_value_mappings/{mapping_id}`

Response:

    Status: 204 No Content
