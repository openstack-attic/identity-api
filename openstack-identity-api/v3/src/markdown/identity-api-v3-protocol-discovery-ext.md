Protocol Discovery for (Federated) Authentication
=================================================

This extension provides a mechanism for a client to interrogate Keystone
to determine which authentication protocols are supported, and which
providers are available for any particular protocol.

#### List Protocols`GET /OS-PROTOCOLS`

Response:
    Status: 200 OK
    {
        "OS-PROTOCOLS": {
            "protocols": [
                "saml",
                "moonshot"
            ]
        }
    }

#### List Protocol Providers `GET /OS-PROTOCOLS/providers`
query_string: page (optional)
query_string: per_page (optional, default 30)
query filter for "protocol" (optional)

Response:
    Status: 200 OK
    {
        "OS-PROTOCOLS": {
            "providers": [
                {
                    "protocol": "saml",
                    "name": "My SAML IdP",
                    "links": {
                        "self": "http://localhost:5000/v3/services/123456"
                    },
                    "id": "123456"
                }
                {
                    "protocol": "keystone",
                    "name": "My Remote Keystone",
                    "links": {
                        "self": "http://localhost:5000/v3/services/098765"
                    },
                    "id": "098765"
                }
            ]
        }
    }

In order to list providers for a given protocol, filter the collection using a
query string (e.g., `?protocol={protocol_string}`).

#### Get Provider `GET /OS-PROTOCOLS/providers/<provider-id>`

Response:
    Status: 200 OK
    {
        "OS-PROTOCOLS": {
            "provider": {
                "protocol": "saml",
                "name": "My SAML IdP",
                "links": {
                    "self": "http://localhost:5000/v3/services/123456"
                },
                "id": "123456"
            }
        }
    }