OpenStack Identity API v3 OS-OAUTH10A Extension
===============================================

Provide an ability for users to delegate roles to third party consumers. This
extension requires v3.1 of the Identity API.

Consumer CRUD APIs
------------------

A consumer is any service that wishes to have delegated access, it is
identified by a name and id (consumer-key), as well as a consumer-secret.

A keystone admin should be able to perform basic CRUD operations on consumer
entities.

#### Create a consumer: `POST /OS-OAUTH10A/consumers`

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
            "domain_id": null,
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/7fea2d"
            },
            "name": "consumer_name"
        }
    }

#### List consumers: `GET /OS-OAUTH10A/consumers`

Response:

    Status: 200 OK

    {
        "consumers": [
            {
                "consumer_key": "0c2a74",
                "consumer_secret": "8eccec",
                "domain_id": null,
                "id": "0c2a74",
                "links": {
                    "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/0c2a74"
                },
                "name": "consumer_name_2"
            },
            {
                "consumer_key": "7fea2d",
                "consumer_secret": "4c7832",
                "domain_id": null,
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

#### Get consumer: `GET /OS-OAUTH10A/consumer/{consumer_id}`

Response:

    Status: 200 OK

    {
        "consumer": {
            "consumer_key": "7fea2d",
            "consumer_secret": "4c7832",
            "domain_id": null,
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/7fea2d"
            },
            "name": "consumer_name"
        }
    }

#### Delete consumer: `DELETE /OS-OAUTH10A/delete_consumer/{consumer_id}`

Response:

    Status: 204 No Content

#### Update consumer: `PATCH /OS-OAUTH10A/update_consumer/{consumer_id}`

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
            "domain_id": null,
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH10A/consumers/7fea2d"
            },
            "name": "new_consumer_name"
        }
    }

OAuth APIs
----------

A consumer can send an OAuth-signed request to retrieve a request token.
Though only the consumer_key is seen below; the consumer would also provide the
consumer_secret to the OAuth client of their choice. Along with this
information,the consumer would identify the keystone role they wish to have
delegated authority to. Upon a successful return the consumer will have a
return token.

#### Create a request token: `GET /OS-OAUTH10A/request_token`

Request:

    {
        "oauth_version": "1.0"
        "oauth_nonce": "d6f59019cdb2f48c9777a7557d2b2269"
        "oauth_timestamp": "1373521644"
        "oauth_consumer_key": "7fea2d"
        "requested_roles": "role_name"
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

A keystone user can authorize a request token. To authorize the request token,
the authorizing user must have the roles that is being requested. Upon
successful authorization a 4-digit verifier code will be returned.

#### Authorize a request token: `POST /OS-OAUTH10A/authorize/{request_id}/{requested_roles}`

Response:

    {
        "token": {
            "oauth_verifier": "8171"
        }
    }

A consumer can send an OAuth-signed request to retrieve an access token. The
consumer will exchange both the request token and verifier for an access token.
Though only the consumer key (oauth_consumer_key) and request key (oauth_token)
are seen below; the consumer would also have to provide the consumer secret and
request secret to the OAuth client of their choice. Upon a successful return
the consumer will have an access token.

#### Create an access token: `POST /OS-OAUTH10A/access_token`

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

A consumer can send an OAuth-signed request to retrieve a keystone token. The
consumer can now use the access token to obtain a keystone, via an OAuth-signed
request. The consumer key (oauth_consumer_key) and access token key
(oauth_token) are seen below; but the consumer would also have to provide the
consumer secret and access secret to the OAuth client of their choice. Upon a
successful return the consumer will have a keystone token.

#### Authenticate with access token: `POST /OS-OAUTH10A/authenticate`

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
            "expires": "2013-02-27T18:30:59.999999Z"
            "user_id": "1789d1"
        }
    }

#### Retrieve verifier of a request token: `POST /OS-OAUTH10A/authorization_pin`

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

User Access Token CRUD APIs
---------------------------

A keystone user can list access tokens that have been authorized.

#### List user authorizations: `GET /OS-OAUTH10A/users/{user_id}/authorizations`

Response:

    {
        "authorizations": [
            {
                "consumer_key": "7fea2d",
                "id": "6be26a",
                "issued_at": "2013-07-11T06:07:51.501805Z",
                "key": "6be26a",
                "links": {
                    "self": "http://identity:35357/v3/OS-OAUTH10A/authorizations/6be26a"
                },
                "requested_roles": "admin",
                "secret": "05f12466ea9c4120a1378310e7fc96a3",
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

A keystone user can remove authorization of an access token, preventing the
consumer from being able to request new keystone tokens. This would also delete
any tokens for the user as well, thus also removing access if the consumer has
retrieved any keystone tokens as well.

#### Delete user authorizations: `DELETE /OS-OAUTH10A/users/{user_id}/authorizations/{authorization_id}`

Response:

    Status: 204 No Content
