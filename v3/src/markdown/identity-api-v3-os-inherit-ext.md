OpenStack Identity API v3 OS-INHERIT Extension
============================================

Enables projects to inherit roles from the parent domain. This extension requires Identity API v3.1.

API
---

This extension supports the following APIs:

Projects
--------

#### Define a role for a user in a project A that must be inherited by all its child projects;
`PUT /OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

The inherited role is applied to project A itself and all its child projects (both existing and
future projects).

Response:

    Status: 204 No Content

#### Define a role for a group of users in a project that must be inherited by all its child projects:
`PUT /OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

The inherited role is applied to project A itself and all its child projects (both existing and
future projects).

Response:

    Status: 204 No Content

#### List user's inherited roles on a project:
`GET /OS-INHERIT/projects/{project_id}/users/{user_id}/roles/inherited_to_projects`

Lists all inherited roles for a specified project and user. These roles are also inherited by any child projects of the specified project.

Response:

    Status: 200 OK

    {
        "roles": [
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:5000/v3/roles/--role-id--"
                },
                "name": "--role-name--",
            },
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:5000/v3/roles/--role-id--"
                },
                "name": "--role-name--"
            }
        ],
        "links": {
            "self": "http://identity:5000/v3/OS-INHERIT/projects/--project_id--/
                     users/--user_id--/roles/inherited_to_projects",
            "previous": null,
            "next": null
        }
    }

#### List group's inherited roles on a project:
`GET /OS-INHERIT/projects/{project_id)/groups/{group_id}/roles/inherited_to_projects`

Lists all inherited roles for a specified project and group. These roles are also inherited by any child projects of the specified project.

Response:

    Status: 200 OK

    {
        "roles": [
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:5000/v3/roles/--role-id--"
                },
                "name": "--role-name--",
            },
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:5000/v3/roles/--role-id--"
                },
                "name": "--role-name--"
            }
        ],
        "links": {
            "self": "http://identity:5000/v3/OS-INHERIT/projects/--project_id--/
                     groups/--group_id--/roles/inherited_to_projects",
            "previous": null,
            "next": null
        }
    }

### Check if a user has an inherited project role on a project;
`HEAD /OS-INHERIT/projects/{project_id)/users/{user_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

#### Check if a group has an inherited project role on a project;
`HEAD /OS-INHERIT/projects/{project_id)/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

#### Revoke an inherited project role from a user on a project;
`DELETE /OS-INHERIT/projects/{project_id)/users/{user_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

#### Revoke an inherited project role from group on a project;
`DELETE /OS-INHERIT/projects/{project_id)/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

Domains
-------

#### Assign role to user on projects owned by a domain:
`PUT /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

The inherited role is only applied to the owned projects (both existing and future
projects), and will not appear as a role in a domain scoped token.

Response:

    Status: 204 No Content

#### Assign role to group on projects owned by a domain:
`PUT /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

The inherited role is only applied to the owned projects (both existing and future
projects), and will not appear as a role in a domain scoped token.

Response:

    Status: 204 No Content

#### List user's inherited project roles on a domain:
`GET /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/inherited_to_projects`

The list only contains those role assignments to the domain that were specified
as being inherited to projects within that domain.

Response:

    Status: 200 OK

    {
        "roles": [
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:5000/v3/roles/--role-id--"
                },
                "name": "--role-name--",
            },
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:5000/v3/roles/--role-id--"
                },
                "name": "--role-name--"
            }
        ],
        "links": {
            "self": "http://identity:5000/v3/OS-INHERIT/domains/--domain_id--/
                     users/--user_id--/roles/inherited_to_projects",
            "previous": null,
            "next": null
        }
    }

#### List group's inherited project roles on domain:
`GET /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/inherited_to_projects`

The list only contains those role assignments to the domain that were specified
as being inherited to projects within that domain.

Response:

    Status: 200 OK

    {
        "roles": [
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:5000/v3/roles/--role-id--"
                },
                "name": "--role-name--",
            },
            {
                "id": "--role-id--",
                "links": {
                    "self": "http://identity:5000/v3/roles/--role-id--"
                },
                "name": "--role-name--"
            }
        ],
        "links": {
            "self": "http://identity:5000/v3/OS-INHERIT/domains/--domain_id--/
                     groups/--group_id--/roles/inherited_to_projects",
            "previous": null,
            "next": null
        }
    }

#### Check if user has an inherited project role on domain:
`HEAD /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

#### Check if group has an inherited project role on domain:
`HEAD /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

#### Revoke an inherited project role from user on domain:
`DELETE /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

#### Revoke an inherited project role from group on domain:
`DELETE /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

Response:

    Status: 204 No Content

Modified APIs
------------

This extension modifies the following APIs:

#### Create a new project: `POST - /projects`
Body:

    {
        "project": {
        "description": "test_project",
        "domain_id": "default",
        "parent_project_id": "$parent_project_id",
        "enabled": true,
        "name": "test_project"
        }
    }

#### Get a Token: `POST /auth/tokens`

Gets a token for a specified project and validates the project hierarchy:

Response:

    {
	"token": {
        "methods": [
            "password"
        ],
        "roles": [
            {
                "id": "c60f0d7461354749ae8ac8bace3e35c5",
                "name": "admin"
            }
        ],
        "expires_at": "2014-02-18T15:52:03.499433Z",
        "project": {
            "hierarchical_ids": "openstack.8a4ebcf44ebc47e0b98d3d5780c1f71a.
            "de2a7135b01344cd82a02117c005ce47",
            "hierarchy": "test1",
            "domain": {
                "id": "default",
                "name": "Default"
            },
            "id": "de2a7135b01344cd82a02117c005ce47",
            "name": "test1"
        },
        "extras": {},
        "user": {
            "domain": {
                "id": "default",
                "name": "Default"
            },
            "id": "895864161f1e4beaae42d9392ec105c8",
            "name": "admin"
        },
        "issued_at": "2014-02-18T14:52:03.499478Z"
    }
 }

#### Update a Project: `PATCH - /projects/{project_id}`

Body:

    {
        "project": {
            "description": "Project space for Build Group",
            "name": "Build Group"
        }
    }

Response:

    Status: 200 OK

#### Delete a project: `DELETE - /projects/{project_id}`

The first release of Hierarchical Multitenancy supports a non-recursive delete function that fails with an in-use or similar error if the project to be deleted has children.

Response:

    Status: 204 No Content


#### List effective role assignments: `GET /role_assignments`

The extended scope section in the response shows the role assignments that projects inherit.

Response:

    Status: 200 OK

    {
        "role_assignments": [
            {
                "links": {
                    "assignment": "http://identity:5000/v3/OS-INHERIT/
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
                    "OS-INHERIT:inherited_to": "projects"
                },
                "user": {
                    "id": "--user-id--"
                }
            },
            {
                "links": {
                    "assignment": "http://identity:5000/v3/OS-INHERIT/
                                   projects/--project-id--/users/--user-id--/
                                   roles/--role-id--/inherited_to_projects"
                },
                "role": {
                    "id": "--role-id--"
                },
                "scope": {
                    "project": {
                        "id": "--project-id--"
                    },
                    "OS-INHERIT:inherited_to": "projects"
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
                    "assignment": "http://identity:5000/v3/projects/--project-id--/
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
            "self": "http://identity:5000/v3/role_assignments",
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
                    "assignment": "http://identity:5000/v3/OS-INHERIT/
                                   domains/--domain-id--/users/--user-id--/
                                   roles/--role-id--/inherited_to_projects"
                },
                "role": {
                    "id": "--role-id--"
                },
                "scope": {
                    "OS-INHERIT:inherited_to": "projects",
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
                    "assignment": "http://identity:5000/v3/OS-INHERIT/
                                   projects/--project-id--/users/--user-id--/
                                   roles/--role-id--/inherited_to_projects"
                },
                "role": {
                    "id": "--role-id--"
                },
                "scope": {
                    "OS-INHERIT:inherited_to": "projects",
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
                    "assignment": "http://identity:5000/v3/projects/--project-id--/
                                   groups/--group-id--/roles/--role-id--",
                    "membership": "http://identity:5000/v3/groups/--group-id--/
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
            "self": "http://identity:5000/v3/role_assignments?effective",
            "previous": null,
            "next": null
        }
    }

