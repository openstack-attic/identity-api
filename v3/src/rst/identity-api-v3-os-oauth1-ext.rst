OpenStack Identity API v3 OS-OAUTH1 Extension
=============================================

Provide the ability for identity users to delegate roles to third party
consumers via the `OAuth 1.0a
specification <http://oauth.net/core/1.0a/>`__. This extension requires
v3.0+ of the Identity API. An OAuth-derived token will provide a means
of acting on behalf of the authorizing user.

Definitions
-----------

-  *User:* An Identity API service user, the entity whose role(s) will
   be delegated, and the entity that authorizes Request Tokens.
-  *Request Token:* A token used by the Consumer to obtain authorization
   from the User, and exchanged with an OAuth Verifier for an Access
   Token.
-  *Access Token:* A token used by the Consumer to request new Identity
   API tokens on behalf of the authorizing User, instead of using the
   User’s credentials.
-  *Token Key:* A key used by the token to identify itself. Both Request
   Tokens and Access Tokens have Token Keys. For OpenStack purposes, the
   Token Key is the Token ID.
-  *Token Secret:* A secret used by the Consumer to establish ownership
   of a given Token. Both Request Tokens and Access Tokens have Token
   Secrets.
-  *OAuth Verifier:* A string that must be provided with the
   corresponding Request Token in exchange for an Access Token.

Delegated Authentication Flow
-----------------------------

Delegated Authentication via OAuth is done in five steps:

1. An Identity API service User `creates a
   Consumer <#create-consumer-post-os-oauth1consumers>`__.
2. The Consumer `obtains an unauthorized Request
   Token <#create-request-token-post-os-oauth1request_token>`__.
3. The User `authorizes the Request
   Token <#authorize-request-token-put-os-oauth1authorizerequest_token_id>`__.
4. The Consumer `exchanges the Request Token for an Access
   Token <#create-access-token-post-os-oauth1access_token>`__.
5. The Consumer `uses the Access Token to request an Identity API
   service Token <#request-an-identity-api-token-post-authtokens>`__.

API Resources
-------------

Consumers
~~~~~~~~~

::

    /OS-OAUTH1/consumers

A Consumer is an application that uses OAuth to access a protected
resource.

Optional attributes:

-  ``description`` (string)

Immutable attributes provided by the Identity service:

-  ``secret`` (string)

A consumer's ``secret`` is only returned once, during consumer creation.

The Consumer is given its key and secret, out-of-band. For OpenStack,
the ID of the Consumer is the Key.

Consumers API
-------------

Create Consumer
~~~~~~~~~~~~~~~

::

    POST /OS-OAUTH1/consumers

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/consumers``

Request:

::

    {
        "consumer": {
            "description": "My consumer"
        }
    }

Response:

The ``secret`` is only returned once, during consumer creation.

::

    Status: 201 Created

    {
        "consumer": {
            "secret": "4c7832",
            "description": "My consumer",
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH1/consumers/7fea2d"
            }
        }
    }

List Consumers
~~~~~~~~~~~~~~

::

    GET /OS-OAUTH1/consumers

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/consumers``

Response:

::

    Status: 200 OK

    {
        "consumers": [
            {
                "id": "0c2a74",
                "links": {
                    "self": "http://identity:35357/v3/OS-OAUTH1/consumers/0c2a74"
                }
            },
            {
                "description": "My consumer",
                "id": "7fea2d",
                "links": {
                    "self": "http://identity:35357/v3/OS-OAUTH1/consumers/7fea2d"
                }
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-OAUTH1/consumers"
        }
    }

Get Consumer
~~~~~~~~~~~~

::

    GET /OS-OAUTH1/consumers/{consumer_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/consumer``

Response:

::

    Status: 200 OK

    {
        "consumer": {
            "id": "7fea2d",
            "description": "My consumer",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH1/consumers/7fea2d"
            }
        }
    }

Delete Consumer
~~~~~~~~~~~~~~~

::

    DELETE /OS-OAUTH1/consumers/{consumer_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/consumer``

When a Consumer is deleted, any Request Tokens, Access Tokens, or
Identity API Tokens will also be deleted.

Response:

::

    Status: 204 No Content

Update Consumer
~~~~~~~~~~~~~~~

::

    PATCH /OS-OAUTH1/consumers/{consumer_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/consumer``

Only a Consumer's ``description`` is mutable. Attempting to PATCH an
immutable attribute should result in a HTTP 400 Bad Request.

Request:

::

    {
        "consumer": {
            "description": "My new consumer"
        }
    }

Response:

::

    Status: 200 OK

    {
        "consumer": {
            "description": "My new consumer",
            "id": "7fea2d",
            "links": {
                "self": "http://identity:35357/v3/OS-OAUTH1/consumers/7fea2d"
            }
        }
    }

Delegated Auth APIs
-------------------

Create Request Token
~~~~~~~~~~~~~~~~~~~~

::

    POST /OS-OAUTH1/request_token

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/request_tokens``

A Consumer uses the Consumer Key and Secret to obtain a Request Token.
The Request Token is used to initiate User authorization. The Request
Token, once authorized, can be exchanged along with the OAuth Verifier
for an Access Token. Note that there is one extra parameter,
``requested_project_id``. ``requested_project_id`` contains the ID of
the project upon which the Consumer would like authorization. The
Identity service may include an ``oauth_expires_at`` attribute in the
response. If no such attribute is included, or is null, then the token
may last indefinitely.

The authorizing User receives the Request Token Key from the Consumer
out-of-band.

Supported signature methods: ``HMAC-SHA1``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Request Parameters:

-  All required OAuth parameters must be provided.

See: http://oauth.net/core/1.0a/#auth_step1

Additional Request Parameters:

-  ``requested_project_id``: IDs of requested project

-  Example: ``requested_project_id=b9fca3``

Response:

``oauth_token=29971f&oauth_token_secret=238eb8&oauth_expires_at=2013-09-11T06:07:51.501805Z``

Response Parameters:

-  ``oauth_token``: The Request Token key that the Identity API returns.
-  ``oauth_token_secret``: The secret associated with the Request Token.
-  ``oauth_expires_at`` (optional): The ISO 8601 date time at which a
   Request Token will expire.

Authorize Request Token
~~~~~~~~~~~~~~~~~~~~~~~

::

    PUT /OS-OAUTH1/authorize/{request_token_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/authorize_request_token``

To authorize the Request Token, the authorizing user must have access to
the requested project. Upon successful authorization, an OAuth Verifier
code is returned. The Consumer receives the OAuth Verifier from the User
out-of-band.

Request:

::

    {
        "roles": [
            {
                "id": "a3b29b"
            },
            {
                "id": "49993e"
            }
        ]
    }

Response:

::

    {
        "token": {
            "oauth_verifier": "8171"
        }
    }

Create Access Token
~~~~~~~~~~~~~~~~~~~

::

    POST /OS-OAUTH1/access_token

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/access_tokens``

After the User authorizes the Request Token, the Consumer exchanges the
authorized Request Token and OAuth Verifier for an Access Token. The
Identity service may include an ``oauth_expires_at`` parameter in the
response. If no such parameter is included, then the token lasts
indefinitely.

Supported signature methods: ``HMAC-SHA1``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Request Parameters:

-  All required OAuth parameters must be provided.

See: http://oauth.net/core/1.0a/#auth_step3

Response:

::

    oauth_token=accd36&oauth_token_secret=aa47da&oauth_expires_at=2013-09-11T06:07:51.501805Z

Response Parameters:

-  ``oauth_token``: The Access Token key that the Identity API returns.
-  ``oauth_token_secret``: The secret associated with the Access Token.
-  ``oauth_expires_at`` (optional): The ISO 8601 date time when an
   Access Token expires.

Request an Identity API Token
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    POST /auth/tokens

Relationship: ``http://docs.openstack.org/identity/rel/v3/auth_tokens``

The Consumer can now request valid Identity API service tokens
representing the authorizing User's delegated authorization and identity
(impersonation). The generated token's roles and scope will match that
which the Consumer initially requested.

Supported signature methods: ``HMAC-SHA1``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Request Parameters:

-  All required OAuth parameters must be provided.

See: http://oauth.net/core/1.0a/#anchor12

To authenticate with the OS-OAUTH1 extension, ``oauth1`` must be
specified as an authentication method. Example request:

::

    {
        "auth": {
            "identity": {
                "methods": [
                    "oauth1"
                ],
                "oauth1": {}
            }
        }
    }

The returned token is scoped to the requested project and with the
delegated roles. In addition to the standard token response, as seen in
the link below, the token has an OAuth-specific object.

Example OpenStack token response: `Various OpenStack token
responses <https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#authentication-responses>`__

Example OAuth-specific object in a token:

::

    "OS-OAUTH1": {
        "consumer_id": "7fea2d",
        "access_token_id": "cce0b8be7"
    }

User Access Token APIs
----------------------

List authorized access tokens
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    GET /users/{user_id}/OS-OAUTH1/access_tokens

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/user_access_tokens``

Response:

::

    {
        "access_tokens": [
            {
                "consumer_id": "7fea2d",
                "id": "6be26a",
                "expires_at": "2013-09-11T06:07:51.501805Z",
                "links": {
                    "roles": "http://identity:35357/v3/users/ce9e07/OS-OAUTH1/access_tokens/6be26a/roles"
                    "self": "http://identity:35357/v3/users/ce9e07/OS-OAUTH1/access_tokens/6be26a"
                },
                "project_id": "b9fca3",
                "authorizing_user_id": "ce9e07"
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/users/ce9e07/OS-OAUTH1/access_tokens"
        }
    }

Get authorized access token
~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    GET /users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/user_access_token``

Response:

::

    {
        "access_token": {
            "consumer_id": "7fea2d",
            "id": "6be26a",
            "expires_at": "2013-09-11T06:07:51.501805Z",
            "links": {
                "roles": "http://identity:35357/v3/users/ce9e07/OS-OAUTH1/access_tokens/6be26a/roles"
                "self": "http://identity:35357/v3/users/ce9e07/OS-OAUTH1/access_tokens/6be26a"
            },
            "project_id": "b9fca3",
            "authorizing_user_id": "ce9e07"
        }
    }

List roles of an access token
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    GET /users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/user_access_token_roles``

See ``GET /v3/roles`` for an
`example <https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#list-roles-get-roles>`__
of this response format.

Get a role of an access token
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    GET /users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles/{role_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/user_access_token_role``

See ``GET /v3/roles/{role_id}`` for an
`example <https://github.com/openstack/identity-api/blob/master/openstack-identity-api/v3/src/markdown/identity-api-v3.md#get-role-get-rolesrole_id>`__
of this response format.

Revoke access token
~~~~~~~~~~~~~~~~~~~

::

    DELETE /users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-OAUTH1/1.0/rel/user_access_token``

A User can revoke an Access Token, preventing the Consumer from
requesting new Identity API service tokens. This also revokes any
Identity API tokens issued to the Consumer using that Access Token.

Response:

::

    Status: 204 No Content

