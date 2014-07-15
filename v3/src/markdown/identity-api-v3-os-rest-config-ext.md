OpenStack Identity API v3 OS-REST-CONFIG Extension
==================================================

Provide an ability to query the current values of configuration options. This extension
requires v3.3 of the Identity API.

API Resources
-------------

### Identity Configuration: `/OS-REST_CONFIG/config`

The configuration resource represents the current values of all (or a sub-set)
of the configuration options in the running Identity service.

    {
        "config": {
            "group1": {
                "optionA": string,
                "optionB": string
            }
            "group2": {
                "optionC": boolean,
                "optionD": string
            }
            "links": {
                "self": url
            }
            "option1": string,
            "option2": string,
            "option3": boolean,
        }
    }

API
---

The following additional APIs are supported by this extension:

#### Get current values of configuration options:
`GET /OS-REST-CONFIG/config`

The actual contents of the response may vary depending on the version of the
identity service being run, but a typical response is shown below:

Response:

    Status: 200 OK

    {
        "config": {
            "admin_bind_host": "0.0.0.0",
            "admin_endpoint": null,
            "admin_port": 35357,
            "admin_token": "**********",
            "admin_workers": 2,
            "amqp_auto_delete": false,
            "amqp_durable_queues": false,
            "assignment": {
                "cache_time": null,
                "caching": true,
                "driver": null,
                "list_limit": null
            },
            "audit": {
                "namespace": "openstack"
            },
            "auth": {
                "external": "keystone.auth.plugins.external.DefaultDomain",
                "keystone.auth.plugins.external.DefaultDomain": null,
                "keystone.auth.plugins.oauth1.OAuth": null,
                "keystone.auth.plugins.password.Password": null,
                "keystone.auth.plugins.saml2.Saml2": null,
                "keystone.auth.plugins.token.Token": null,
                "methods": [
                    "keystone.auth.plugins.external.DefaultDomain",
                    "keystone.auth.plugins.password.Password",
                    "keystone.auth.plugins.token.Token",
                    "keystone.auth.plugins.oauth1.OAuth",
                    "keystone.auth.plugins.saml2.Saml2"
                ],
                "password": "keystone.auth.plugins.password.Password",
                "token": "keystone.auth.plugins.token.Token"
            },
            "cache": {
                "backend": "dogpile.cache.memory",
                "backend_argument": [],
                "config_prefix": "cache.keystone",
                "debug_cache_backend": false,
                "enabled": true,
                "expiration_time": 600,
                "proxies": [
                    "keystone.tests.test_cache.CacheIsolatingProxy"
                ]
            },
            "catalog": {
                "driver": "keystone.catalog.backends.sql.Catalog",
                "list_limit": null,
                "template_file": "/opt/stack/keystone/keystone/tests/default_catalog.templates"
            },
            "compute_port": 8774,
            "config_dir": null,
            "config_file": [
                "/opt/stack/keystone/keystone/tests/config_files/backend_sql.conf"
            ],
            "control_exchange": "openstack",
            "credential": {
                "driver": "keystone.credential.backends.sql.Credential"
            },
            "crypt_strength": 40000,
            "database": {
                "backend": "sqlalchemy",
                "connection": "**********",
                "connection_debug": 0,
                "connection_trace": false,
                "db_inc_retry_interval": true,
                "db_max_retries": 20,
                "db_max_retry_interval": 10,
                "db_retry_interval": 1,
                "idle_timeout": 200,
                "max_overflow": null,
                "max_pool_size": null,
                "max_retries": 10,
                "min_pool_size": 1,
                "mysql_sql_mode": "TRADITIONAL",
                "pool_timeout": null,
                "retry_interval": 10,
                "slave_connection": "**********",
                "sqlite_db": "oslo.sqlite",
                "sqlite_synchronous": true,
                "use_db_reconnect": false
            },
            "debug": false,
            "default_log_levels": [
                "amqp=WARN",
                "amqplib=WARN",
                "boto=WARN",
                "qpid=WARN",
                "sqlalchemy=WARN",
                "suds=INFO",
                "oslo.messaging=INFO",
                "iso8601=WARN",
                "requests.packages.urllib3.connectionpool=WARN"
            ],
            "default_publisher_id": null,
            "domain_id_immutable": true,
            "ec2": {
                "driver": "keystone.contrib.ec2.backends.sql.Ec2"
            },
            "endpoint_filter": {
                "driver": "keystone.contrib.endpoint_filter.backends.sql.EndpointFilter",
                "return_all_endpoints_if_no_filter": true
            },
            "fake_rabbit": false,
            "fatal_deprecations": false,
            "federation": {
                "assertion_prefix": "",
                "driver": "keystone.contrib.federation.backends.sql.Federation"
            },
            "identity": {
                "default_domain_id": "default",
                "domain_config_dir": "/etc/keystone/domains",
                "domain_specific_drivers_enabled": false,
                "driver": "keystone.identity.backends.sql.Identity",
                "list_limit": null,
                "max_password_length": 4096
            },
            "identity_mapping": {
                "backward_compatible_ids": true,
                "driver": "keystone.identity.mapping_backends.sql.Mapping",
                "generator": "keystone.identity.id_generators.sha256.Generator"
            },
            "instance_format": "[instance: %(uuid)s] ",
            "instance_uuid_format": "[instance: %(uuid)s] ",
            "kombu_reconnect_delay": 1.0,
            "kombu_ssl_ca_certs": "",
            "kombu_ssl_certfile": "",
            "kombu_ssl_keyfile": "",
            "kombu_ssl_version": "",
            "kvs": {
                "backends": [
                    "keystone.tests.test_kvs.KVSBackendForcedKeyMangleFixture",
                    "keystone.tests.test_kvs.KVSBackendFixture"
                ],
                "config_prefix": "keystone.kvs",
                "default_lock_timeout": 5,
                "enable_key_mangler": true
            },
            "ldap": {
                "alias_dereferencing": "default",
                "allow_subtree_delete": false,
                "chase_referrals": null,
                "debug_level": null,
                "dumb_member": "cn=dumb,dc=nonexistent",
                "group_additional_attribute_mapping": [],
                "group_allow_create": true,
                "group_allow_delete": true,
                "group_allow_update": true,
                "group_attribute_ignore": [],
                "group_desc_attribute": "description",
                "group_filter": null,
                "group_id_attribute": "cn",
                "group_member_attribute": "member",
                "group_name_attribute": "ou",
                "group_objectclass": "groupOfNames",
                "group_tree_dn": null,
                "page_size": 0,
                "password": "**********",
                "project_additional_attribute_mapping": [],
                "project_allow_create": true,
                "project_allow_delete": true,
                "project_allow_update": true,
                "project_attribute_ignore": [],
                "project_desc_attribute": "description",
                "project_domain_id_attribute": "businessCategory",
                "project_enabled_attribute": "enabled",
                "project_enabled_emulation": false,
                "project_enabled_emulation_dn": null,
                "project_filter": null,
                "project_id_attribute": "cn",
                "project_member_attribute": "member",
                "project_name_attribute": "ou",
                "project_objectclass": "groupOfNames",
                "project_tree_dn": null,
                "query_scope": "one",
                "role_additional_attribute_mapping": [],
                "role_allow_create": true,
                "role_allow_delete": true,
                "role_allow_update": true,
                "role_attribute_ignore": [],
                "role_filter": null,
                "role_id_attribute": "cn",
                "role_member_attribute": "roleOccupant",
                "role_name_attribute": "ou",
                "role_objectclass": "organizationalRole",
                "role_tree_dn": null,
                "suffix": "cn=example,cn=com",
                "tls_cacertdir": null,
                "tls_cacertfile": null,
                "tls_req_cert": "demand",
                "url": "ldap://localhost",
                "use_dumb_member": false,
                "use_tls": false,
                "user": null,
                "user_additional_attribute_mapping": [],
                "user_allow_create": true,
                "user_allow_delete": true,
                "user_allow_update": true,
                "user_attribute_ignore": [
                    "default_project_id",
                    "tenants"
                ],
                "user_default_project_id_attribute": null,
                "user_enabled_attribute": "enabled",
                "user_enabled_default": "True",
                "user_enabled_emulation": false,
                "user_enabled_emulation_dn": null,
                "user_enabled_mask": 0,
                "user_filter": null,
                "user_id_attribute": "cn",
                "user_mail_attribute": "email",
                "user_name_attribute": "sn",
                "user_objectclass": "inetOrgPerson",
                "user_pass_attribute": "userPassword",
                "user_tree_dn": null
            },
            "links": {
                "self": "http://localhost/v3/OS-REST-CONFIG/config"
            },
            "list_limit": null,
            "log_config_append": null,
            "log_date_format": "%Y-%m-%d %H:%M:%S",
            "log_dir": null,
            "log_file": null,
            "log_format": null,
            "logging_context_format_string": "%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s",
            "logging_debug_format_suffix": "%(funcName)s %(pathname)s:%(lineno)d",
            "logging_default_format_string": "%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s",
            "logging_exception_prefix": "%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s",
            "max_param_size": 64,
            "max_request_body_size": 114688,
            "max_token_size": 8192,
            "member_role_id": "9fe2ff9ee4384b1894a90878d3e92bab",
            "member_role_name": "_member_",
            "memcache": {
                "max_compare_and_set_retry": 16,
                "servers": [
                    "localhost:11211"
                ]
            },
            "notification_driver": [],
            "notification_topics": [
                "notifications"
            ],
            "oauth1": {
                "access_token_duration": 86400,
                "driver": "keystone.contrib.oauth1.backends.sql.OAuth1",
                "request_token_duration": 28800
            },
            "os_inherit": {
                "enabled": false
            },
            "paste_deploy": {
                "config_file": "keystone-paste.ini"
            },
            "policy": {
                "driver": "keystone.policy.backends.sql.Policy",
                "list_limit": null
            },
            "policy_default_rule": "default",
            "policy_file": "/opt/stack/keystone/etc/policy.json",
            "public_bind_host": "0.0.0.0",
            "public_endpoint": null,
            "public_port": 5000,
            "public_workers": 2,
            "publish_errors": false,
            "pydev_debug_host": null,
            "pydev_debug_port": null,
            "rabbit_ha_queues": false,
            "rabbit_host": "localhost",
            "rabbit_hosts": [
                "localhost:5672"
            ],
            "rabbit_login_method": "AMQPLAIN",
            "rabbit_max_retries": 0,
            "rabbit_password": "**********",
            "rabbit_port": 5672,
            "rabbit_retry_backoff": 2,
            "rabbit_retry_interval": 1,
            "rabbit_use_ssl": false,
            "rabbit_userid": "guest",
            "rabbit_virtual_host": "/",
            "revoke": {
                "caching": true,
                "driver": "keystone.contrib.revoke.backends.sql.Revoke",
                "expiration_buffer": 1800
            },
            "rpc_backend": "rabbit",
            "rpc_conn_pool_size": 30,
            "signing": {
                "ca_certs": "examples/pki/certs/cacert.pem",
                "ca_key": "/etc/keystone/ssl/private/cakey.pem",
                "cert_subject": "/C=US/ST=Unset/L=Unset/O=Unset/CN=www.example.com",
                "certfile": "examples/pki/certs/signing_cert.pem",
                "key_size": 2048,
                "keyfile": "examples/pki/private/signing_key.pem",
                "token_format": null,
                "valid_days": 3650
            },
            "ssl": {
                "ca_certs": "/etc/keystone/ssl/certs/ca.pem",
                "ca_key": "/etc/keystone/ssl/private/cakey.pem",
                "cert_required": false,
                "cert_subject": "/C=US/ST=Unset/L=Unset/O=Unset/CN=localhost",
                "certfile": "/etc/keystone/ssl/certs/keystone.pem",
                "enable": false,
                "key_size": 1024,
                "keyfile": "/etc/keystone/ssl/private/keystonekey.pem",
                "valid_days": 3650
            },
            "standard_threads": false,
            "stats": {
                "driver": "keystone.contrib.stats.backends.kvs.Stats"
            },
            "strict_password_check": false,
            "syslog_log_facility": "LOG_USER",
            "tcp_keepalive": false,
            "tcp_keepidle": 600,
            "token": {
                "bind": [],
                "cache_time": null,
                "caching": true,
                "driver": "keystone.token.backends.sql.Token",
                "enforce_token_bind": "permissive",
                "expiration": 3600,
                "hash_algorithm": "md5",
                "provider": null,
                "revocation_cache_time": 3600,
                "revoke_by_id": true
            },
            "transport_url": null,
            "trust": {
                "driver": "keystone.trust.backends.sql.Trust",
                "enabled": true
            },
            "use_stderr": true,
            "use_syslog": false,
            "use_syslog_rfc_format": false,
            "verbose": false
        }
    }

Configuration options that are marked as secret will have their values
obfuscated, for example see the ``admin_token`` option in the above example.

A specific group or option can also be specified in the url to retrieve a
subset of the configuration options. For example to retrieve the options in
the ``token`` group:

`GET /OS-REST-CONFIG/config/group/token`

Response:

    Status: 200 OK

    {
        "config": {
            "token": {
                "bind": [],
                "cache_time": null,
                "caching": true,
                "driver": "keystone.token.backends.sql.Token",
                "enforce_token_bind": "permissive",
                "expiration": 3600,
                "hash_algorithm": "md5",
                "provider": null,
                "revocation_cache_time": 3600,
                "revoke_by_id": true
            }
        }
    }

To retrieve just a specific option, then option name itself can be included
in the url. For example, to retrieve the ``expiration`` time from the token
configuration group the following url would be used:


`GET /OS-REST-CONFIG/config/group/token/option/expiration`

Response:

    Status: 200 OK

    {
        "config": {
            "token": {
                "expiration": 3600
            }
        }
    }

A specific option that is not part of a group can also be retrieved:

`GET /OS-REST-CONFIG/config/option/use_syslog`

Response:

    Status: 200 OK

    {
        "config": {
            "use_syslog": false
        }
    }
