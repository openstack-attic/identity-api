OpenStack Identity API v3 OS-ACCESS-KEY Extension
=================================================

Provide the ability for identity users to request a token using an access-key
authorization method. This extension requires v3.0+ of the Identity API. 
The user provides an identification method using an `access-key` and the
corresponding secret information as a `secret-key`.

Definitions
-----------

- *User:* An Identity API service user and the entity that authorizes the
  creation of an Access Tokens.
- *Access Token:* A token used to request new Identity API tokens
  tokens on behalf of the authorizing User, instead of using the User’s
  credentials.
- *Access Key:* A key used by the User to identify itself.
- *Secret Key:* A secret used by the User to establish ownership of the
  Request.

Authentication Flow
-------------------

Authentication via Access Key is done in two steps:

1. An Identity API service User requests an Identity API token passing
   access-key and secret-key.
2. The Identity API service validates the User request, decypher the
   `secret-key` stored in the service's keys store and compares it with the
   `secret-key` provided in the request.

API Resources
-------------

### Request an Identity API Token: `POST /auth/tokens`

The User can identify itself providing a unique key, `access-key`, and a shared
secret with the service, `secret-key`. The secret and access key management is
provided by the Credential API service.

Request Parameters:

To authenticate with the OS-ACCESS-KEY extension, `access-key` must be specified
as an authentication method.
Example request:

    {
        "auth": {
            "identity": {
                "methods": [
                    "access-key"
                ],
                "access-key": {
                    "access":"VCAVE3Y6RL9K8ADVKMY5",
                    "secret":"quyNVz7gMtpG9QsLz0DUrqGocYbr5X+KGbkJsqzs"
                }
            }
        }
    }

The returned token is scoped to the requested project and with the User's roles.

Example OpenStack token response: [Various OpenStack token responses](https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses)
