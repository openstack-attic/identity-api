OpenStack Identity API v3 OS-IDP Issuing Policy Extension
==========================================
Provides the ability for an administrator to manage the attributes that are trusted to be issued by an identity provider.
Each issuing policy comprises the set of attributes (optionally with values) that the IDP is trusted to issue.
If the values are missing, then the IdP is trusted to issue all the values of a particular attribute.

This extension requires v3.0+ of the Identity API and the proposed OS-IDP extension.

Note: Domains are currently not included in the spec until IDP management (Federation pt 1) has domains added.

Definitions
-----------

API Resources
-------------

Identity Provider API
---------------------

### List an Identity Provider Issuing Policy: `GET /OS-IDP/identity_providers/{idp-id}/issuing_policy/`


Response:

    Status: 200 OK

    {
        "issuing_policy": {
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

### Create an Identity Provider Issuing Policy: `POST /OS-IDP/identity_providers/{idp-id}/issuing_policy`

Request:
    {
        "issuing_policy": {
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
        "issuing_policy": {
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

### Update an Identity Provider Issuing Policy: `PATCH /OS-IDP/identity_providers/{idp-id}/issuing_policy`

Request:
    {
        "issuing_policy": {
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
        "issuing_policy": {
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
                "self": "http:/identity:35357/v3/OS-IDP/identity_providers/7e23a6/issuing_policy"
            }
        }
    }

### Delete from an Identity Provider Issuing Policy: `DELETE /OS-IDP/identity_providers/{idp-id}/issuing_policy`

Response:

    Status: 204 Deleted

   