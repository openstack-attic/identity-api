OpenStack Identity API v3 OS-SHARED-SECRET-AUTHENTICATION Extension
===================================================================

Provide the ability for identity users to request a token using a shared
secret authentication method. This extension requires v3.0+ of the Identity API.
The user provides an identification method using a `credential_id` and the
corresponding shared secret information as a `secret`.

`Shared-secret` is facilitated by the `credentials` resource in Identity API v3.

Definitions
-----------

- *User:* An Identity API service user and the entity that authorizes the
  creation of an Access Token.
- *Access Token:* A token used to request new Identity API tokens
  tokens on behalf of the authorizing User, instead of using the User’s
  credentials.
- *Credential_id:* An id used by the User to identify the corresponding
  credentials.
- *Shared-Secret:* A shared secret used by the User to establish ownership of
  the Request.

Authentication Flow
-------------------

Authentication via Shared Secret is done in two steps:

1. A `credentials` resource is created in Identity API v3 with `type` equal to
   `shared-secret`, where the `blob` is an ASCII string.
2. An Identity API service User requests an Identity API token passing
   `credential_id` and `secret` as part of the `shared-secret` method.

API Resources
-------------

### Credential APIs

This specification establishes a new credential type `shared-secret`, which will
be used by the `shared-secret` authentication method. The `blob` field shell
contains an ASCII string.

Example:

{
    "credential": {
        "blob": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
        "id": "3512532",
        "links": {
            "self": "http://identity:35357/v3/credentials/3512532"
        },
        "project_id": "263fd9",
        "type": "shared-secret",
        "user_id": "0ca8f6"
    }
}

### Request an Identity API Token: `POST /auth/tokens`

To perform `shared-secret` authentication, `credential_id` and `secret` must be
specified in the authentication payload. `credential_id` and `secret` must match
`id` and `blob` of an existing credential of type `shared-secret`.

Example request:

    {
        "auth": {
            "identity": {
                "methods": [
                    "shared-secret"
                ],
                "shared-secret": {
                    "credential_id":"3512532",
                    "secret":"wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
                }
            }
        }
    }

The returned token for the above request is unscoped.

However, this identity method can be used in conjunction with the scope
attribute using the syntax described in the Identity API.

Example OpenStack token response: [Various OpenStack token responses](https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses)
