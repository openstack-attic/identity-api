OpenStack Identity API v3 OS-FEDERATED Trusted Attribute Policy Extension
=========================================================================
Provides the ability for an administrator to manage the attributes that are
trusted to be issued by an identity provider (IdP).
Each trusted attribute policy comprises the set of attributes (optionally with
values) that the IdP is trusted to issue. If the values are missing, then the
IdP is trusted to issue all the values of a particular attribute.

This extension requires v3.0+ of the Identity API and the proposed OS-FEDERATED
extension.

Note: Domains are currently not included in the spec until IdP management
(Federation pt 1) has domains added.

API Resources
-------------

### Trusted Attribute:`/OS-FEDERATION/identity_providers/{idp-id}/trusted_attributes`

A trusted attribute policy defines which attributes an identity provider is
trusted to issue.

Attributes:

-`attributes` (list)
this is the list of trusted attributes. Each attribute is specified as a type
and an optional set of values.
-`identity_provider_id` (string)
this is the IdP that is trusted to issue the above list of attributes.

Identity Provider API
---------------------

### List an Identity Provider's set of trusted attributes: `GET /OS-IDP/identity_providers/{idp-id}/trusted_attributes/`

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

### Create an Identity Provider Issuing Policy: `POST /OS-IDP/identity_providers/{idp-id}/trusted_attributes`

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

### Update an Identity Provider Issuing Policy: `PATCH /OS-IDP/identity_providers/{idp-id}/trusted_attributes`

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

### Delete from an Identity Provider Issuing Policy: `DELETE /OS-IDP/identity_providers/{idp-id}/trusted_attributes`

Response:

    Status: 204 Deleted

