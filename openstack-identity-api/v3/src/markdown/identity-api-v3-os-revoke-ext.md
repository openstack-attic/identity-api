OpenStack Identity API v3 OS-TRUST Extension
============================================

Trusts provide project-specific role delegation between users, with optional
impersonation.

API Resources
-------------

### Trusts

Tokens can be revoked.

Additional required attributes:

- `scope_id` (string)

  Represents .

- `scope_type` (string)

  Represents .


Optional attributes:

- `expires_net` (string, ISO 8601 extended format date time with microseconds)

  Identifies .

- `expires_nlt`: (string, ISO 8601 extended format date time with microseconds)

  Specifies .

- `expires_at` (string, ISO 8601 extended format date time with microseconds)

  Specifies the expiration time of the token.

Example entity:

    {
        "revoked": [{
            "id": "987fe7",
            "scope_id": true,
            "scope_type": "0f1233",
            "links": {
                "self": "http://identity:35357/v3/trusts/987fe7"
            },
            "expires_nlt": "TODO Put Date time here",
            "expires_net": "TODO Put Date time here"
        }]
    }


API
---

#### Checking Token validity against a revocation list : `POST /auth/tokens`


#### Revoke all tokens for a domain: `POST /OS_REVOKE/`

Request:

    {
    }

Response:

    Status: 201 Created

    {
    }

#### Revoke all tokens for a project: `POST /OS_REVOKE/`

Request:

    {
    }

Response:

    Status: 201 Created

    {
    }


#### Revoke all tokens for a user: `POST /OS_REVOKE/`

Request:

    {
    }

Response:

    Status: 201 Created

    {
    }


#### List revocation events: `GET /OS_REVOKE/events`

Response:

    Status: 200 OK

    {
    }

