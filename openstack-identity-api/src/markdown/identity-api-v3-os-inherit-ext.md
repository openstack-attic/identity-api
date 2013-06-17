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

The following APIs are modified by this extension. The modifications are indicated by the
OS-INHERIT label.

#### List effective role assignments: `GET /role-assignments`

query_filter: group.id, role.id, scope.OS-INHERIT:inherited_to, scope.domain.id,
              scope.project.id, user.id (all optional)
query_string: effective (optional, default false)
query_string: page (optional)
query_string: per_page (optional, default 30)

Get a list of role assignments. This API is only available from v3.1 onwards.

If no query filters are specified, then this API will return a list of all role assignments.

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

Since this list is likely to be very long, this API would typically always be used with
one of more of the filter queries. Some typical examples are:

`GET /role-assignments?user.id={user_id}` would list all role assignments involving the
specified user.

`GET /role-assignments?scope.project.id={project_id}` would list all role assignments
involving the specified project.

Each role assignment entity in the collection contains a link to the assignment that gave
rise to this entity.

If the query_string `effective` is specified then, rather than simply returning a list of
role assignments that have been made, the API returns a list of effective assignments at
the user, project and domain level, having allowed for the effects of group membership
as well as inheritance from the parent domain (for role assignments that were made using
OS-INHERIT assignment APIs). Since the effects of group membership and inheritance have
already been allowed for, the group and inheritance role assignment entities themselves
will not be returned in the collection. This represents the effective role assignments
that would be included in a scoped token. The same set of query filters can also be used
with the `effective` query string. For example:

`GET /role-assignments?user.id={user_id}&effective` would, in other words, answer the
question "what can this user actually do?".

`GET /role-assignments?user.id={user_id}&scope.project.id={project_id}&effective` would
return the equivilent set of role assignments that would be included in the token response
of a project scoped token.

An example response for an API call with the query_string `effective` specified is
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
                    "domain": {
                        "id": "--domain-id--"
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

The entity `links` section of a response using the `effective` query string also contains,
for entities that are included by virtue of group memebership, a url that can be used to access the membership of the group.

