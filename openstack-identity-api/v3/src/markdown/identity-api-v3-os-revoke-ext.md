OpenStack Identity API v3 OS-REVOKE Extension
============================================

The OS-REVOKE extension provides lists of revocation events.  Each event expresses a set of criteria for indicating that a set of tokens are no longer valid.

API Resources
-------------

### Trusts

Tokens can be revoked.

Additional required attributes:

- `scope_id` (string)

  Represents .

- `scope_type` (string)

  Represents .


- `valid_until` (string, ISO 8601 extended format date time with microseconds)

  Represents how long the expiration event is valid.


Optional attributes:

- `issued_at_or_before` (string, ISO 8601 extended format date time with microseconds)
  Specifies a rule to compare the issue time of the token.   


- `issued_at_or_after` (string, ISO 8601 extended format date time with microseconds)

  Specifies a rule to compare the issue time of the token.  

  The values `issued_at_or_before` and `issued_at_or_after` are expected to work in conjunction.  If both values are specified, and the token's issued time matches both rules, then the token is considered revoked.  It is legal to specify either only `issued_at_or_before` or only `issued_at_or_after`.  However, not specifying `issued_at_or_before` effectively locks the account.


- `expires_at_or_before`: (string, ISO 8601 extended format date time with microseconds)

  Specifies a rule to compare the expiration time of the token. 

- `expires_at_or_after` (string, ISO 8601 extended format date time with microseconds)

  Specifies a rule to compare the expiration time of the token. 
  
  The values `expires_at_or_before` and `expires_at_or_after` are expected to work in conjunction.  If both values are specified, and the token's `expires` time matches both rules, then the token is considered revoked.  It is legal to specify either only `expires_at_or_before` or only `expires_at_or_after`.  However, not specifying `expires_at_or_before` effectively locks the account.
  

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


#### Revoke all tokens for a domain: `POST /OS_REVOKE/domain/4bf3d9`

Request:

    {
        "issued_at_or_before": "2013-02-27T18:30:59.999999Z",
        "issued_at_or_after": "2013-02-27T18:30:59.999999Z",
    }

Response:

    Status: 201 Created

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
            "issued_at_or_before": "2013-02-27T18:30:59.999999Z",
            "issued_at_or_after": "2013-02-27T18:30:59.999999Z",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/aa112c2"
            },
        }


#### Revoke all tokens for a user: `POST /OS_REVOKE/`

Request:

    {
    }

Response:

    Status: 201 Created

       {
            "id": "e87fe7",
            "valid_until": "2014-02-27T18:30:59.999999Z",
            "scope_id": "f287de",
            "scope_type": "user",
            "expires_at_or_before": "2013-02-27T18:30:59.999999Z",
            "expires_at_or_after": "2013-02-27T18:30:59.999999Z",
            "links": {
                "self": "http://identity:35357/v3/OS-REVOKE/events/e87fe7"
            }           
        }
