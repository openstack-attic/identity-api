OpenStack Identity API v3 OS-OAUTH10A Extension
===============================================

Provide an ability for users to delegate roles to third party consumers. This
extension requires v3.0+ of the Identity API.

Consumer APIs
-------------

A Consumer is an application that uses OAuth to access a protected resource.
In Keystone, the Consumer is identified by a `name` and `id`. A Consumer also
has both a `consumer_key` and `consumer_secret`.

* `consumer_key`: A value used by the Consumer to identify itself.
* `consumer_secret`: A secret used by the Consumer to establish ownership
	of the `consumer_key`.

#### Create a Consumer: `POST /OS-OAUTH10A/consumers`

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

#### List Consumers: `GET /OS-OAUTH10A/consumers`

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

#### Get Consumer: `GET /OS-OAUTH10A/consumers/{consumer_id}`

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

#### Delete Consumer: `DELETE /OS-OAUTH10A/consumers/{consumer_id}`

Response:

    Status: 204 No Content

#### Update Consumer: `PATCH /OS-OAUTH10A/consumers/{consumer_id}`

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

Delegated Auth via OAuth
------------------------

Delegated Auth via OAuth is done in four steps:

1. The Consumer obtains an unauthorized Request Token.
2. The User authorizes the Request Token.
3. The Consumer exchanges the Request Token for an Access Token.
4. The Consumer uses the Access Token to request a Keystone Token.


OAuth Definitions
-----------------

* *User:* A keystone user, the entity whose role(s) will be delegated, and
	authorizes Request Tokens.
* *Request Token:* A token used by the Consumer to obtain authorization from
	the User, and exchanged with an OAuth Verifier for an Access Token.
* *Access Token:* A token used by the Consumer to get new Keystone Tokens on
	behalf of the authorizing User, instead of using the User’s credentials.
* *Token Secret:* A secret used by the Consumer to establish ownership of a
	given Token. Both Request and Access Tokens have Secrets.
* *OAuth Verifier:* A four digit verification code tied to the Request Token.
	The OAuth Verifier and Request Token both must be provided to exchange
	for an Access Token.
* *Keystone Token:* A usual, run of the mill Keystone Token, see v3 API.

OAuth Endpoints
----------

* Request Token: Used to obtain an unauthorized Request Token.
    * `GET /OS-OAUTH10A/request_token`
* Access Token: Used to exchange the User authorized Request Token for
	an Access Token.
    * `GET /OS-OAUTH10A/access_token`
* Authenticate Token: Used to request a valid Keystone Token.
    * `POST /OS-OAUTH10A/authenticate`

OAuth APIs
----------

#### Create an unauthorized Request Token: 

A Consumer uses the Consumer Key and Secret to obtain a Request Token.
The Request Token is a token used to initiate User authorization. 
The Request Token - once authorized - can be exchanged, along with the OAuth
Verifier, for an Access Token. 
Note that the extra parameter `requested_roles` must also be supplied.
These are the roles the Consumer would like to access.

#### Endpoint: `GET /OS-OAUTH10A/request_token`
#### Supported signature methods: `HMAC-SHA1`

Request:

    {
        "requested_roles": "role_name"
        "oauth_version": "1.0"
        "oauth_nonce": "d6f59019cdb2f48c9777a7557d2b2269"
        "oauth_timestamp": "1373521644"
        "oauth_consumer_key": "7fea2d"
        "oauth_signature_method": "HMAC-SHA1"
        "oauth_signature": "gBwatRY7XCtE49BnrQ+dE96yzH0="
    }

Response:

    {
        "token": {
            "request_token_key": "bf6903c804b5441da754d220add679ec",
            "request_token_secret": "9908bec765ae47b4b47a685c9401c9ec"
        }
    }

#### Authorize a Request Token: 

A User can authorize a Request Token. To authorize the Request Token,
the authorizing User must be assigned the roles that are being requested.
Upon successful authorization a four digit OAuth Verifier code is returned.

#### Endpoint: `POST /OS-OAUTH10A/authorize/{request_id}/{requested_roles}`

Response:

    {
        "token": {
            "oauth_verifier": "8171"
        }
    }


#### Exchange Request Token and Verifier for an Access Token

After the User authorizes the Request Token, the Consumer exchanges the
authorized Request Token and OAuth Verifire for an Access Token. 

#### Endpoint: `GET /OS-OAUTH10A/access_token`
#### Supported signature methods: `HMAC-SHA1`

Request:

    {
        "oauth_version": "1.0"
        "oauth_nonce": 0b7a413db1b2f4414d5e540b73f2c313"
        "oauth_timestamp": 1373522292"
        "oauth_consumer_key": 7fea2d"
        "oauth_verifier": 8171"
        "oauth_token": bf6903c804b5441da754d220add679ec"
        "oauth_signature_method": HMAC-SHA1"
        "oauth_signature": dwYRzADE9IImtMftuD8xvz48FGs="
    }

Response:

    {
        "token": {
            "access_token_key": "6be26a",
            "access_token_secret": "05f12466ea9c4120a1378310e7fc96a3"
        }
    }

#### Use Access Token to request a Keystone Token

The Consumer can now request a valid Keystone Token which would have the
Users delegated authorization.

#### `POST /OS-OAUTH10A/authenticate`
#### Supported signature methods: `HMAC-SHA1`

Request:

    {
        "oauth_version": "1.0"
        "oauth_nonce": 0b7a413db1b2f4414d5e540b73f2c313"
        "oauth_timestamp": 1373522292"
        "oauth_consumer_key": 7fea2d"
        "oauth_verifier": 5678"
        "oauth_token": bf6903c804b5441da754d220add679ec"
        "oauth_signature_method": HMAC-SHA1"
        "oauth_signature": dwYRzADE9IImtMftuD8xvz48FGs="
    }

Response:

    {
        "token": {
            "id": "e80b74",
            "expires": "2013-02-27T18:30:59.999999Z",
            "user_id": "1789d1"
        }
    }

#### Retrieve verifier of a Request Token: `POST /OS-OAUTH10A/authorization_pin`

Assuming the Request Token has been authorized by a User, the OAuth Verifier
will be returned.

Request:

    {
        "oauth_token": 7fea2d"
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

#### List user authorizations: `GET /OS-OAUTH10A/users/{user_id}/authorizations`

Response:

    {
        "authorizations": [
            {
                "consumer_key": "7fea2d",
                "id": "6be26a",
                "issued_at": "2013-07-11T06:07:51.501805Z",
                "access_key": "6be26a",
                "links": {
                    "self": "http://identity:35357/v3/OS-OAUTH10A/authorizations/6be26a"
                },
                "requested_roles":  ["admin"],
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
Consumer from being able to request new keystone tokens. This would also delete
any tokens for the user as well, thus also removing access if the Consumer has
retrieved any Keystone Tokens.

#### Delete user authorizations: `DELETE /OS-OAUTH10A/users/{user_id}/authorizations/{authorization_id}`

Response:

    Status: 204 No Content
