OpenStack Identity API v3 OS-OAUTH10A Extension
===============================================

Provide the ability for users to delegate roles to third party consumers. This
extension requires v3.0+ of the Identity API. An OAuth-derived token will
provide a means of acting on behalf of the authorizing user.

Definitions
-----------------

- *User:* An Identity API service user, the entity whose role(s) will be
  delegated, and the entity that authorizes Request Tokens.
- *Request Token:* A token used by the Consumer to obtain authorization from
  the User, and exchanged with an OAuth Verifier for an Access Token.
- *Access Token:* A token used by the Consumer to request new Identity API
  Service Tokens on behalf of the authorizing User, instead of using the User’s
  credentials.
- *Token Key:* A key used by the token to identify itself. Both Request and
  Access Tokens have Keys.
- *Token Secret:* A secret used by the Consumer to establish ownership of a
  given Token. Both Request and Access Tokens have Secrets.
- *OAuth Verifier:* A four digit numeric string tied to the Request Token. The
  OAuth Verifier and Request Token both must be provided to exchange for an
  Access Token.

Delegated Authentication Flow
-----------------------------

Delegated Authentication via OAuth is done in four steps:

1. An Identity API service User [creates a Consumer](#Create Consumer).
2. The Consumer [obtains an unauthorized Request Token](#Create Request Token).
3. The User [authorizes the Request Token](#Authorize Request Token).
4. The Consumer [exchanges the Request Token for an Access Token](#Create
   Access Token).
5. The Consumer [uses the Access Token to request a Identity API service
   Token](#Request a Identity API Token).

API Resources
-------------

### Consumers: `/OS-OAUTH10A/consumers`

A Consumer is an application that uses OAuth to access a protected resource.

Additional required attributes:

- `name` (string)

  Globally unique consumer name.

Immutable attributes provided by the Identity service:

- `consumer_key` (string)

  A value used by the Consumer to identify itself.

- `consumer_secret` (string)

  A secret used by the Consumer to establish ownership of the `consumer_key`.
  A consumer's secret is only returned once, during consumer creation.

The Consumer is given it's key and secret, out-of-band.

Consumers API
-------------

### Create Consumer: `POST /OS-OAUTH10A/consumers`

Request:

    {
        "consumer": {
            "name": "consumer_name"
        }
    }

Response:

The `consumer_secret` is only returned once, during consumer creation.

    Status: 201 Created

    {
        "consumer": {
            "consumer_key": "7fea2d",
            "consumer_secret": "4c7832",
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/7fea2d"
            },
            "name": "consumer_name"
        }
    }

### List Consumers: `GET /OS-OAUTH10A/consumers`

Response:

    Status: 200 OK

    {
        "consumers": [
            {
                "consumer_key": "0c2a74",
                "id": "0c2a74",
                "links": {
                    "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/0c2a74"
                },
                "name": "consumer_name_2"
            },
            {
                "consumer_key": "7fea2d",
                "id": "7fea2d",
                "links": {
                    "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/7fea2d"
                },
                "name": "consumer_name"
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-OAUTH10A/consumers"
        }
    }

### Get Consumer: `GET /OS-OAUTH10A/consumers/{consumer_id}`

Response:

    Status: 200 OK

    {
        "consumer": {
            "consumer_key": "7fea2d",
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/7fea2d"
            },
            "name": "consumer_name"
        }
    }

### Delete Consumer: `DELETE /OS-OAUTH10A/consumers/{consumer_id}`

When a Consumer is deleted, any Request Tokens, Access Tokens, or Identity
API service Tokens will also be deleted.

Response:

    Status: 204 No Content

### Update Consumer: `PATCH /OS-OAUTH10A/consumers/{consumer_id}`

Only a Consumer's name is mutable. Attempting to PATCH an immutable
attribute results in a 400.

Request:

    {
        "consumer": {
            "name": "new_consumer_name"
        }
    }

Response:

    Status: 200 OK

    {
        "consumer": {
            "consumer_key": "7fea2d",
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/7fea2d"
            },
            "name": "new_consumer_name"
        }
    }

Delegated Auth APIs
-------------------

### Create Request Token: `POST /OS-OAUTH10A/request_token`

A Consumer uses the Consumer Key and Secret to obtain a Request Token.
The Request Token is used to initiate User authorization.
The Request Token, once authorized, can can be exchanged, along with the
OAuth Verifier for an Access Token.
Note that there are two extra parameters, `requested_role_ids` and
`requested_project_id`. `requested_role_ids` contains the IDs of the roles
the Consumer would like delegated. `requested_project_id` contains the ID of
the project upon which the requested roles must be assigned.
the Identity service may include an `oauth_expires_at` attribute in the
response. if no such attribute is included, or is null, then the token lasts
indefinitely.

The authorizing User receives the Request Token Key and requested roles from
the Consumer out-of-band.

#### Supported signature methods: `HMAC-SHA1`

Request Parameters:

- All usual OAuth parameters must be provided.
    See: [http://oauth.net/core/1.0a/#auth_step1](http://oauth.net/core/1.0a/#auth_step1)

Additional Request Parameters:

- `requested_role_ids`: IDs of requested roles, comma separated

  - Example: `requested_role_ids=a3b29b,49993e`

- `requested_project_id`: IDs of requested project

  - Example: `requested_project_id=b9fca3`

Response:

  `oauth_token=29971f&oauth_token_secret=238eb8&oauth_expires_at=2013-09-11T06:07:51.501805Z`

Response Parameters:

  - `oauth_token`: The Request Token that the Identity Service returns.
  - `oauth_token_secret`: The secret associated with the Request Token.
  - `oauth_expires_at`: The date and time when a Request Token will expire.

### Authorize Request Token: `POST /OS-OAUTH10A/authorize/{request_key}`

To authorize the Request Token, the authorizing user must have the
requested role assignments on the requested project.
Upon successful authorization a four digit OAuth Verifier code is returned.
The Consumer receives the OAuth Verifier from the User out-of-band.

Request:

    {
        "roles": {
            "id": "xyz789",
            "links": {
                "self": "http://identity:35357/v3/roles/xyz789"
            },
            "name": "manager"
        }
    }

Response:

    {
        "token": {
            "oauth_verifier": "8171"
        }
    }

### Create Access Token: `POST /OS-OAUTH10A/access_token`

After the User authorizes the Request Token, the Consumer exchanges the
authorized Request Token and OAuth Verifier for an Access Token.
the Identity service may include an `oauth_expires_at` attribute in the
response. If no such attribute is included, or is null, then the token lasts
indefinitely.

#### Supported signature methods: `HMAC-SHA1`

Request Parameters:

- All usual oauth parameters must be provided.
    See: [http://oauth.net/core/1.0a/#auth_step3](http://oauth.net/core/1.0a/#auth_step3)

Response:

  `oauth_token=aj9CovPUo44isTgs9F&oauth_token_secret=tCoZQiHWPMe8HMv5LFYPZvsMp3tkG5u_QM&oauth_expires_at=2013-09-11T06:07:51.501805Z`

Response Parameters:

  - `oauth_token`: The Request Token that the Identity Service returns.
  - `oauth_token_secret`: The secret associated with the Request Token.
  - `oauth_expires_at`: The date and time when an Access Token will expire.

### Request a Identity API Token: `POST /auth/tokens`

The Consumer can now request valid Identity API service tokens which would have the
User's delegated authorization. An OAuth-derived token provides a means to
impersonate the authorizing user. The generated token's roles will match the
requested roles that the Consumer initially requested.

#### Supported signature methods: `HMAC-SHA1`

Request Parameters:

- All usual oauth parameters must be provided.
    See: [http://oauth.net/core/1.0a/#anchor12](http://oauth.net/core/1.0a/#anchor12)

The returned token is scoped to the requested project and with the requested
roles. In addition to the usual token response, as seen in the link below,
the token has an OAuth section.

Example OpenStack token response: [Various Openstack token responses](https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses)

Example OAuth section of a token:

    {
        "OS-OAUTH10A": {
            "access_key": "cce0b8be7",
            "consumer_id": "181f67c7",
            "consumer_name": "consumer_name",
            "roles": [
                {
                    "id": "f381f0f600e",
                    "name": "admin"
                }
            ]
        }
    }

User Access Token APIs
----------------------

A User can list Access Tokens that have been authorized.

### List user authorizations: `GET /OS-OAUTH10A/users/{user_id}/authorizations`

Response:

    {
        "authorizations": [
            {
                "consumer_key": "7fea2d",
                "id": "6be26a",
                "expires_at": "2013-09-11T06:07:51.501805Z",
                "access_key": "6be26a",
                "links": {
                    "self": "http://identity:35357/v3/OS-OAUTH10A/authorizations/6be26a"
                },
                "requested_role_ids": [
                    {
                        "id": "76e72a",
                        "name": "admin",
                        "links": {
                            "self": "http://identity:35357/v3/roles/76e72a"
                        }
                    }
                ],
                "requested_project_id": "b9fca3",
                "authorizing_user_id": "ce9e07"
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-OAUTH10A/users/ce9e07/authorizations"
        }
    }

A User can remove authorization of an Access Token, preventing the Consumer
from requesting new Identity API service tokens. This also revokes any
Identity API tokens issued to the Consumer.

### Delete user authorization: `DELETE /OS-OAUTH10A/users/{user_id}/authorizations/{access_key}`

Response:

    Status: 204 No Content
