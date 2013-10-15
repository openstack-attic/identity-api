OpenStack Identity API v3 OS-MAP Extension
==========================================

Provide the ability for users to establish a set of rules to map federation
protocol attributes to Identity API objects. This extension requires v3.0+ of
the Identity API.

Definitions
-----------

- *Assertion Mappings*: The user information passed by a federation protocol
  for an already authenticated identity are called attributes. Those attributes
  may not align 1:1 with the Identity API concepts. To help overcome such
  mismatches, a mapping can be done either on the sending side (third party
  identity provider) or on the consuming side (Identity API service) or both.

Conceptual Model
-----------------------

Mappings can be done at different levels:

- *Attribute type mappings:* In these mappings an input Identity API attribute is
  mapped into a Identity API property.

- *Attribute type and value mappings:* In these mappings an input Identity
  attribute type and value is mapped into a Identity API property and value.

- *Object mappings:* In these mappings a set of federated attributes (types or
  types and values) are mapped into a set of Identity API properties (and values).

Note: For the current implementation, only the first two mappings are supported.

API Resources
-------------

### Assertion Mappings: `/OS-IDP/identity_providers/{idp_id}/assertion_mappings`

An `assertion_mapping` is a set of rules to map federation protocol
attributes to Identity API objects. An Identity Provider can have a multiple
`assertion mappings` specified.

Attributes:

- `assertion_mapping` (list)

Immutable attributes:

- `name` (string)

Mapping API
-----------

### Create/Update an assertion mapping for an identity provider: `PUT /OS-IDP/identity_providers/{idp_id}/assertion_mappings

Request:

    {
        "name": "ACME mapping",
        "id": "7fea2d",
        “assertion_mappings” : [
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
                        "from": ["sysadmin", "adm"],
                        "to": ["admin"]
                    },
                    {
                        "from": ["tech"],
                        "to": ["technician"]
                    }
                ]
            }
        ]
    }

Note: When mapping roles, multiple properties can be mapped to a single role.

Response:

    Status: 200 OK

### Retrieve an assertion mapping for an identity provider: `GET /OS-IDP/identity_providers/{idp_id}/assertion_mappings/{mapping_id}

Response:

    {
        "name": "ACME mapping",
        "id": "7fea2d",
        “assertion_mappings” : [
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
                        "from": ["sysadmin", "adm"],
                        "to": ["admin"]
                    },
                    {
                        "from": ["tech"],
                        "to": ["technician"]
                    }
                ]
            }
        ]
    }


### Delete an assertion mapping for an identity provider: `Delete /OS-IDP/identity_providers/{idp_id}/assertion_mappings/{mapping_id}

Response:

    Status: 204 No Content
