OpenStack Identity API v3 OS-REVOKE Extension
============================================

The OS-REVOKE extension provides lists of revocation events.  Each event expresses a set of criteria for indicating that a set of tokens are no longer valid.

This extension requires v3.2+ of the Identity API.

API Resources
-------------

### Revocation Events

Revocation events are objects that contain criteria used to evaluate token
validity.  Tokens that match the criteria of a revocation event are considered
revoked, and should not be accepted as proof of authorization for the user.
.

Required attributes:

- `id` Unique identifier for the revocation event.

- `scope_id` (string)

  Unique Identifier for the entity covered by the revocation event.

- `scope_type` (string)

  Represents what type of entity the revocation event covers.  Valid values are
  'user', 'project', 'domain' and 'trust'

- `valid_until` (string, ISO 8601 extended format date time with microseconds)

  Represents how long the expiration event is valid.


Optional attributes:

Revocation can be based on two different attributes of the token: `issued_at`
or `expires_at`.  For each of these values, an event may specify cut off times.
Attributes name `at_or_before` limit the latest times for tokens, and
attributes named `at_or_after` limit the earliest times for tokens.

A token that meets all of the criteria specified is considered revoked.

- `issued_at_or_before`
    (string, ISO 8601 extended format date time with microseconds)

- `issued_at_or_after`
    (string, ISO 8601 extended format date time with microseconds)


If only `issued_at_or_before` is specified, all tokens issued at or before
that time are revoked

If only `issued_at_or_after` is specified, all tokens issued at or after
that time are revoked.

If both values are specified, only token's with issued times that match
both are revoked.


- `expires_at_or_before`: (string, ISO 8601 extended format date time with microseconds)


- `expires_at_or_after` (string, ISO 8601 extended format date time with microseconds)


If only `expires_at_or_before` is specified, all tokens with `expires_at`
values that are at or before that time are revoked

If only `expires_at_or_after` is specified, all tokens all tokens with
`expires_ at` that are at or after that time are revoked.

If both values are specified, only token's with `expires_at` values that
match both are revoked.


Example entity:

    {
        "revoked": [{
            "id": "e87fe7",
            "valid_until": "2014-02-27T18:30:59.999999Z",
            "scope_id": "f287de",
            "scope_type": "user",
            "expires_at_or_before": "2013-02-27T18:30:59.999999Z",
            "expires_at_or_after": "2013-02-27T18:30:59.999999Z",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/e87fe7"
            }
        },
        {
            "id": "aa112c2",
            "valid_until": "2014-02-27T18:30:59.999999Z",
            "scope_id": "ed76512",
            "scope_type": "project",
            "issued_at_or_before": "2013-02-27T18:30:59.999999Z",
            "issued_at_or_after": "2013-02-27T18:30:59.999999Z",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/aa112c2"
            },
        }]
    }


API
---

#### List revocation events: `GET /OS_REVOKE/events`

Response:

    Status: 200 OK

    {
        "revoked": [{
            "id": "e87fe7",
            "valid_until": "2014-02-27T18:30:59.999999Z",
            "scope_id": "f287de",
            "scope_type": "user",
            "expires_at_or_before": "2013-02-27T18:30:59.999999Z",
            "expires_at_or_after": "2013-02-27T18:30:59.999999Z",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/e87fe7"
            }
        },
        {
            "id": "aa112c2",
            "valid_until": "2014-02-27T18:30:59.999999Z",
            "scope_id": "ed76512",
            "scope_type": "project",
            "issued_at_or_before": "2013-02-27T18:30:59.999999Z",
            "issued_at_or_after": "2013-02-27T18:30:59.999999Z",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/aa112c2"
            },
        }]
    }


#### Revoke all tokens for a domain: `POST /OS_REVOKE/domain/{domain}4bf3d9`



Request:
POST /OS_REVOKE/domain/4bf3d9

    {
        "issued_at_or_before": "2013-02-27T18:30:59.999999Z",
        "issued_at_or_after": "2013-02-27T18:30:59.999999Z",
    }

Response:

    Status: 201 Created

            {
            "id": "aa112c2",
            "valid_until": "2014-02-27T18:30:59.999999Z",
            "scope_id": "4bf3d9",
            "scope_type": "domain",
            "issued_at_or_before": "2013-02-27T18:30:59.999999Z",
            "issued_at_or_after": "2013-02-27T18:30:59.999999Z",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/aa112c2"
            },
        }

#### Revoke all tokens for a project: `POST /OS_REVOKE/project/`

Request:

    {
    }

Response:

    Status: 201 Created

            {
            "id": "aa112c2",
            "valid_until": "2014-02-27T18:30:59.999999Z",
            "scope_id": "ed76512",
            "scope_type": "project",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/aa112c2"
            },
        }


#### Revoke all tokens for a user: `POST /OS_REVOKE/user/fad127`

Request:

    {
        "expires_at_or_before": "2013-02-27T18:30:59.999999Z",
        "expires_at_or_after": "2013-02-27T18:30:59.999999Z",
    }

Response:

    Status: 201 Created

       {
            "id": "e87fe7",
            "valid_until": "2014-02-27T18:30:59.999999Z",
            "scope_id": "fad127",
            "scope_type": "user",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/e87fe7"
            }
        }
