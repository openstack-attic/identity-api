OpenStack Identity API v3 OS-INHERIT Extension
==============================================

Provide an ability for projects to inherit roles from their owning domain and to children projects. This extension requires v3.3 of the Identity API.

What's New in Version 1.1
-------------------------

- Introduces a mechanism to inherit between projects, i.e. Multitenancy.

API
---

This extension supports these additional APIs:

Projects
--------

#### Add a role to a user for a project;
`PUT /OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/api/openstack-identity/3/ext/OS-INHERIT/1.0/rel/project_user_role_inherited_to_projects`

The inherited role is applied to the project and the children projects (both existing and future
projects).

Response:

    Status: 204 No Content

#### Add a role to a group for a project:
`PUT /OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/project_group_role_inherited_to_projects`

The inherited role is applied to the project and the children projects (both existing and future
projects),

Response:

    Status: 204 No Content

#### List user's inherited roles on a project:
`GET /OS-INHERIT/projects/{project_id}/users/{user_id}/roles/inherited_to_projects`

Relationship: `http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/project_user_roles_inherited_to_projects`

Lists all roles inherited by a specified project. These roles are also
inherited by any child projects of the specified project.

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
            "self": "http://identity:35357/v3/OS-INHERIT/projects/--project_id--/
                     users/--user_id--/roles/inherited_to_projects",
            "previous": null,
            "next": null
        }
    }

#### List group's inherited roles on a project:
`GET /OS-INHERIT/projects/{project_id)/groups/{group_id}/roles/inherited_to_projects`

Lists all inherited roles for a specified group of projects. These roles are
also inherited by any child projects of the projects in the specified group.

Relationship: `http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_group_roles_inherited_to_projects`

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
            "self": "http://identity:35357/v3/OS-INHERIT/projects/--project_id--/
                     groups/--group_id--/roles/inherited_to_projects",
            "previous": null,
            "next": null
        }
    }

### Check if a user has an inherited project role on a project;
`HEAD /OS-INHERIT/projects/{project_id)/users/{user_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/api/openstack-identity/3/ext/OS-INHERIT/1.0/rel/project_user_role_inherited_to_projects`

Response:

    Status: 204 No Content

#### Check if a group has an inherited project role on a project;
`HEAD /OS-INHERIT/projects/{project_id)/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/project_group_role_inherited_to_projects`

Response:

    Status: 204 No Content

#### Revoke an inherited project role from a user on a project;
`DELETE /OS-INHERIT/projects/{project_id)/users/{user_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/api/openstack-identity/3/ext/OS-INHERIT/1.0/rel/domain_user_role_inherited_to_projects`

Response:

    Status: 204 No Content

#### Revoke an inherited project role from group on a project;
`DELETE /OS-INHERIT/projects/{project_id)/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_group_role_inherited_to_projects`

Response:

    Status: 204 No Content

Domains
-------

#### Assign role to user on projects owned by a domain:
`PUT /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/api/openstack-identity/3/ext/OS-INHERIT/1.0/rel/domain_user_role_inherited_to_projects`

The inherited role is only applied to the owned projects (both existing and future
projects), and will not appear as a role in a domain scoped token.

Response:

    Status: 204 No Content

#### Assign role to group on projects owned by a domain:
`PUT /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_group_role_inherited_to_projects`

The inherited role is only applied to the owned projects (both existing and future
projects), and does not appear as a role in a domain-scoped token.

Response:

    Status: 204 No Content

#### List user's inherited project roles on a domain:
`GET /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/inherited_to_projects`

Relationship: `http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_user_roles_inherited_to_projects`

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
            "self": "http://identity:35357/v3/OS-INHERIT/domains/--domain_id--/
                     users/--user_id--/roles/inherited_to_projects",
            "previous": null,
            "next": null
        }
    }

#### List group's inherited project roles on domain:
`GET /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/inherited_to_projects`

Relationship: `'http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_group_roles_inherited_to_projects`

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
            "self": "http://identity:35357/v3/OS-INHERIT/domains/--domain_id--/
                     groups/--group_id--/roles/inherited_to_projects",
            "previous": null,
            "next": null
        }
    }

#### Check if user has an inherited project role on domain:
`HEAD /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/api/openstack-identity/3/ext/OS-INHERIT/1.0/rel/domain_user_role_inherited_to_projects`

Response:

    Status: 204 No Content

#### Check if group has an inherited project role on domain:
`HEAD /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_group_role_inherited_to_projects`

Response:

    Status: 204 No Content

#### Revoke an inherited project role from user on domain:
`DELETE /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/api/openstack-identity/3/ext/OS-INHERIT/1.0/rel/domain_user_role_inherited_to_projects`

Response:

    Status: 204 No Content

#### Revoke an inherited project role from group on domain:
`DELETE /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Relationship: `http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_group_role_inherited_to_projects`

Response:

    Status: 204 No Content

Modified APIs
------------

This extension modifies these APIs:

#### List effective role assignments: `GET /role_assignments`

Relationship: `http://docs.openstack.org/api/openstack-identity/3/rel/role_assignments`

The scope section in the list response is extended to allow the representation of role
assignments that are inherited to projects.

Response:

    Status: 200 OK

    {
        "role_assignments": [
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
                    "OS-INHERIT:inherited_to": ["projects"]
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
            "self": "http://identity:35357/v3/role_assignments",
            "previous": null,
            "next": null
        }
    }

An additional query filter `scope.OS-INHERIT:inherited_to` is supported to allow
for filtering based on role assignments that are inherited. The only value of
`scope.OS-INHERIT:inherited_to` that is currently supported is `projects`, indicating
that this role is inherited to all projects of the owning domain.

If the query_string `effective` is specified then the list of effective assignments at
the user, project and domain level allows for the effects of both group membership
as well as inheritance from the parent domain (for role assignments that were made using
OS-INHERIT assignment APIs). Since, like group membership, the effects of inheritance
have already been allowed for, the role assignment entities themselves that specify
the inheritance will not be returned in the collection.

An example response for an API call with the query_string `effective` specified is
given below:

Response:

    Status: 200 OK

    {
        "role_assignments": [
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
            "self": "http://identity:35357/v3/role_assignments?effective",
            "previous": null,
            "next": null
        }
    }
