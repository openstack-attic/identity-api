OpenStack Identity API v3 OS-ACCESS-ID Extension
=================================================

Provide the ability for identity users to request a token using an access-id
authorization method. This extension requires v3.0+ of the Identity API.
The user provides an identification method using an `id` and the
corresponding secret information as a `secret`.

Definitions
-----------

- *User:* An Identity API service user and the entity that authorizes the
  creation of an Access Tokens.
- *Access Token:* A token used to request new Identity API tokens
  tokens on behalf of the authorizing User, instead of using the User’s
  credentials.
- *Id:* An id used by the User to identify itself.
- *Secret:* A secret used by the User to establish ownership of the
  Request.

Authentication Flow
-------------------

Authentication via Access Id is done in two steps:

1. An Identity API service User requests an Identity API token passing
   `id` and `secret` as part of the `access-id` method.
2. The Identity API service validates the User request, decypher the
   `secret` stored in the service's keys store and compares it with the
   `secret` provided in the request.

API Resources
-------------

### Request an Identity API Token: `POST /auth/tokens`

The User can identify itself providing a unique id, `id`, and a shared
secret with the service, `secret`. The secret and access id management is
provided by the Credential API service.

Request Parameters:

To authenticate with the OS-ACCESS-ID extension, `access-id` must be specified
as an authentication method.
Example request:

    {
        "auth": {
            "identity": {
                "methods": [
                    "access-id"
                ],
                "access-id": {
                    "id":"VCAVE3Y6RL9K8ADVKMY5",
                    "secret":"quyNVz7gMtpG9QsLz0DUrqGocYbr5X+KGbkJsqzs"
                }
            }
        }
    }

The returned token is unscoped. This identity method can be scoped to a project
following the same syntax described in the Identity API.

Example OpenStack token response: [Various OpenStack token responses](https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses)
