OpenStack Identity API v3 OS-OAUTH10A Extension
===============================================

Provide an ability for users to delegate roles to third party consumers. This
extension requires v3.0+ of the Identity API.

Definitions
-----------------

- *User:* An Identity API service user, the entity whose role(s) will be
     delegated, and authorizes Request Tokens.
- *Request Token:* A token used by the Consumer to obtain authorization from
     the User, and exchanged with an OAuth Verifier for an Access Token.
- *Access Token:* A token used by the Consumer to get new Identity API service Tokens on
     behalf of the authorizing User, instead of using the User’s credentials.
- *Token Secret:* A secret used by the Consumer to establish ownership of a
     given Token. Both Request and Access Tokens have Secrets.
- *OAuth Verifier:* A four digit numeric string tied to the Request Token.
     The OAuth Verifier and Request Token both must be provided to exchange
     for an Access Token.

Delegated Authentication Flow
-----------------------------

Delegated Authentication via OAuth is done in four steps:

1. An Identity API service User [creates a consumer](#Create Consumer).
2. The Consumer [obtains an unauthorized Request Token](#Create Request Token).
3. The User [authorizes the Request Token](#Authorize Request Token).
4. The Consumer [exchanges the Request Token for an Access Token](#Create Access Token).
5. The Consumer [uses the Access Token to request a Identity API service Token](#Request a Identity API Token).

Consumer APIs
-------------

A Consumer is an application that uses OAuth to access a protected resource.
The Consumer is identified by a `name` and `id`. A Consumer also
has both a `consumer_key` and `consumer_secret`.

- `consumer_key`: A value used by the Consumer to identify itself.
- `consumer_secret`: A secret used by the Consumer to establish ownership
     of the `consumer_key`.

The Consumer is given it's key and secret, out-of-band.

### Create Consumer
#### Endpoint: `POST /OS-OAUTH10A/consumers`

Request:

    {
        "consumer": {
            "name": "consumer_name"
        }
    }

Response:

    Status: 201 Created

    {
        "consumer": {
            "consumer_key": "7fea2d",
            "consumer_secret": "4c7832",
            "domain_id": "default",
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/7fea2d"
            },
            "name": "consumer_name"
        }
    }

### List Consumers
#### Endpoint: `GET /OS-OAUTH10A/consumers`

Response:

    Status: 200 OK

    {
        "consumers": [
            {
                "consumer_key": "0c2a74",
                "consumer_secret": "8eccec",
                "domain_id": "default",
                "id": "0c2a74",
                "links": {
                    "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/0c2a74"
                },
                "name": "consumer_name_2"
            },
            {
                "consumer_key": "7fea2d",
                "consumer_secret": "4c7832",
                "domain_id": "default",
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

### Get Consumer
#### Endpoint: `GET /OS-OAUTH10A/consumers/{consumer_id}`

Response:

    Status: 200 OK

    {
        "consumer": {
            "consumer_key": "7fea2d",
            "consumer_secret": "4c7832",
            "domain_id": "default",
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/7fea2d"
            },
            "name": "consumer_name"
        }
    }

### Delete Consumer
#### Endpoint: `DELETE /OS-OAUTH10A/consumers/{consumer_id}`

When a consumer is deleted, any Request Tokens, Access Tokens, or Identity
API service Tokens will also be deleted.

Response:

    Status: 204 No Content

### Update Consumer
#### Endpoint: `PATCH /OS-OAUTH10A/consumers/{consumer_id}`

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
            "consumer_secret": "4c7832",
            "domain_id": "default",
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/7fea2d"
            },
            "name": "new_consumer_name"
        }
    }


Delegated Auth APIs
-------------------

### Create Request Token

A Consumer uses the Consumer Key and Secret to obtain a Request Token.
The Request Token is a token used to initiate User authorization.
The Request Token - once authorized - can be exchanged, along with the OAuth
Verifier, for an Access Token.
Note that the extra parameter `requested_roles` must also be supplied.
These are the roles the Consumer would like to access.

The Consumer would tell the authorizing User the request key and requested
roles, out-of-band.

#### Endpoint: `POST /OS-OAUTH10A/request_token`
#### Supported signature methods: `HMAC-SHA1`

Request Parameters:

- All usual oauth parameters must be provided.
    See: http://oauth.net/core/1.0a/#auth_step1

Additional Request Parameters:

- requested_roles: name of requested roles, comma separated

Response:

    {
        "token": {
            "request_token_key": "bf6903c804b5441da754d220add679ec",
            "request_token_secret": "9908bec765ae47b4b47a685c9401c9ec"
        }
    }

### Authorize Request Token:

A User can authorize a Request Token. To authorize the Request Token,
the authorizing User must be assigned the roles that are being requested.
Upon successful authorization a four digit OAuth Verifier code is returned.

The User would tell the Consumer the verifier, out-of-band.

#### Endpoint: `POST /OS-OAUTH10A/authorize/{request_id}/{requested_roles}`

Response:

    {
        "token": {
            "oauth_verifier": "8171"
        }
    }


### Create Access Token

After the User authorizes the Request Token, the Consumer exchanges the
authorized Request Token and OAuth Verifire for an Access Token.

#### Endpoint: `POST /OS-OAUTH10A/access_token`
#### Supported signature methods: `HMAC-SHA1`

Request Parameters:

- All usual oauth parameters must be provided.
    See: http://oauth.net/core/1.0a/#auth_step3

Response:

    {
        "token": {
            "access_token_key": "6be26a",
            "access_token_secret": "05f12466ea9c4120a1378310e7fc96a3"
        }
    }

### Request a Identity API Token

The Consumer can now request valid Identity API service tokens which would have the
User's delegated authorization.

#### `GET /OS-OAUTH10A/authenticate`
#### Supported signature methods: `HMAC-SHA1`

Request Parameters:

- All usual oauth parameters must be provided.
    See: http://oauth.net/core/1.0a/#anchor12

A token scoped to a project will also have a service catalog, along with the
user's roles applicable to the project.

Example Response:

https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses

### Retrieve verifier of a Request Token
#### Endpoint: `POST /OS-OAUTH10A/authorization_pin`

Assuming the Request Token has been authorized by a User, the OAuth Verifier
will be returned.

Request:

    {
        "oauth_token": "7fea2d"
    }

Response:

    {
        "token": {
            "oauth_verifier": "5678"
        }
    }

User Access Token APIs
----------------------

A User can list access tokens that have been authorized.

### List user authorizations
#### Endpoint: `GET /OS-OAUTH10A/users/{user_id}/authorizations`

Response:

    {
        "authorizations": [
            {
                "consumer_key": "7fea2d",
                "id": "6be26a",
                "issued_at": "2013-07-11T06:07:51.501805Z",
                "expires_at": "2013-11-11T06:07:51.501805Z",
                "access_key": "6be26a",
                "links": {
                    "self": "http://identity:35357/v3/OS-OAUTH10A/authorizations/6be26a"
                },
                "requested_roles": [
                    {
                        "id": "76e72a",
                        "name": "admin",
                        "links": {
                            "self": "http://identity:35357/v3/roles/76e72a"
                        }
                    }
                ],
                "project_id": "bff721",
                "user_id": "ce9e07"
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-OAUTH10A/users/ce9e07/authorizations"
        }
    }

A User can remove authorization of an access token, preventing the
Consumer from being able to request new Identity API service tokens. This would also delete
any tokens for the user as well, thus also removing access if the Consumer has
retrieved any Identity API service tokens.

### Delete user authorizations
#### Endpoint: `DELETE /OS-OAUTH10A/users/{user_id}/authorization/{authorization_id}`

Response:

    Status: 204 No Content
