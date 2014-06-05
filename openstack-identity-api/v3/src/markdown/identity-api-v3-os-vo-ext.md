OpenStack Identity API v3 Virtual Organisation Management Extension
===================================================================

This extension provides API functions to facilitate the creation and management
of virtual organisations (VOs) within a federation. A VO is a group of
users from different organisations who collaborate together to share resources.
Different users who need to be granted the same access rights to a set of VO
resources are assigned the same VO role. 

This API allows administrators to manage (create, read, update and delete) PIN
protected VO roles and users to self register to and resign from these VO roles.

VO roles are mapped into OpenStack groups as follows:

1. If the VO is a domain, the group name is the VO role name
2. If there are multiple VOs in a domain, the group name is vo\_name.vo\_role

### VO roles: `/OS-FEDERATION/vo_roles`
### VO role membership: `/OS-FEDERATION/vo_roles/member`

Admin API on VO roles
---------------------

### Create a VO role: `PUT /OS-FEDERATION/vo_roles`

Required Attributes:

- `vo_name` (string)

  The name of the virtual organisation.
  
- 'vo_role' (string)

  The name of the VO role.

- `pin` (string)

  The PIN or password to be used by users to register for this VO role.

Optional attributes:

- `description` (string)

  Describes the virtual organisation. If a value is not specified by the client,
  the service will default this value to`null`.

- `enabled` (boolean)

  Indicates whether this VO role is active or not. If a value is
  not specified by the client, the service will default this to `false`.

- `vo_is_domain` (boolean)

  Indicates whether this VO is its own domain or not. If a value is not
  specified, the service will default this to 'false'.

- `automatic_join`(boolean)

  Indicates if an administrator must enable user accounts after registration. If
  a value is not specified by the client, the service will default this to
  `false`.


Request:

    {
        "vo_role": {
            "automatic_join": false,
            "description": "A Virtual Organisation Role",
            "enabled": true,
            "pin": "1234",
            "vo_name": "myVo",
            "vo_role": "member"
        }
    }

Response:

    Status: 201 Created

    {
        "vo_role": {
            "automatic_join": false,
            "description": "A Virtual Organisation Role",
            "enabled": true,
            "group_id": "22ef8a",
            "id": "6e78fa",
            "links": {
                "self": "http://identity:35357/v3/OS-FEDERATION/v_o_roles/6e78fa"
            },
            "pin": 1234,
            "vo_name": "myVO",
            "vo_role": "member"
        }
    }

### List VO roles: `GET /OS-FEDERATION/vo_roles`

  A user with an admin role should be able to see all VO roles whereas other
  users should only see VO roles in which they have membership.

Response:

    Status: 200 OK

    {
        "vo_roles": [
            "vo_role": {
                "automatic_join": false,
                "description": "A Virtual Organisation Role",
                "enabled": true,
                "group_id": "22ef8a",
                "id": "6e78fa",
                "links": {
                    "self": "http://identity:35357/v3/OS-FEDERATION/vo_roles/6e78fa"
                },
                "pin": 1234,
                "vo_is_domain": false,
                "vo_name": "myVO",
                "vo_role": "member" 
            }
             "vo_role": {
                "automatic_join": false,
                "description": "Another Virtual Organisation Role",
                "enabled": true,
                "group_id": "4aef7e",
                "id": "b345a2",
                "links": {
                    "self": "http://identity:35357/v3/OS-FEDERATION/vo_roles/b345a2"
                },
                "pin": 9999
                "vo_is_domain": false,
                "vo_name": "myOtherVO",
                "vo_role": "member" 
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-FEDERATION/vo_roles"
        }
    }

### Get a VO role: `GET /OS-FEDERATION/v_o_roles/{vo_role_id}`

Response:

    Status: 200 OK

    {
        "vo_role": {
            "automatic_join": false,
            "description": "Another Virtual Organisation Role",
            "enabled": true,
            "group_id": "4aef7e",
            "id": "b345a2",
            "links": {
                "self": "http://identity:35357/v3/OS-FEDERATION/vo_roles/b345a2"
            },
            "pin": 9999
            "vo_is_domain": false,
            "vo_name": "myOtherVO",
            "vo_role": "member" 
        }
    }

### Delete VO role: `DELETE /OS-FEDERATION/vo_roles/{vo_role_id}`


Response:

    Status: 204 No Content

### Update VO role: `PATCH /OS-FEDERATION/vo_roles/{vo_role_id}`

Any of the following parameters can be updated: automatic_join, description,
enabled, pin, vo_is_domain, vo_name, vo_role. They take effect immediately. 
Updating the last three parameters will cause a new VO role to be created, the
members to be copied across, then the original VO role to be deleted.

Request:

    {
        "vo_role": {
            "enabled": false
        }
    }

Response:

    Status: 200 OK

    {
        "vo_role": {
                "automatic_join": false,
                "description": "A Virtual Organisation",
                "enabled": false,
                "group_id": "22ef8a",
                "id": "6e78fa",
                "links": {
                    "self": "http://identity:35357/v3/OS-FEDERATION/vo_roles/6e78fa"
                },
            "pin": 1234,
            "vo_is_domain": false,
            "vo_name": "myVO",
            "vo_role": "member"
        }
    }

Admin API on VO role membership
-------------------------------


### Add VO role member: `PUT /OS-FEDERATION/vo_roles/{vo_role-id}/members/{user-id}`

Note. This is equivalent to adding an attribute mapping but is a very restricted
subset of the attribute mapping capability

Response:

    Status: 200 OK

    {
        {
            "id": "34cb2d",
            "user_id": "abc@idp",
            "idp": 64ef2a"
        }
    }

### Get member with vo_role: `GET /OS-FEDERATION/vo_roles/{vo_role_id}/members/{user_id}`

Response:

    Status: 200 OK

    {
        {
            "id": "34cb2d",
            "user_id": "abc@idp",
            "idp": 64ef2a"
        }
    }

### List members with a VO role: `GET /OS-FEDERATION/vo_roles/{vo_role_id}/members`

A user with an admin role should be able to list the members of any VO role.
Other users should only be granted access to member lists of VO roles they are
members of, attempts to list the members of any other VO role should return HTTP
status 403 Forbidden.

Response:

    {
        "vo_members": [
            {
                "id": "34cb2d",
                "user_id": "abc@idp",
                "idp": 64ef2a"
            },
            {
                "id": "bf21a9",
                "user_id": "xyz@idp",
                "idp": 64ef2a"
            }
        ]
    }

### Remove VO role from user: `DELETE /OS-FEDERATION/vo_roles/{vo_role_id}/member/{user-id}`

Response:

    Status: 204 No Content

### Switch VO roles for a user: `PATCH /OS-FEDERATION/vo_roles/{vo_role_id}/member/{user-id}`

The new VO role must already exist as it cannot be created by this operation.

Request:

    {
        "new_vo_role_id: "125adf"
    }


### List VO role membership user requests: `GET /OS-FEDERATION/vo_roles/requests`

Response:

    Status: 200 OK

    {
        "vo_requests": [
            {
                "id": "85efa3",
                "idp": "231eeb",
                "vo_name": "myVO",
                "vo_role": "member",
                "user_id": "abc@idp"
            },
            {
                "id": "99fab5",
                "idp": "231eeb",
                "vo_name": "myVO",
                "vo_role": "admin",
                "user_id": "efg@idp"
            }
        ]
    }

### Approve VO role membership user request: `HEAD /OS-FEDERATION/vo_roles/requests/{vo_request_id}`

Response: 

Status: 200 OK

### Delete VO role membership request: `DELETE /OS-FEDERATION/vo_roles/requests/{vo_request_id}`

Response: 

Status: 204 No Content

Users can become blacklisted if they make too many wrong attempts at joining a
VO this will mean that all further attempts to join a VO will fail and an
administrator must remove the user from the blacklist for that user to be able
to join a VO.

### List blacklisted users for VO role: `GET /OS-FEDERATION/vo_roles/{vo_role_id}/blacklist`

Response:

    {
        "vo_blacklist": [
            {
                "id": "34cb2d",
                "user_id": "badman@idp",
                "idp": "64ef2a",
                "vo_role: "66bb3e" 
            },
            {
                "id": "bf21a9",
                "user_id": "foo@idp",
                "idp": 64ef2a",
                "vo_role: "66bb3e" 
            }
        ]
    }

### List blacklisted users for all VO roles: `GET /OS-FEDERATION/vo_blacklist`

Response:

    {
        "vo_blacklist": [
            {
                "id": "34cb2d",
                "user_id": "badman@idp",
                "idp": 64ef2a",
                "vo_role: "66bb3e" 
            },
            {
                "id": "5a3c88",
                "user_id": "foo@idp",
                "idp": 64ef2a",
                "vo_role: "7feab4" 
            }
        ]
    }
    
### Delete blacklist entry: `DELETE /OS-FEDERATION/vo_roles/{vo_role_id}/blacklist/{vo_blacklist_id}`

Response:

    Status: 204 No Content


User API
---------

Users may join a VO role by providing the name of the VO, VO role and
the PIN. The response should contain the name of the VO and a status
message which can be:

    1. success - the user successfully registered as a VO member and can begin
    accessing the appropriate resources immediately.
    2. pending - the user has registered for VO membership but his request must
    be approved by an administrator before he can access any resources.
    3. an error message if the join request has failed.

### Join VO Role: `PUT /OS-FEDERATION/vo_roles/members`

Request:

    {
        "vo_request" : {
            "pin": "1234",
            "vo_name": "myVO",
            "vo_role": "member"
        }
    }

Response:

    Status: 201 Created

    {
        "vo_role": {
            "id": "85efa3",
            "status": "pending",
            "vo_name": "myVO",
            "vo_role": "member"
        }
    }


Users may check the status of a join request to a specific virtual organisation.
The HTTP code should determine the status:
    1. 200 indicates that the user belongs to the VO
    2. 202 indicates that the user has made a request which has not yet been
    approved.
    3. 404 indicates that the user has not requested membership, or that the
    request they made has been denied.

### Check Virtual Organisation Membership: `HEAD /OS-FEDERATION/vo_roles/{vo_name}`

Response:

    Status: 200 OK

Users may resign from a VO role

### Resign from a VO Role: `DELETE /OS-FEDERATION/vo_roles/members`

Request:

    {
        "vo_resign" : {
           "pin": "1234",
           "vo_name": "myVO",
           "vo_role": "member"
        }
    }

Response: 

Status: 204 No Content
