OpenStack Identity API v3 OS-SHARED-SECRET Extension
====================================================

Provide the ability for identity users to request a token using an shared
secret authorization method. This extension requires v3.0+ of the Identity API.
The user provides an identification method using an `id` and the
corresponding shared secret information as a `shared-secret`.

Definitions
-----------

- *User:* An Identity API service user and the entity that authorizes the
  creation of an Access Tokens.
- *Access Token:* A token used to request new Identity API tokens
  tokens on behalf of the authorizing User, instead of using the User’s
  credentials.
- *Id:* An id used by the User to identify the corresponding credentials.
- *Shared-Secret:* A shared secret used by the User to establish ownership of
  the Request.

Authentication Flow
-------------------

Authentication via Shared Secret is done in two steps:

1. In the Credential API a shared-secret type is defined. This type defines
   the blob as a shared-secred composed by a string having at least 64 and no
   more than 512 characters.
2. An Identity API service User requests an Identity API token passing `id` and
   `secret` as part of the `shared-secret` method.

API Resources
-------------

### Request an Identity API Token: `POST /auth/tokens`

The User can identify the credentials to use by providing a unique id, `id`,
and a shared secret with the service, `shared-secret`. The secret and access id
management is provided by the Credential API service as illustrated in the
example below:

{
    "credential": {
        "blob": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
        "id": "3512532",
        "links": {
            "self": "http://identity:35357/v3/credentials/80239a"
        },
        "project_id": "263fd9",
        "type": "shared-secret",
        "user_id": "0ca8f6"
    }
}

Request Parameters:

To authenticate with the OS-SHARED-SECRET extension, `access-id` must be
specified as an authentication method.
Example request:

    {
        "auth": {
            "identity": {
                "methods": [
                    "shared-secret"
                ],
                "shared-secret": {
                    "id":"3512532",
                    "secret":"wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
                }
            }
        }
    }

The returned token for the above request is unscoped.

However, this identity method can be used in conjunctio with the scope attribute
using the syntax described in the Identity API.

Example OpenStack token response: [Various OpenStack token responses](https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses)
