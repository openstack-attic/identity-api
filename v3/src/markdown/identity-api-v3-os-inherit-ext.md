OpenStack Identity API v3 OS-INHERIT Extension
============================================

Provide an ability for projects to inherit roles from their owning domain. This extension
requires v3.1 of the Identity API.

API
---

The following additional APIs are supported by this extension:

Projects
---

#### A role defined for a project A must be inherited by all the child projects of project A;
`PUT /OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`

The inherited role is only applied to the child projects (both existing and future
projects).

Response:

    Status: 204 No Content
    
#### A role defined for a group of projects must be inherited by all the child projects of that group of projects;
`PUT /OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`

The inherited role is only applied to the owned projects (both existing and future
projects),

Response:

    Status: 204 No Content
    
#### List user's inherited roles on a project:
`GET /OS-INHERIT/projects/{project_id}/users/{user_id}/roles/inherited_to_projects`

For a project A, list all the inherited roles of A, which will also be inherited by the child projects of project A;

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

For a group of projects ABC, list all the inherited roles of ABC, which will also be inherited by the child projects of the group of projects ABC;

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
---

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

The following APIs are modified by this extension.

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

Get a token for "test_project" and check that the hierarchy is there like the following

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
            "hierarchical_ids":  "openstack.8a4ebcf44ebc47e0b98d3d5780c1f71a.de2a7135b01344cd82a02117c005ce47",
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

#### Delete a Project: `DELETE - /projects/{project_id}`

The first version will support a non-recursive delete function which will fail with "in use" or similar if the project to be deleted has children.

Response:

    Status: 204 No Content


#### List effective role assignments: `GET /role_assignments`

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

