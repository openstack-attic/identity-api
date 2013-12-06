OpenStack Identity API v3 OS-IDP Issuing Policy Extension
==========================================

Provide the ability for users to manage the issuing policy of identity providers. This
extension requires v3.0+ of the Identity API and the proposed OS-IDP extension.

Definitions
-----------

API Resources
-------------

Identity Provider API
---------------------

### List an Identity Provider Issuing Policy: `GET /OS-IDP/identity_providers/{idp-id}/issuing_policy`


Response:

    Status: 200 OK

    {
        "issuing_policy": {
            "identity_provider_id": "7e23a6",
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
                "self": "http:/identity:35357/v3/OS-IDP/identity_providers/7e23a6/issuing_policy"
            }
        }
    }

### Add to or modify an Identity Provider Issuing Policy: `POST /OS-IDP/identity_providers/{idp-id}/issuing_policy`

Request:
    {
        "issuing_policy": [
            {
                "type": "surname".
                "values": ["Jones"]
            },
            {
                "type": "email".
                "values": ["jones@me.com"]
            }
        ]
    }
Response:

    Status: 200 OK

    {
        "issuing_policy": {
            "identity_provider_id": "7e23a6",
            "attributes": [
                {
                    "type": "email",
                    "values": ["jones@me.com"]
                },
                {
                    "type": "orgPersonType",
                    "values": ["staff", "contractor", "guest"]
                },
                {
                    "type": "uid",
                    "values": []
                },
                {
                    "type": "surname",
                    "values": ["Jones"]
                }
            ]
            "links": {
                "self": "http:/identity:35357/v3/OS-IDP/identity_providers/7e23a6/issuing_policy"
            }
        }
    }

### Delete from an Identity Provider Issuing Policy: `DELETE /OS-IDP/identity_providers/{idp-id}/issuing_policy`

Request:
    {
        "issuing_policy": [
            {
                "type": "orgPersonType".
                "values": ["guest"]
            },
            {
                "type": "email".
                "values": ["jones@me.com"]
            }
        ]
    }
Response:

    Status: 200 OK

    {
        "issuing_policy": {
            "identity_provider_id": "7e23a6",
            "attributes": [
                {
                    "type": "orgPersonType",
                    "values": ["staff", "contractor"]
                },
                {
                    "type": "uid",
                    "values": []
                },
                {
                    "type": "surname",
                    "values": ["Jones"]
                }
            ]
            "links": {
                "self": "http:/identity:35357/v3/OS-IDP/identity_providers/7e23a6/issuing_policy"
            }
        }
    }
