OpenStack Identity API v3 OS-INHERIT Extension
==============================================

Provide an ability for projects to inherit roles from their owning
domain. This extension requires v3.1 of the Identity API.

API
---

The following additional APIs are supported by this extension:

Assign role to user on projects owned by a domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    PUT /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-INHERIT/1.0/rel/domain_user_role_inherited_to_projects``

The inherited role is only applied to the owned projects (both existing
and future projects), and will not appear as a role in a domain scoped
token.

Response:

::

    Status: 204 No Content

Assign role to group on projects owned by a domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    PUT /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects

Relationship:
``http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_group_role_inherited_to_projects``

The inherited role is only applied to the owned projects (both existing
and future projects), and will not appear as a role in a domain scoped
token.

Response:

::

    Status: 204 No Content

List user's inherited project roles on a domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/inherited_to_projects

Relationship:
``http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_user_roles_inherited_to_projects``

The list only contains those role assignments to the domain that were
specified as being inherited to projects within that domain.

Response:

::

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

List group's inherited project roles on domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/inherited_to_projects

Relationship:
``'http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_group_roles_inherited_to_projects``

The list only contains those role assignments to the domain that were
specified as being inherited to projects within that domain.

Response:

::

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

Check if user has an inherited project role on domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    HEAD /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-INHERIT/1.0/rel/domain_user_role_inherited_to_projects``

Response:

::

    Status: 204 No Content

Check if group has an inherited project role on domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    HEAD /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects

Relationship:
``http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_group_role_inherited_to_projects``

Response:

::

    Status: 204 No Content

Revoke an inherited project role from user on domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    DELETE /OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-INHERIT/1.0/rel/domain_user_role_inherited_to_projects``

Response:

::

    Status: 204 No Content

Revoke an inherited project role from group on domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    DELETE /OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects

Relationship:
``http://docs.openstack.org/identity/rel/v3/ext/OS-INHERIT/1.0/domain_group_role_inherited_to_projects``

Response:

::

    Status: 204 No Content

Modified APIs
-------------

The following APIs are modified by this extension.

List effective role assignments
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /role_assignments

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/rel/role_assignments``

The scope section in the list response is extended to allow the
representation of role assignments that are inherited to projects.

Response:

::

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

An additional query filter ``scope.OS-INHERIT:inherited_to`` is
supported to allow for filtering based on role assignments that are
inherited. The only value of ``scope.OS-INHERIT:inherited_to`` that is
currently supported is ``projects``, indicating that this role is
inherited to all projects of the owning domain.

If the query\_string ``effective`` is specified then the list of
effective assignments at the user, project and domain level allows for
the effects of both group membership as well as inheritance from the
parent domain (for role assignments that were made using OS-INHERIT
assignment APIs). Since, like group membership, the effects of
inheritance have already been allowed for, the role assignment entities
themselves that specify the inheritance will not be returned in the
collection.

An example response for an API call with the query\_string ``effective``
specified is given below:

Response:

::

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

