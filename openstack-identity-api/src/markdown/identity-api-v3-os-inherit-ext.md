OpenStack Identity API v3 OS-INHERIT Extension
============================================

Provide an ability for projects to inerit roles from their owning domain. This extension requires v3.1 of the Identity API.

API
---

The following additional APIs are supported by this extension:

#### Grant role to user on projects owned by a domain:
`PUT /domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

The inherited role is only applied to the owned projects (both existing and future
projects), and will not appear as a role in a domain scoped token.

Response:

    Status: 204 No Content

#### Grant role to group on projects owned by a domain:
`PUT /domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`


The inherited role is only applied to the owned projects (both existing and future
projects), and will not appear as a role in a domain scoped token.

Response:

    Status: 204 No Content

#### List user's inherited project roles on a domain:
`GET /domains/{domain_id}/users/{user_id}/roles/inherited_to_projects`

The list only contains those role assignments to the domain that were specified
as being inherited to projects within that domain.

Response:

    Status: 200 OK

    {
        "roles": [
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:35357/v3/roles/--role-id--"
                },
                "name": "--role-name--",
            },
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:35357/v3/roles/--role-id--"
                },
                "name": "--role-name--"
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/domains/--domain_id--/
                     users/--user_id--/roles/inherited_to_projects,
            "previous": null,
            "next": null
        }
    }

#### List group's inherited project roles on domain:
`GET /domains/{domain_id}/groups/{group_id}/roles/inherited_to_projects`

The list only contains those role assignments to the domain that were specified
as being inherited to projects within that domain.

Response:

    Status: 200 OK

    {
        "roles": [
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:35357/v3/roles/--role-id--"
                },
                "name": "--role-name--",
            },
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:35357/v3/roles/--role-id--"
                },
                "name": "--role-name--"
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/domains/--domain_id--/
                     groups/--group_id--/roles/inherited_to_projects,
            "previous": null,
            "next": null
        }
    }

#### Check if user has an inherited project role on domain:
`HEAD /domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

#### Check if group has an inherited project role on domain:
`HEAD /domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

#### Revoke an inherited project role from user on domain:
`DELETE /domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

#### Revoke an inherited project role from group on domain:
`DELETE /domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

The following APIs are modified by this extension:

#### List role assignments: `GET /role-assignments`

query_filter: group.id, role.id, OS-INHERIT:inherited_to, scope.domain.id, scope.project.id,
              user.id (optional)
query_string: effective (optional)
query_string: page (optional)
query_string: per_page (optional, default 30)

Get a list of role assignments. This API is only available from v3.1 onwards.

If the query_string `effective` is specified then the API returns a list assignments at the
user level, including those that are directly assigned as well as those by virtue of group
membership or inherited from the owning domain. Such a list will not include the group
assigment entities themselves. If the query_string `effective` is not specified then the
API returns a list of the actual assignments made.

This API would typically always be used with one of more of the filter queries; for example
using the `user.id` filter would return a response listing which roles a given user has on
which entities.  Using `scope.project.id` or `scope.domain.id` returns a response showing
which users have roles on that entity, and which roles they are. Combining query filters
allow very specific queries to be carried out, for instance the following API call would
return the equivilent set of role assignments that would be included in the token response
of a project scoped token:

GET /role-assignments?user.id={user_id}&scope.project.id={project_id}&effective

Each role assignment entity in the collection contains a link to the assignment that gave
rise to this entity.  If the query_string `effective` is specified and the effective role
was by virtue of group membership, then a membership link is also included given the
url that can be used to access the membership involved.

An example response for an API call without the query_string `effective` specified is given
below:

Response:

    Status: 200 OK

    {
        "role-assignments": [
            {
                "links": {
                    "assignment": "http://identity:35357/v3/OS-INHERIT/
                                   domains/--domain-id--/users/--user-id--/
                                   roles/--role-id--/inherited_to_projects"
                },
                "role": {
                    "id": "--role-id--"
                },
                "scope": {
                    "domain": {
                        "id": "--domain-id--"
                    },
                    "OS-INHERIT:inherited_to": {"projects"}
                },
                "user": {
                    "id": "--user-id--"
                }
            },
            {
                "group": {
                    "id": "--group-id--"
                },
                "links": {
                    "assignment": "http://identity:35357/v3/projects/--project-id--/
                                   groups/--group-id--/roles/--role-id--"
                },
                "role": {
                    "id": "--role-id--"
                },
                "scope": {
                    "project": {
                        "id": "--project-id--"
                    }
                }
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/role-assignments",
            "previous": null,
            "next": null
        }
    }

An example response for the same API call with the query_string `effective` specified is
given below:

Response:

    Status: 200 OK

    {
        "role-assignments": [
            {
                "links": {
                    "assignment": "http://identity:35357/v3/OS-INHERIT/
                                   domains/--domain-id--/users/--user-id--/
                                   roles/--role-id--/inherited_to_projects"
                },
                "role": {
                    "id": "--role-id--"
                },
                "scope": {
                    "project": {
                        "id": "--project-id--"
                    }
                },
                "user": {
                    "id": "--user-id--"
                }
            },
            {
                "links": {
                    "assignment": "http://identity:35357/v3/projects/--project-id--/
                                   groups/--group-id--/roles/--role-id--",
                    "membership": "http://identity:35357/v3/groups/--group-id--/
                                   users/--user-id--"
                },
                "role": {
                    "id": "--role-id--"
                },
                "scope": {
                    "project": {
                        "id": "--project-id--"
                    }
                },
                "user": {
                    "id": "--user-id--"
                }
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/role-assignments",
            "previous": null,
            "next": null
        }
    }

