OpenStack Identity API v3 OS-REVOKE Extension
============================================

The OS-REVOKE extension provides lists of revocation events.  Each event
expresses a set of criteria for indicating that a set of tokens are no longer
valid.

This extension requires v3.2+ of the Identity API.

API Resources
-------------

### Revocation Events

Revocation events are objects that contain criteria used to evaluate token
validity.  Tokens that match the criteria of a revocation event are considered
revoked, and should not be accepted as proof of authorization for the user.

Required attributes:

Revocation events explicitly do not require a unique identifier.

- `revoked_at` (string, ISO 8601 extended format date time with microseconds)

  Represents when the revocation event occured. It can be used to determine how
  long the expiration event is valid.  It can also be used in queries to filter
  events, so that only a subset that have occured since the last request are
  returned.


Optional attributes:


- `endpoint_id` (string)
- `domain_id` (string)
- `project_id` (string)
- `user_id` (string)
- `trust_id` (string)
- `oauth_consumer_id` (string)

  Identifiers for the entity covered by the revocation event.
  At least one of the above values must be present.  If multiple of the above
  attributes are specified, a token is revoked only if all values in  the token
  match.

- `expires_at`:
    (string, ISO 8601 extended format date time with microseconds)
    tokens with expires_at values that match this time are considered revoked.

- `issued_before`:
    (string, ISO 8601 extended format date time with microseconds)
    tokens issued before this time are considered revoked.

There properties are additive: Only a token that meets all of the criteria
specified is considered revoked.


Example entity:

    {
        "revoked": [{
            "id": "e87fe7",
            "revoked_at": "2014-02-27T18:30:59.999999Z",
            "user_id": "f287de",
            "expires_at_or_before": "2013-02-27T18:30:59.999999Z",
            "expires_at_or_after": "2013-02-27T18:30:59.999999Z",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/e87fe7"
            }
        },
        {
            "id": "aa112c2",
            "revoked_at": "2014-02-27T18:30:59.999999Z",
            "project_id": "ed76512",
            "issued_before": "2014-02-2805:15:59.999999Z",
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
            "revoked_at": "2014-02-27T18:30:59.999999Z",
            "user_id": "f287de",
            "expires_at": "2014-02-27T18:30:59.999999Z",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/e87fe7"
            }
        },
        {
            "id": "aa112c2",
            "revoked_at": "2014-02-27T19:55:12.111112Z",
            "project_id": "ed76512",
            "expires_at": "2014-02-27T18:30:59.999999Z",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/aa112c2"
            },
        }]
    }

Events will be ordered from most recently revoked to oldest.

To request all events that have occurred on or after a specified time, use the
filter `revoked_since` with date values in ISO 8601 format that has been URL
encoded.

GET /OS_REVOKE/events?revoked_since=2014-02-27T18%3A30%3A59.999999Z
