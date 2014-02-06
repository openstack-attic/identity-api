OpenStack Identity API v3 OS-FEDERATED Trusted Attributes Policy Extension
==========================================================================

Provides the ability for an administrator to manage the attributes that are
trusted to be issued by an identity provider (IdP).
Each trusted attributes policy comprises the set of attributes (optionally with
values) that an IdP is trusted to issue. If the values are missing, then the
IdP is trusted to issue all the values of a particular attribute.

This extension requires v3.0+ of the Identity API and the proposed OS-FEDERATED
extension.

API Resources
-------------

### Trusted Attribute:`/OS-FEDERATION/identity_providers/{idp-id}/trusted_attributes`

A trusted attributes policy defines which attributes an identity provider is
trusted to issue.

Attributes:

- `attributes` (list): This is the list of trusted attributes. Each attribute
  is specified as a type and an optional set of values.

Identity Provider API
---------------------

### List an Identity Provider's set of trusted attributes: `GET /OS-IDP/identity_providers/{idp-id}/trusted_attributes`

Response:

    Status: 200 OK

    {
        "trusted_attributes": {
            "attributes": [
                {
                    "type": "email",
                    "values": []
                },
                {
                    "type": "orgPersonType",
                    "values": ["staff", "contractor", "guest"]
                },
                {
                    "type": "uid",
                    "values": []
                }
            ]
            "links": {
                "self": "http:/identity:35357/v3/OS-IDP/identity_providers/7e23a6/trusted_attributes"
            }
        }
    }

### Create an Identity Provider's Trusted Attributes Policy: `POST /OS-IDP/identity_providers/{idp-id}/trusted_attributes`

Request:
    {
        "trusted_attributes": {
            "attributes": [
                {
                    "type": "email",
                    "values": []
                },
                {
                    "type": "orgPersonType",
                    "values": ["staff", "contractor", "guest"]
                },
                {
                    "type": "uid",
                    "values": []
                }
            ]
        }
    }

Response:

    Status: 201 Created

    {
        "trusted_attributes": {
            "attributes": [
                {
                    "type": "email",
                    "values": []
                },
                {
                    "type": "orgPersonType",
                    "values": ["staff", "contractor", "guest"]
                },
                {
                    "type": "uid",
                    "values": []
                }
            ]
            "links": {
                "self": "http:/identity:35357/v3/OS-IDP/identity_providers/7e23a6/trusted_attributes"
            }
        }
    }

### Update an Identity Provider's Trusted Attributes Policy: `PATCH /OS-IDP/identity_providers/{idp-id}/trusted_attributes`

Request:
    {
        "trusted_attributes": {
            "attributes": [
                {
                    "type": "email",
                    "values": []
                },
                {
                    "type": "orgPersonType",
                    "values": ["contractor", "guest"]
                },
                {
                    "type": "uid",
                    "values": []
                }
            ]
        }
    }

Response:

    Status: 200 OK

    {
        "trusted_attributes": {
            "attributes": [
                {
                    "type": "email",
                    "values": []
                },
                {
                    "type": "orgPersonType",
                    "values": ["contractor", "guest"]
                },
                {
                    "type": "uid",
                    "values": []
                }
            ]
            "links": {
                "self": "http:/identity:35357/v3/OS-IDP/identity_providers/7e23a6/trusted_attributes"
            }
        }
    }

### Delete from an Identity Provider's Trusted Attributes Policy: `DELETE /OS-IDP/identity_providers/{idp-id}/trusted_attributes`

Response:

    Status: 204 Deleted

