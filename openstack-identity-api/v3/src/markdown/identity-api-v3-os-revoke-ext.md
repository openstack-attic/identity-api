OpenStack Identity API v3 OS-REVOKE Extension
=============================================

This extension provides a list of token revocation. Each event expresses a set
of criteria which describes a set of tokens that are no longer be valid.

This extension requires v3.2+ of the Identity API.

API Resources
-------------

### Revocation Events

Revocation events are objects that contain criteria used to evaluate token
validity. Tokens that match all the criteria of a revocation event are
considered revoked, and should not be accepted as proof of authorization for
the user.

Revocation events do not have a unique identifier (`id`).

Required attributes:

- `issued_before` (string, ISO 8601 extended format date time with
  microseconds)

  This is mutually exclusive with `expires_at`.

  Tokens issued before this time are considered revoked.

  It can be used to determine how long the expiration event is valid. It can
  also be used in queries to filter events, so that only a subset that have
  occurred since the last request are returned.

- `expires_at` (string, ISO 8601 extended format date time with microseconds)

  This is mutually exclusive with `issued_before`.

  Specifies the exact expiration time of one or more tokens to be revoked.

  This is useful for revoking chains of tokens, such as those produced when
  re-scoping an existing token. When a token is issued based on initial
  authentication, it is given an `expires_at` value. When a token is used to
  get another token, the new token will have the same `expires_at` value as the
  original.

Optional attributes:

- `domain_id` (string)

  Revoke tokens scoped to a particular domain.

- `project_id` (string)

  Revoke tokens scoped to a particular project.

- `user_id` (string)

  Revoke tokens expressing the identity of a particular user.

- `role_id` (string)

  Revoke tokens issued with a specific role.

- `OS-TRUST:trust_id` (string)

  Revoke tokens issued as the result of a particular trust, as part of the
  OS-TRUST API extension.

- `OS-OAUTH1:consumer_id` (string)

  Revoke tokens issued to a specific OAuth consumer, as part of the OS-OAUTH1
  API extension.

There properties are additive: Only a token that meets all of the specified
criteria is considered revoked.

Minimal example entity:

    {
        "issued_before": "2014-02-27T18:30:59.999999Z"
    }

API
---

#### List revocation events: `GET /OS-REVOKE/events`

Optional query parameters:

- `since` (RFC 1123 format date time): limit the list of results to events that
  occurred on or after the specified time.

The HTTP Date header returned in the response reflects the timestamp of the
most recently issued revocation event. Clients can then use this value in in
the `since` query parameter of to limit the list of events in subsequent
requests.

Response:

    Status: 200 OK
    Date: Sun, 17 Feb 2013 18:30:59 GMT

    {
        "events": [
            {
                "issued_before": "2013-02-27T18:30:59.999999Z",
                "user_id": "f287de"
            },
            {
                "expires_at": "2014-02-27T18:30:59.999999Z",
                "project_id": "976bf9"
            },
            {
                "domain_id": "be2c70",
                "issued_before": "2014-02-2805:15:59.999999Z",
                "user_id": "f287de"
            }
        ]
    }
