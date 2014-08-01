OpenStack Identity API v3 OS-INHERIT Extension
==============================================

Provide an ability for projects to inherit roles from their owning domain. This extension
requires v3.3 of the Identity API.

What's New in Version 1.1
-------------------------

These features are not yet considered stable (expected September 4th, 2014).

- Introduced a mechanism to inherit between projects, i.e. Multitenancy.

API
---

The following additional APIs are supported by this extension:

Projects
--------

#### A role defined for a project A must be inherited by all the child projects of project A;
`PUT /OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

The inherited role is applied to only the child projects (both existing and future
projects).

Response:

    Status: 204 No Content

#### A role defined for a group of users for a project must be inherited by all the users in children projects:
`PUT /OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

The inherited role is applied to only the owned projects (both existing and future
projects),

Response:

    Status: 204 No Content

#### List user's inherited roles on a project:
`GET /OS-INHERIT/projects/{project_id}/users/{user_id}/roles/inherited_to_projects`

Lists all roles inherited by a specified project. These roles are also inherited by any child projects of the specified project.

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

Lists all inherited roles for a specified group of projects. These roles are also inherited by any child projects of the projects in the specified group.

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
#### Get project parents: `GET - /projects/{project_id}?parents`

Response:

    {
        "project": {
            "description": "--optional--",
            "domain_id": "default",
            "enabled": true,
            "id": "380da69a2ca6466b95511160fbe721a0",
            "links": {
                "self": "http://10.1.0.22:5000/v3/projects/380da69a2ca6466b95511160fbe721a0"
            },
            "name": "child-project",
            "parent_project_id": "033f36fe53d04e2cb45cd03cae9ff955",
            "parents": [
                {
                    "project": {
                        "description": "--optional--",
                        "domain_id": "default",
                        "enabled": true,
                        "id": "033f36fe53d04e2cb45cd03cae9ff955",
                        "links": {
                            "self": "http://10.1.0.22:5000/v3/projects/033f36fe53d04e2cb45cd03cae9ff955"
                        },
                        "name": "parent-project",
                        "parent_project_id": null
                    }
                }
            ]
        }
    }

#### Get project subtree: `GET - /projects/{project_id}?subtree`

Response:

    {
        "project": {
            "description": "--optional--",
            "domain_id": "default",
            "enabled": true,
            "id": "380da69a2ca6466b95511160fbe721a0",
            "links": {
                "self": "http://10.1.0.22:5000/v3/projects/380da69a2ca6466b95511160fbe721a0"
            },
            "name": "child-project",
            "parent_project_id": "033f36fe53d04e2cb45cd03cae9ff955",
            "subtree": [
                {
                    "project": {
                        "description": "--optional--",
                        "domain_id": "default",
                        "enabled": true,
                        "id": "5e8997f2019c4f2a979a43077cc80de6",
                        "links": {
                            "self": "http://10.1.0.22:5000/v3/projects/5e8997f2019c4f2a979a43077cc80de6"
                        },
                        "name": "grandchild-project",
                        "parent_project_id": "380da69a2ca6466b95511160fbe721a0"
                    }
                }
            ]
        }
    }

#### Get full hierarchy: `GET - /projects/{project_id}?hierarchy`

Response:

    {
        "project": {
            "description": "--optional--",
            "domain_id": "default",
            "enabled": true,
            "hierarchy": [
                {
                    "project": {
                        "description": "--optional--",
                        "domain_id": "default",
                        "enabled": true,
                        "id": "033f36fe53d04e2cb45cd03cae9ff955",
                        "links": {
                            "self": "http://10.1.0.22:5000/v3/projects/033f36fe53d04e2cb45cd03cae9ff955"
                        },
                        "name": "parent-project",
                        "parent_project_id": null
                    }
                },
                {
                    "project": {
                        "description": "--optional--",
                        "domain_id": "default",
                        "enabled": true,
                        "id": "5e8997f2019c4f2a979a43077cc80de6",
                        "links": {
                            "self": "http://10.1.0.22:5000/v3/projects/5e8997f2019c4f2a979a43077cc80de6"
                        },
                        "name": "grandchild-project",
                        "parent_project_id": "380da69a2ca6466b95511160fbe721a0"
                    }
                }
            ],
            "id": "380da69a2ca6466b95511160fbe721a0",
            "links": {
                "self": "http://10.1.0.22:5000/v3/projects/380da69a2ca6466b95511160fbe721a0"
            },
            "name": "child-project",
            "parent_project_id": "033f36fe53d04e2cb45cd03cae9ff955"
    }
}


#### Delete a project: `DELETE - /projects/{project_id}`

The first release of Hierarchical Multutenancy will support a non-recursive delete function that fails with an in-use or similar error if the project to be deleted has children.

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
