OpenStack Identity API v3 OS-FEDERATION Extension
=================================================

Provide the ability for users to manage Identity Providers (IdPs) and
establish a set of rules to map federation protocol attributes to
Identity API attributes. This extension requires v3.0+ of the Identity
API.

What's New in Version 1.1
-------------------------

These features are considered stable as of September 4th, 2014.

-  Introduced a mechanism to exchange an Identity Token for a SAML
   assertion.
-  Introduced a mechanism to retrieve Identity Provider Metadata.

Definitions
-----------

-  *Trusted Identity Provider*: An identity provider set up within the
   Identity API that is trusted to provide authenticated user
   information.
-  *Service Provider*: A system entity that provides services to
   principals or other system entities, in this case, the OpenStack
   Identity API is the Service Provider.
-  *Attribute Mapping*: The user information passed by a federation
   protocol for an already authenticated identity are called
   ``attributes``. Those ``attributes`` may not align 1:1 with the
   Identity API concepts. To help overcome such mismatches, a mapping
   can be done either on the sending side (third party identity
   provider), on the consuming side (Identity API service), or both.

What's New in Version 1.1
-------------------------

Corresponding to Identity API v3.3 release. These features are
considered stable as of September 4th, 2014.

-  Deprecate list projects and domains in favour of core functionality
   available in Identity API v3.3.

API Resources
-------------

Identity Providers
~~~~~~~~~~~~~~~~~~

::

    /OS-FEDERATION/identity_providers

An Identity Provider is a third party service that is trusted by the
Identity API to authenticate identities.

Optional attributes:

-  ``description`` (string)

Describes the identity provider.

If a value is not specified by the client, the service may default this
value to either an empty string or ``null``.

-  ``enabled`` (boolean)

Indicates whether this identity provider should accept federated
authentication requests.

If a value is not specified by the client, the service may default this
to either ``true`` or ``false``.

Protocols
~~~~~~~~~

::

    /OS-FEDERATION/identity_providers/{idp_id}/protocols

A protocol entry contains information that dictates which mapping rules
to use for a given incoming request. An IdP may have multiple supported
protocols.

Required attributes:

-  ``mapping_id`` (string)

Indicates which mapping should be used to process federated
authentication requests.

Mappings
~~~~~~~~

::

    /OS-FEDERATION/mappings

A ``mapping`` is a set of rules to map federation protocol attributes to
Identity API objects. An Identity Provider can have a single ``mapping``
specified per protocol. A mapping is simply a list of ``rules``. The
only Identity API objects that will support mapping are: ``group``.

Required attributes::

-  ``rules`` (list of objects)

Each object contains a rule for mapping attributes to Identity API
concepts. A rule contains a ``remote`` attribute description and the
destination ``local`` attribute.

-  ``local`` (list of objects)

   References a local Identity API resource, such as a ``group`` or
   ``user`` to which the remote attributes will be mapped.

   Each object has one of two structures, as follows.

   To map a remote attribute value directly to a local attribute,
   identify the local resource type and attribute:

   ::

       {
           "user": {
               "name": "{0}"
           }
       }

   Note that at least one rule must have a ``user`` attribute. If the
   ``user`` attribute is missing when processing an assertion, the
   action returns an HTTP 401 Unauthorized error.

   For attribute type and value mapping, identify the local resource
   type, attribute, and value:

   ::

       {
           "group": {
               "id": "89678b"
           }
       }

   This assigns authorization attributes, by way of role assignments on
   the specified group, to ephemeral users.

-  ``remote`` (list of objects)

   At least one object must be included.

   If more than one object is included, the local attribute is applied
   only if all remote attributes match.

   The value identified by ``type`` is always passed through unless a
   constraint is specified using either ``any_one_of`` or
   ``not_one_of``.

   -  ``type`` (string)

   This represents an assertion type keyword.

   -  ``any_one_of`` (list of strings)

   This is mutually exclusive with ``not_any_of``.

   The rule is matched only if any of the specified strings appear in
   the remote attribute ``type``.

   -  ``not_any_of`` (list of strings)

   This is mutually exclusive with ``any_one_of``.

   The rule is not matched if any of the specified strings appear in the
   remote attribute ``type``.

   -  ``regex`` (boolean)

   If ``true``, then each string will be evaluated as a `regular
   expression <http://docs.python.org/2/library/re.html>`__ search
   against the remote attribute ``type``.

Identity Provider API
---------------------

Register an Identity Provider
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    PUT /OS-FEDERATION/identity_providers/{idp_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/identity_provider``

Request:

::

    {
        "identity_provider": {
            "description": "Stores ACME identities.",
            "enabled": true
        }
    }

Response:

::

    Status: 201 Created

    {
        "identity_provider": {
            "description": "Stores ACME identities",
            "enabled": true,
            "id": "ACME",
            "links": {
                "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME"
            }
        }
    }

List identity providers
~~~~~~~~~~~~~~~~~~~~~~~

::

    GET /OS-FEDERATION/identity_providers

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/identity_providers``

Response:

::

    Status: 200 OK

    {
        "identity_providers": [
            {
                "description": "Stores ACME identities",
                "enabled": true,
                "id": "ACME",
                "links": {
                    "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols",
                    "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME"
                }
            },
            {
                "description": "Stores contractor identities",
                "enabled": false,
                "id": "ACME-contractors",
                "links": {
                    "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME-contractors/protocols",
                    "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME-contractors"
                }
            }
        ],
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers"
        }
    }

Get Identity provider
~~~~~~~~~~~~~~~~~~~~~

::

    GET /OS-FEDERATION/identity_providers/{idp_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/identity_provider``

Response:

::

    Status: 200 OK

    {
        "identity_provider": {
            "description": "Stores ACME identities",
            "enabled": false,
            "id": "ACME",
            "links": {
                "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME"
            }
        }
    }

Delete identity provider
~~~~~~~~~~~~~~~~~~~~~~~~

::

    DELETE /OS-FEDERATION/identity_providers/{idp_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/identity_provider``

When an identity provider is deleted, any tokens generated by that
identity provider will be revoked.

Response:

::

    Status: 204 No Content

Update identity provider
~~~~~~~~~~~~~~~~~~~~~~~~

::

    PATCH /OS-FEDERATION/identity_providers/{idp_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/identity_provider``

Request:

::

    {
        "identity_provider": {
            "enabled": true
        }
    }

Response:

::

    Status: 200 OK

    {
        "identity_provider": {
            "description": "Beta dev idp",
            "enabled": true,
            "id": "ACME",
            "links": {
                "protocols": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME"
            }
        }
    }

When an identity provider is disabled, any tokens generated by that
identity provider will be revoked.

Add a protocol and attribute mapping to an identity provider
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    PUT /OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/identity_provider_protocol``

Request:

::

    {
        "protocol": {
            "mapping_id": "xyz234"
        }
    }

Response:

::

    Status: 201 Created

     {
        "protocol": {
            "id": "saml2",
            "mapping_id": "xyz234",
            "links": {
                "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols/saml2"
            }
        }
    }

List all protocol and attribute mappings of an identity provider
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    GET /OS-FEDERATION/identity_providers/{idp_id}/protocols

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/identity_provider_protocols``

Response:

::

    Status: 200 OK

    {
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols"
        },
        "protocols": [
            {
                "id": "saml2",
                "links": {
                    "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME",
                    "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols/saml2"
                },
                "mapping_id": "xyz234"
            }
        ]
    }

Get a protocol and attribute mapping for an identity provider
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    GET /OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/identity_provider_protocol``

Response:

::

    Status: 200 OK

     {
        "protocol": {
            "id": "saml2",
            "mapping_id": "xyz234",
            "links": {
                "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols/saml2"
            }
        }
    }

Update the attribute mapping for an identity provider and protocol
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    PATCH /OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/identity_provider_protocol``

Request:

::

    {
        "protocol": {
            "mapping_id": "xyz234"
        }
    }

Response:

::

    Status: 200 OK

     {
        "protocol": {
            "id": "saml2",
            "mapping_id": "xyz234",
            "links": {
                "identity_provider": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME",
                "self": "http://identity:35357/v3/OS-FEDERATION/identity_providers/ACME/protocols/saml2"
            }
        }
    }

Delete a protocol and attribute mapping from an identity provider
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    DELETE /OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/identity_provider_protocol``

Response:

::

    Status: 204 No Content

Mapping API
-----------

Create a mapping
~~~~~~~~~~~~~~~~

::

    PUT /OS-FEDERATION/mappings/{mapping_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/mapping``

Request:

::

    {
        "mapping": {
            "rules": [
                {
                    "local": [
                        {
                            "user": {
                                "name": "{0}"
                            }
                        },
                        {
                            "group": {
                                "id": "0cd5e9"
                            }
                        }
                    ],
                    "remote": [
                        {
                            "type": "UserName"
                        },
                        {
                            "type": "orgPersonType",
                            "not_any_of": [
                                "Contractor",
                                "Guest"
                            ]
                        }
                    ]
                }
            ]
        }
    }

Response:

::

    Status: 201 Created

    {
        "mapping": {
            "links": {
                "self": "http://identity:35357/v3/OS-FEDERATION/mappings/ACME"
            },
            "id": "ACME",
            "rules": [
                {
                    "local": [
                        {
                            "user": {
                                "name": "{0}"
                            }
                        },
                        {
                            "group": {
                                "id": "0cd5e9"
                            }
                        }
                    ],
                    "remote": [
                        {
                            "type": "UserName"
                        },
                        {
                            "type": "orgPersonType",
                            "not_any_of": [
                                "Contractor",
                                "Guest"
                            ]
                        }
                    ]
                }
            ]
        }
    }

Get a mapping
~~~~~~~~~~~~~

::

    GET /OS-FEDERATION/mappings/{mapping_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/mapping``

Response:

::

    Status: 200 OK

    {
        "mapping": {
            "id": "ACME",
            "links": {
                "self": "http://identity:35357/v3/OS-FEDERATION/mappings/ACME"
            },
            "rules": [
                {
                    "local": [
                        {
                            "user": {
                                "name": "{0}"
                            }
                        },
                        {
                            "group": {
                                "id": "0cd5e9"
                            }
                        }
                    ],
                    "remote": [
                        {
                            "type": "UserName"
                        },
                        {
                            "type": "orgPersonType",
                            "not_any_of": [
                                "Contractor",
                                "Guest"
                            ]
                        }
                    ]
                }
            ]
        }
    }

Update a mapping
~~~~~~~~~~~~~~~~

::

    PATCH /OS-FEDERATION/mappings/{mapping_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/mapping``

Request:

::

    {
        "mapping": {
            "rules": [
                {
                    "local": [
                        {
                            "user": {
                                "name": "{0}"
                            }
                        },
                        {
                            "group": {
                                "id": "0cd5e9"
                            }
                        }
                    ],
                    "remote": [
                        {
                            "type": "UserName"
                        },
                        {
                            "type": "orgPersonType",
                            "any_one_of": [
                                "Contractor",
                                "SubContractor"
                            ]
                        }
                    ]
                }
            ]
        }
    }

Response:

::

    Status: 200 OK

    {
        "mapping": {
            "id": "ACME",
            "links": {
                "self": "http://identity:35357/v3/OS-FEDERATION/mappings/ACME"
            },
            "rules": [
                {
                    "local": [
                        {
                            "user": {
                                "name": "{0}"
                            }
                        },
                        {
                            "group": {
                                "id": "0cd5e9"
                            }
                        }
                    ],
                    "remote": [
                        {
                            "type": "UserName"
                        },
                        {
                            "type": "orgPersonType",
                            "any_one_of": [
                                "Contractor",
                                "SubContractor"
                            ]
                        }
                    ]
                }
            ]
        }
    }

List all mappings
~~~~~~~~~~~~~~~~~

::

    GET /OS-FEDERATION/mappings

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/mappings``

Response:

::

    Status 200 OK

    {
        "links": {
            "next": null,
            "previous": null,
            "self": "http://identity:35357/v3/OS-FEDERATION/mappings"
        },
        "mappings": [
            {
                "id": "ACME",
                "links": {
                    "self": "http://identity:35357/v3/OS-FEDERATION/mappings/ACME"
                },
                "rules": [
                    {
                        "local": [
                            {
                                "user": {
                                    "name": "{0}"
                                }
                            },
                            {
                                "group": {
                                    "id": "0cd5e9"
                                }
                            }
                        ],
                        "remote": [
                            {
                                "type": "UserName"
                            },
                            {
                                "type": "orgPersonType",
                                "any_one_of": [
                                    "Contractor",
                                    "SubContractor"
                                ]
                            }
                        ]
                    }
                ]
            }
        ]
    }

Delete a mapping
~~~~~~~~~~~~~~~~

::

    DELETE /OS-FEDERATION/mappings/{mapping_id}

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/mapping``

Response:

::

    Status: 204 No Content

Listing projects and domains
----------------------------

**Deprecated in v1.1**. This section is deprecated as the functionality
is available in the core Identity API.

List projects a federated user can access
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    GET /OS-FEDERATION/projects

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/projects``

**Deprecated in v1.1**. Use core ``GET /auth/projects``. This call has
the same response format.

Returns a collection of projects to which the federated user has
authorization to access. To access this resource, an unscoped token is
used, the user can then select a project and request a scoped token.
Note that only enabled projects will be returned.

Response:

::

    Status: 200 OK

    {
        "projects": [
            {
                "domain_id": "37ef61",
                "enabled": true,
                "id": "12d706",
                "links": {
                    "self": "http://identity:35357/v3/projects/12d706"
                },
                "name": "a project name"
            },
            {
                "domain_id": "37ef61",
                "enabled": true,
                "id": "9ca0eb",
                "links": {
                    "self": "http://identity:35357/v3/projects/9ca0eb"
                },
                "name": "another project"
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/OS-FEDERATION/projects",
            "previous": null,
            "next": null
        }
    }

List domains a federated user can access
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    GET /OS-FEDERATION/domains

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/domains``

**Deprecated in v1.1**. Use core ``GET /auth/domains``. This call has
the same response format.

Returns a collection of domains to which the federated user has
authorization to access. To access this resource, an unscoped token is
used, the user can then select a domain and request a scoped token. Note
that only enabled domains will be returned.

Response:

::

    Status: 200 OK

    {
        "domains": [
            {
                "description": "desc of domain",
                "enabled": true,
                "id": "37ef61",
                "links": {
                    "self": "http://identity:35357/v3/domains/37ef61"
                },
                "name": "my domain"
            }
        ],
        "links": {
            "self": "http://identity:35357/v3/OS-FEDERATION/domains",
            "previous": null,
            "next": null
        }
    }

Example Mapping Rules
---------------------

Map identities to their own groups
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is an example of *Attribute type and value mappings*, where an
attribute type and value are mapped into an Identity API property and
value.

::

    {
        "rules": [
            {
                "local": [
                    {
                        "user": {
                            "name": "{0}"
                        }
                    }
                ],
                "remote": [
                    {
                        "type": "UserName"
                    }
                ]
            },
            {
                "local": [
                    {
                        "group": {
                            "id": "0cd5e9"
                        }
                    }
                ],
                "remote": [
                    {
                        "type": "orgPersonType",
                        "not_any_of": [
                            "Contractor",
                            "SubContractor"
                        ]
                    }
                ]
            },
            {
                "local": [
                    {
                        "group": {
                            "id": "85a868"
                        }
                    }
                ],
                "remote": [
                    {
                        "type": "orgPersonType",
                        "any_one_of": [
                            "Contractor",
                            "SubContractor"
                        ]
                    }
                ]
            }
        ]
    }

Find specific users, set them to admin group
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is an example that is similar to the previous, but displays how
multiple ``remote`` properties can be used to narrow down on a property.

::

    {
        "rules": [
            {
                "local": [
                    {
                        "user": {
                            "name": "{0}"
                        }
                    },
                    {
                        "group": {
                            "id": "85a868"
                        }
                    }
                ],
                "remote": [
                    {
                        "type": "UserName"
                    },
                    {
                        "type": "orgPersonType",
                        "any_one_of": [
                            "Employee"
                        ]
                    },
                    {
                        "type": "sn",
                        "any_one_of": [
                            "Young"
                        ]
                    }
                ]
            }
        ]
    }

Authenticating
--------------

Request an unscoped OS-FEDERATION token
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    GET/POST /OS-FEDERATION/identity_providers/{identity_provider}/protocols/{protocol}/auth

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/identity_provider_protocol_auth``

A federated user may request an unscoped token, which can be used to get
a scoped token.

Due to the fact that this part of authentication is strictly connected
with the SAML2 authentication workflow, a client should not send any
data, as the content may be lost when a client is being redirected
between Service Provider and Identity Provider. Both HTTP methods - GET
and POST should be allowed as Web Single Sign-On (WebSSO) and Enhanced
Client Proxy (ECP) mechanisms have different authentication workflows
and use different HTTP methods while accessing protected endpoints.

The returned token will contain information about the groups to which
the federated user belongs.

Example Identity API token response: `Various OpenStack token
responses <identity-api-v3.md#authentication-responses>`__

Example of an OS-FEDERATION token:

::

    {
        "token": {
            "methods": [
                "saml2"
            ],
            "user": {
                "id": "username%40example.com",
                "name": "username@example.com",
                "OS-FEDERATION": {
                    "identity_provider": "ACME",
                    "protocol": "SAML",
                    "groups": [
                        {"id": "abc123"},
                        {"id": "bcd234"}
                    ]
                }
            }
        }
    }

Request a scoped OS-FEDERATION token
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    POST /auth/tokens

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/rel/auth_tokens``

A federated user may request a scoped token, by using the unscoped
token. A project or domain may be specified by either id or name. An id
is sufficient to uniquely identify a project or domain.

Request Parameters:

To authenticate with the OS-FEDERATION extension, ``saml2`` must be
specified as an authentication method, and the unscoped token specified
in the id field.

Example request:

::

    {
        "auth": {
            "identity": {
                "methods": [
                    "saml2"
                ],
                "saml2": {
                    "id": "--federated-token-id--"
                }
            }
        },
        "scope": {
            "project": {
                "id": "263fd9"
            }
        }
    }

Similarly to the returned unscoped token, the returned scoped token will
have an ``OS-FEDERATION`` section added to the ``user`` portion of the
token.

Example of an OS-FEDERATION token:

::

    {
        "token": {
            "methods": [
                "saml2"
            ],
            "roles": [
                {
                    "id": "36a8989f52b24872a7f0c59828ab2a26",
                    "name": "admin"
                }
            ],
            "expires_at": "2014-08-06T13:43:43.367202Z",
            "project": {
                "domain": {
                    "id": "1789d1",
                    "links": {
                        "self": "http://identity:35357/v3/domains/1789d1"
                    },
                    "name": "example.com"
                },
                "id": "263fd9",
                "links": {
                    "self": "http://identity:35357/v3/projects/263fd9"
                },
                "name": "project-x"
            },
            "catalog": [
                {
                    "endpoints": [
                        {
                            "id": "39dc322ce86c4111b4f06c2eeae0841b",
                            "interface": "public",
                            "region": "RegionOne",
                            "url": "http://localhost:5000"
                        },
                        {
                            "id": "ec642f27474842e78bf059f6c48f4e99",
                            "interface": "internal",
                            "region": "RegionOne",
                            "url": "http://localhost:5000"
                        },
                        {
                            "id": "c609fc430175452290b62a4242e8a7e8",
                            "interface": "admin",
                            "region": "RegionOne",
                            "url": "http://localhost:35357"
                        }
                    ],
                    "id": "266c2aa381ea46df81bb05ddb02bd14a",
                    "name": "keystone",
                    "type": "identity"
                }
            ],
            "user": {
                "id": "username%40example.com",
                "name": "username@example.com",
                "OS-FEDERATION": {
                    "identity_provider": "ACME",
                    "protocol": "SAML",
                    "groups": [
                        {"id": "abc123"},
                        {"id": "bcd234"}
                    ]
                }
            },
            "issued_at": "2014-08-06T12:43:43.367288Z"
        }
    }

Generating Assertions
---------------------

*New in version 1.1*

Generate a SAML assertion
~~~~~~~~~~~~~~~~~~~~~~~~~

::

    POST /auth/OS-FEDERATION/saml2

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/saml2``

A user may generate a SAML assertion document based on the scoped token
that is used in the request.

Request Parameters:

To generate a SAML assertion, a user must provides a scoped token ID and
region ID in the request body.

Example request:

::

    {
        "auth": {
            "identity": {
                "methods": [
                    "token"
                ],
                "token": {
                    "id": "--token_id--"
                }
            },
            "scope": {
                "region": {
                    "id": "--region_id--"
                }
            }
        }
    }

The response will be a full SAML assertion. Note that for readability
the certificate has been truncated.

Response:

::

    Headers:
        Content-Type: text/xml

    <?xml version="1.0" encoding="UTF-8"?>
    <samlp:Response ID="_257f9d9e9fa14962c0803903a6ccad931245264310738"
       IssueInstant="2009-06-17T18:45:10.738Z" Version="2.0">
    <saml:Issuer Format="urn:oasis:names:tc:SAML:2.0:nameid-format:entity">
       https://www.acme.com
    </saml:Issuer>
    <samlp:Status>
       <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
    </samlp:Status>
    <saml:Assertion ID="_3c39bc0fe7b13769cab2f6f45eba801b1245264310738"
       IssueInstant="2009-06-17T18:45:10.738Z" Version="2.0">
       <saml:Issuer Format="urn:oasis:names:tc:SAML:2.0:nameid-format:entity">
          https://www.acme.com
       </saml:Issuer>
       <saml:Signature>
          <saml:SignedInfo>
             <saml:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
             <saml:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
             <saml:Reference URI="#_3c39bc0fe7b13769cab2f6f45eba801b1245264310738">
                <saml:Transforms>
                   <saml:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
                   <saml:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
                      <ec:InclusiveNamespaces PrefixList="ds saml xs"/>
                   </saml:Transform>
                </saml:Transforms>
                <saml:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>
                <saml:DigestValue>vzR9Hfp8d16576tEDeq/zhpmLoo=
                </saml:DigestValue>
             </saml:Reference>
          </saml:SignedInfo>
          <saml:SignatureValue>
             AzID5hhJeJlG2llUDvZswNUrlrPtR7S37QYH2W+Un1n8c6kTC
             Xr/lihEKPcA2PZt86eBntFBVDWTRlh/W3yUgGOqQBJMFOVbhK
             M/CbLHbBUVT5TcxIqvsNvIFdjIGNkf1W0SBqRKZOJ6tzxCcLo
             9dXqAyAUkqDpX5+AyltwrdCPNmncUM4dtRPjI05CL1rRaGeyX
             3kkqOL8p0vjm0fazU5tCAJLbYuYgU1LivPSahWNcpvRSlCI4e
             Pn2oiVDyrcc4et12inPMTc2lGIWWWWJyHOPSiXRSkEAIwQVjf
             Qm5cpli44Pv8FCrdGWpEE0yXsPBvDkM9jIzwCYGG2fKaLBag==
          </saml:SignatureValue>
          <saml:KeyInfo>
             <saml:X509Data>
                <saml:X509Certificate>
                   MIIEATCCAumgAwIBAgIBBTANBgkqhkiG9w0BAQ0FADCBgzELM
                </saml:X509Certificate>
             </saml:X509Data>
          </saml:KeyInfo>
       </saml:Signature>
       <saml:Subject>
          <saml:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified">
             saml01@acme.com
          </saml:NameID>
          <saml:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
          <saml:SubjectConfirmationData NotOnOrAfter="2009-06-17T18:50:10.738Z"
             Recipient="https://login.www.beta.com"/>
          </saml:SubjectConfirmation>
       </saml:Subject>
       <saml:Conditions NotBefore="2009-06-17T18:45:10.738Z"
          NotOnOrAfter="2009-06-17T18:50:10.738Z">
          <saml:AudienceRestriction>
             <saml:Audience>https://saml.acme.com</saml:Audience>
          </saml:AudienceRestriction>
       </saml:Conditions>
       <saml:AuthnStatement AuthnInstant="2009-06-17T18:45:10.738Z">
          <saml:AuthnContext>
             <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:unspecified
             </saml:AuthnContextClassRef>
          </saml:AuthnContext>
       </saml:AuthnStatement>
       <saml:AttributeStatement>
          <saml:Attribute Name="portal_id">
             <saml:AttributeValue xsi:type="xs:anyType">060D00000000SHZ
             </saml:AttributeValue>
          </saml:Attribute>
          <saml:Attribute Name="organization_id">
             <saml:AttributeValue xsi:type="xs:anyType">00DD0000000F7L5
             </saml:AttributeValue>
          </saml:Attribute>
          <saml:Attribute Name="ssostartpage"
             NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified">
             <saml:AttributeValue xsi:type="xs:anyType">
                http://www.acme.com/security/saml/saml20-gen.jsp
             </saml:AttributeValue>
          </saml:Attribute>
       </saml:AttributeStatement>
    </saml:Assertion>
    </samlp:Response>

For more information about how a SAML assertion is structured, refer to
the `specification <http://saml.xml.org/saml-specifications>`__.

Retrieve Metadata properties
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    GET /OS-FEDERATION/saml2/metadata

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-FEDERATION/1.0/rel/metadata``

A user may retrieve Metadata about an Identity Service acting as an
Identity Provider.

The response will be a full document with Metadata properties. Note that
for readability, this example certificate has been truncated.

Response:

::

    Headers:
        Content-Type: text/xml

    <?xml version="1.0" encoding="UTF-8"?>
    <ns0:EntityDescriptor xmlns:ns0="urn:oasis:names:tc:SAML:2.0:metadata"
       xmlns:ns1="http://www.w3.org/2000/09/xmldsig#" entityID="k2k.com/v3/OS-FEDERATION/idp"
       validUntil="2014-08-19T21:24:17.411289Z">
      <ns0:IDPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
        <ns0:KeyDescriptor use="signing">
          <ns1:KeyInfo>
            <ns1:X509Data>
              <ns1:X509Certificate>MIIDpTCCAo0CAREwDQYJKoZIhvcNAQEFBQAwgZ</ns1:X509Certificate>
            </ns1:X509Data>
          </ns1:KeyInfo>
        </ns0:KeyDescriptor>
      </ns0:IDPSSODescriptor>
      <ns0:Organization>
        <ns0:OrganizationName xml:lang="en">openstack</ns0:OrganizationName>
        <ns0:OrganizationDisplayName xml:lang="en">openstack</ns0:OrganizationDisplayName>
        <ns0:OrganizationURL xml:lang="en">openstack</ns0:OrganizationURL>
      </ns0:Organization>
      <ns0:ContactPerson contactType="technical">
        <ns0:Company>openstack</ns0:Company>
        <ns0:GivenName>first</ns0:GivenName>
        <ns0:SurName>lastname</ns0:SurName>
        <ns0:EmailAddress>admin@example.com</ns0:EmailAddress>
        <ns0:TelephoneNumber>555-555-5555</ns0:TelephoneNumber>
      </ns0:ContactPerson>
    </ns0:EntityDescriptor>

For more information about how a SAML assertion is structured, refer to
the `specification <http://saml.xml.org/saml-specifications>`__.
