OpenStack Identity API v3 OS-SIMPLE-CERT Extension
==================================================

When using Public Key Infrastructure (PKI) tokens with the identity
service, users must have access to the signing certificate and the
certificate authority's (CA) certificate for the token issuer in order
to validate tokens. This extension provides a simple means of retrieving
these certificates from an identity service.

API Resources
-------------

Certificates
------------

The identity server uses X.509 certificates to cryptographically sign
issued tokens. Certificates are a public resource and can be shared.
Typically when validating a certificate we would only require the
issuing certificate authority's certificate however PKI tokens are
distributed without including the original signing certificate in the
message so this must be retrievable as well.

Certificates are provided in the Private Enchanced Mail (PEM) file
format. Certificates in PEM files can be represented with or without the
certificate data (examples shown). The represented certificate is for
informative purposes and the only required information is presented
between the ``-----BEGIN CERTIFICATE-----`` and
``-----END CERTIFICATE-----`` tags.

API
---

Retrieve CA certificate chain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /OS-SIMPLE-CERT/ca

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-SIMPLE-CERT/1.0/rel/ca_certificate``

Fetches the certificate chain used to authenticate signed tokens.

It is possible that a chain of certificates (more than one) is returned.
In this case the chain should be used when validating a token.

::

    Status: 200 OK
    Content-Type: application/x-pem-file

    -----BEGIN CERTIFICATE-----
    MIIDgTCCAmmgAwIBAgIJAJpWjfJuWL+oMA0GCSqGSIb3DQEBBQUAMFcxCzAJBgNV
    BAYTAlVTMQ4wDAYDVQQIDAVVbnNldDEOMAwGA1UEBwwFVW5zZXQxDjAMBgNVBAoM
    BVVuc2V0MRgwFgYDVQQDDA93d3cuZXhhbXBsZS5jb20wHhcNMTMxMjA5MDEzMDUw
    WhcNMjMxMjA3MDEzMDUwWjBXMQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVW5zZXQx
    DjAMBgNVBAcMBVVuc2V0MQ4wDAYDVQQKDAVVbnNldDEYMBYGA1UEAwwPd3d3LmV4
    YW1wbGUuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxzQwzCPN
    3zMsUX6GwNcS9n/dJq4gzddClFB7ZgfVKOwdEVx/XX9w8wflFWq+JqqMA81ZtLFP
    w0fKJFISMSVH7TXPRp096cC41Nv5dCt0kfVChyUUKUGiEzvUU8WagU7uWE4Rj+6d
    CQvdbot0/5eDFJL90cj+Ck5dn/lqBxLSnHjTLLqHscpD+qOc6XL4JxCM1SOkS1LL
    aRPLksqyKZwz8R86yR/9FnIREGO52VDje0hYUwLw0TzurSi1QHuBB/aZ2aC7A79G
    YBBMo79amu8Oc4x+VzOxtY1hlrxYb1oV7SAcZgmPQKo8uwl47yqd5Ya85HC3AsVY
    HSGYjsHrTS8QlQIDAQABo1AwTjAMBgNVHRMEBTADAQH/MB0GA1UdDgQWBBTkjsL2
    BVqZImdt+VxEo+9b7fymQzAfBgNVHSMEGDAWgBTkjsL2BVqZImdt+VxEo+9b7fym
    QzANBgkqhkiG9w0BAQUFAAOCAQEAC7y75ST8tOFp6VOhTTdjGxGU+FJhKNikYCfw
    TL5bzjSpmzBXcy5ep+klxVtLyU0KJeuAwep9g6bPlYQP44vshsZEIH4EV5b9Ztzh
    FnKfd0jeP0GLhQiQYDkvpNAu/uMbT4+/3jhM3mJoslDZDl7x7MF4FQU0N7fzRj/Y
    /XNzA6DWllQs62Up5WcqQJes0NeTKXyLoDH9Mf1W7hLHWLxr5bY3xD2MdrdDTtp1
    KxPZVcFaBpI+hVHfi5jhLXBK0I8jgHqQLxjhp8TfIy6U4m4KpdlOvET2R55Lttrs
    SFP+fy+e3IO9wMXmQKQJdj3ArieW0hkmz9xTYIRm5vS494gi6Q==
    -----END CERTIFICATE-----

Retrieve signing certificates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

    GET /OS-SIMPLE-CERT/certificates

Relationship:
``http://docs.openstack.org/api/openstack-identity/3/ext/OS-SIMPLE-CERT/1.0/rel/certificates``

Fetches the certificates containing the public key for the private key
that has been used to sign tokens.

In an environment with multiple token signers this call will return all
valid certificates.

::

    Status: 200 OK
    Content-Type: application/x-pem-file

    Certificate:
        Data:
            Version: 3 (0x2)
            Serial Number: 1 (0x1)
        Signature Algorithm: sha1WithRSAEncryption
            Issuer: C=US, ST=Unset, L=Unset, O=Unset, CN=www.example.com
            Validity
                Not Before: Dec  9 01:30:50 2013 GMT
                Not After : Dec  7 01:30:50 2023 GMT
            Subject: C=US, ST=Unset, O=Unset, CN=www.example.com
            Subject Public Key Info:
                Public Key Algorithm: rsaEncryption
                    Public-Key: (2048 bit)
                    Modulus:
                        00:da:a1:9a:00:3f:52:16:63:87:f7:7c:fb:27:ef:
                        04:7b:b3:f8:59:e3:d1:79:cc:22:af:f2:02:5c:d7:
                        0f:e8:53:bd:5c:db:a4:93:98:62:25:ad:c9:6e:60:
                        37:98:29:c6:e7:0b:3d:b6:64:f6:ad:58:96:e3:87:
                        af:2a:a4:17:ef:31:3c:60:ef:97:27:db:5e:83:95:
                        5b:4f:d6:4b:e8:34:c9:ff:d9:79:bc:f6:7c:db:dc:
                        d4:91:1b:3d:61:53:54:95:7e:1d:71:dd:9d:cb:39:
                        e3:ba:ed:39:f4:27:48:60:1b:8d:82:c8:65:e5:a1:
                        30:ff:83:bc:84:e8:35:3a:a5:c2:27:7c:84:15:1b:
                        91:27:34:44:9d:af:b1:cb:14:54:e0:52:d3:ce:b4:
                        03:b7:4c:63:f7:aa:3f:1d:aa:17:ac:2b:81:ec:ad:
                        e5:30:ac:fa:08:25:00:50:dc:0c:1c:bd:6c:38:eb:
                        30:55:5a:e0:ca:11:a8:57:a5:db:65:78:5b:58:76:
                        f4:01:52:87:4f:d5:a1:80:77:66:8a:2c:d8:77:92:
                        11:49:b6:00:fd:28:85:80:23:d7:87:8a:50:15:7d:
                        07:2a:6f:44:dc:83:cf:f1:67:5e:8a:9c:b7:2a:2e:
                        f3:e9:4d:9a:33:9d:e5:1d:7d:3a:9b:ce:80:f4:78:
                        d7:55
                    Exponent: 65537 (0x10001)
            X509v3 extensions:
                X509v3 Basic Constraints:
                    CA:FALSE
                X509v3 Subject Key Identifier:
                    D5:50:6E:6A:AA:8E:21:36:44:28:D4:AB:E4:D3:01:09:D7:BC:CB:73
                X509v3 Authority Key Identifier:
                    keyid:E4:8E:C2:F6:05:5A:99:22:67:6D:F9:5C:44:A3:EF:5B:ED:FC:A6:43

        Signature Algorithm: sha1WithRSAEncryption
             80:60:ef:84:25:e9:02:ea:1e:da:70:fe:0b:b6:15:69:27:15:
             0a:8e:5e:69:7b:b3:af:91:0e:78:08:37:98:56:be:eb:60:af:
             7e:6b:e3:62:eb:dc:86:9f:9b:20:81:32:75:05:32:c9:f7:7b:
             2b:32:00:10:83:07:a0:e2:f4:81:63:5e:50:e7:5b:00:67:a6:
             19:54:ea:31:9a:02:a8:f1:fa:92:5b:e1:13:23:a1:28:5c:8e:
             64:03:22:16:02:d2:a5:52:aa:34:39:ab:70:0c:46:77:53:5b:
             07:71:41:0a:0b:a8:76:2c:45:e6:38:3b:aa:ee:dc:ca:8b:2f:
             85:18:57:0a:e3:cf:3d:cc:a8:46:5a:4b:42:14:e8:66:10:8a:
             91:79:c1:2e:27:5f:b1:60:5a:d1:5e:d5:98:c7:11:fe:da:89:
             ee:7b:24:e4:19:7a:5f:56:ba:63:70:31:01:87:8d:7a:90:88:
             14:4f:a1:23:46:0e:3b:df:33:01:98:53:71:d6:f4:25:37:52:
             ff:43:b8:60:03:65:29:98:45:a8:da:62:a3:be:66:bf:59:68:
             2c:50:3d:de:36:e9:75:8a:d3:69:a2:74:3c:80:c1:fe:cf:53:
             4f:46:28:fe:f9:b0:a9:6a:db:2a:30:9a:e7:b5:c0:cc:0b:d6:
             39:b8:6b:ee
    -----BEGIN CERTIFICATE-----
    MIIDZjCCAk6gAwIBAgIBATANBgkqhkiG9w0BAQUFADBXMQswCQYDVQQGEwJVUzEO
    MAwGA1UECAwFVW5zZXQxDjAMBgNVBAcMBVVuc2V0MQ4wDAYDVQQKDAVVbnNldDEY
    MBYGA1UEAwwPd3d3LmV4YW1wbGUuY29tMB4XDTEzMTIwOTAxMzA1MFoXDTIzMTIw
    NzAxMzA1MFowRzELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVVuc2V0MQ4wDAYDVQQK
    DAVVbnNldDEYMBYGA1UEAwwPd3d3LmV4YW1wbGUuY29tMIIBIjANBgkqhkiG9w0B
    AQEFAAOCAQ8AMIIBCgKCAQEA2qGaAD9SFmOH93z7J+8Ee7P4WePRecwir/ICXNcP
    6FO9XNukk5hiJa3JbmA3mCnG5ws9tmT2rViW44evKqQX7zE8YO+XJ9teg5VbT9ZL
    6DTJ/9l5vPZ829zUkRs9YVNUlX4dcd2dyznjuu059CdIYBuNgshl5aEw/4O8hOg1
    OqXCJ3yEFRuRJzREna+xyxRU4FLTzrQDt0xj96o/HaoXrCuB7K3lMKz6CCUAUNwM
    HL1sOOswVVrgyhGoV6XbZXhbWHb0AVKHT9WhgHdmiizYd5IRSbYA/SiFgCPXh4pQ
    FX0HKm9E3IPP8Wdeipy3Ki7z6U2aM53lHX06m86A9HjXVQIDAQABo00wSzAJBgNV
    HRMEAjAAMB0GA1UdDgQWBBTVUG5qqo4hNkQo1Kvk0wEJ17zLczAfBgNVHSMEGDAW
    gBTkjsL2BVqZImdt+VxEo+9b7fymQzANBgkqhkiG9w0BAQUFAAOCAQEAgGDvhCXp
    Auoe2nD+C7YVaScVCo5eaXuzr5EOeAg3mFa+62CvfmvjYuvchp+bIIEydQUyyfd7
    KzIAEIMHoOL0gWNeUOdbAGemGVTqMZoCqPH6klvhEyOhKFyOZAMiFgLSpVKqNDmr
    cAxGd1NbB3FBCguodixF5jg7qu7cyosvhRhXCuPPPcyoRlpLQhToZhCKkXnBLidf
    sWBa0V7VmMcR/tqJ7nsk5Bl6X1a6Y3AxAYeNepCIFE+hI0YOO98zAZhTcdb0JTdS
    /0O4YANlKZhFqNpio75mv1loLFA93jbpdYrTaaJ0PIDB/s9TT0Yo/vmwqWrbKjCa
    57XAzAvWObhr7g==
    -----END CERTIFICATE-----

HTTP Status Codes
~~~~~~~~~~~~~~~~~

The following codes are used to indicate success of failure conditions.

200 OK
^^^^^^

Certificates are successfully found and returned.

403 Forbidden
^^^^^^^^^^^^^

There are no certificates to be returned. This will typically indicate
that keystone is using UUID tokens and therefore there are no
certificates available.

500 Internal Server Error
^^^^^^^^^^^^^^^^^^^^^^^^^

An Error was produced on the server. A typical example is that the
server is configured to use PKI tokens but is misconfigured and the
certificates were unable to be found.
