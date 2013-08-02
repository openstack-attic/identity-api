OpenStack Identity API v3 OS-PKI Extension
==========================================

Public Key Infrastructure (PKI) provides remove validation of a document
by using asymmetric cryptography.  Keystone provides tokens in a Crypto
Message Syntax (CMS) based format that can be validated using X509
certificates.  This extension provides access to the resources required
to validate tokens without passing the token back to the Keystone server.

API Resources
-------------

### Certificates

X509 is a ITU-T standard for PKI which specified standard formats for public
key certificates.  The certificates provided by this extension fall into two
categories.  The first is the Certificate for the Authority that issued the
certificates. This is known as a Certificate Authority Certificate,
abbreviated to CA-Cert.

The second is a certificate that can be used to sign documents.  This is known
as a signing certificate.

### Token revocation list

THe identity API allows for tokens issued as signed documents in CMS based
format.  If a token has been revoked, the document will still appear as a
valid document.  In order to ensure revoked tokens are not treated as valid,
the entity attempting to validate the token must ensure the token in question
does not appear on a current token revocation list.


The key use cases we need to cover:

- Fetch the trusted CA certificate with the certificate chain.
- Fetch a signing certificate
- Fetch a token revocation list

#### Get CA-cert: `GET /certificates/ca

Response:

    Status: 200 OK
    ContentType: application/x-pem-file

    -----BEGIN CERTIFICATE-----
    MIID7TCCAtWgAwIBAgIJAKmdfCh2sOugMA0GCSqGSIb3DQEBBQUAMFcxCzAJBgNV
    BAYTAlVTMQ4wDAYDVQQIEwVVbnNldDEOMAwGA1UEBxMFVW5zZXQxDjAMBgNVBAoT
    BVVuc2V0MRgwFgYDVQQDEw93d3cuZXhhbXBsZS5jb20wHhcNMTMwNzMwMDIzMTE4
    WhcNMjMwNzI4MDIzMTE4WjBXMQswCQYDVQQGEwJVUzEOMAwGA1UECBMFVW5zZXQx
    DjAMBgNVBAcTBVVuc2V0MQ4wDAYDVQQKEwVVbnNldDEYMBYGA1UEAxMPd3d3LmV4
    YW1wbGUuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqPIG6O5w
    Z+giFBiTua2041Qk8kosBki6Vvgo+CqOEQhmz9mP8m/rlb5pUhAkIuIwRRcZ1uXN
    MYks1E7D58lTlHSvWbD87+897rOdBhVwgsYr8bWSgjpDTOnSwGhReooJtIks5FUH
    E6uVVGv0scjX1QN3qGfPZpfta4qq8/v7Gj1Etf55yBSF+AMrA0n8k2suvGn5RnFq
    MnRD1CbK30JVlRbInHfPSTvEgcQaTpPO6rlUP1B6MHn8iiLvgp6bmQWmZ3jci5J/
    fdwIn3u95yHa/ahGGiN3PPOH2vXr0JMxfrJV3bZKgfm2MLRxAJkH/i5AigRGeBng
    JVyrpyHfLcGl9QIDAQABo4G7MIG4MAwGA1UdEwQFMAMBAf8wHQYDVR0OBBYEFEd/
    NUS25P3pzSQebO1MRZYtdcooMIGIBgNVHSMEgYAwfoAUR381RLbk/enNJB5s7UxF
    li11yiihW6RZMFcxCzAJBgNVBAYTAlVTMQ4wDAYDVQQIEwVVbnNldDEOMAwGA1UE
    BxMFVW5zZXQxDjAMBgNVBAoTBVVuc2V0MRgwFgYDVQQDEw93d3cuZXhhbXBsZS5j
    b22CCQCpnXwodrDroDANBgkqhkiG9w0BAQUFAAOCAQEAo5zJydnt7L9FDoajytuU
    t+z4IyC5WtKDwd+sETuCnpS32wFyLCAvjQKsRb4bX0BvJhMENxILE5dFWYBh8Kd8
    /O2lEvtYTWx/OF9qUKSOEwwrFXwtEtQdm7TMKUY6tyW8aWgvH6bgMHNwkWQuquD5
    dK9fndITXx+wn3Ukes7yoN4nDsRmBgJo0QDL3dZWSJaNfY1wpnWlVl9niAPbTa6q
    YOSOK5aJfSvZO4o1wxr1rhvsEeJzGcxlsaO8OezcPzD79VHZHOmdNm4cBI90Zdto
    w9di2s1NRQeEMcLXfHmqD0N7BicdTiaizZPk77i52nVtbTJA+ItL/O3NOMvl23xM
    gA==
    -----END CERTIFICATE-----

#### Get policy: `GET OS-PKI/certificates/signing

What follows is a sample response of an x509 certificate in PEM format.
The header information is optional;  The only data actually required is from::

s from (and includes) This is ambiguous as to whether, the -----BEGIN …	Aug 2
    -----BEGIN CERTIFICATE-----
to::
    -----END CERTIFICATE-----


Response:

    Status: 200 OK
    ContentType: application/x-pem-file

    Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1 (0x1)
    Signature Algorithm: sha1WithRSAEncryption
        Issuer: C=US, ST=Unset, L=Unset, O=Unset, CN=www.example.com
        Validity
            Not Before: Jul 30 02:31:18 2013 GMT
            Not After : Jul 28 02:31:18 2023 GMT
        Subject: C=US, ST=Unset, O=Unset, CN=www.example.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:c2:b7:82:69:4e:76:9a:f1:db:87:43:1c:b9:64:
                    9c:59:96:30:d3:b0:da:a4:b1:d3:3b:4e:a0:ae:f6:
                    a4:63:f8:40:d1:47:12:e0:57:39:75:a4:01:c2:08:
                    ad:9d:30:de:06:6f:d8:eb:a2:7f:6c:d6:9e:0e:88:
                    1e:8c:ff:d5:bb:d5:e5:87:fe:61:6c:3f:30:17:eb:
                    e2:30:b0:c9:d7:10:16:ba:12:8a:86:ba:c7:b6:91:
                    60:8b:71:90:30:52:fb:fd:ab:4f:e6:ae:91:b2:61:
                    e0:c2:44:e8:2e:a3:40:9c:92:87:f4:fd:62:1d:24:
                    7a:f0:0a:96:69:cf:5f:5c:51:26:71:7e:40:6a:84:
                    ef:dd:ed:e5:ed:23:72:47:77:c2:0c:32:d1:0b:6b:
                    10:19:e3:28:09:ff:19:3f:8b:c8:f4:d4:1f:51:73:
                    e2:51:0a:b0:8f:79:13:f7:2b:d6:91:a1:30:73:ba:
                    21:fe:a6:e0:5a:d5:92:0a:79:32:79:09:6c:2b:92:
                    c4:77:c2:10:78:54:e8:12:7b:10:40:fe:f3:1a:b4:
                    29:5a:48:3f:17:b6:ff:3e:4a:b1:66:d1:3d:f7:58:
                    0a:82:bf:22:e9:7e:d7:5c:21:4f:79:0a:05:17:fd:
                    df:c4:52:5c:74:ae:bd:b1:f8:ba:6d:e7:8f:25:44:
                    6a:47
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:FALSE
            X509v3 Subject Key Identifier:
                51:31:48:38:5E:E7:7A:EE:73:8E:90:BB:6F:2D:B3:E6:17:DB:B9:5A
            X509v3 Authority Key Identifier:
               keyid:47:7F:35:44:B6:E4:FD:E9:CD:24:1E:6C:ED:4C:45:96:2D:75:CA:28
                DirName:/C=US/ST=Unset/L=Unset/O=Unset/CN=www.example.com
                serial:A9:9D:7C:28:76:B0:EB:A0

    Signature Algorithm: sha1WithRSAEncryption
         3c:c0:f4:94:c2:bd:5a:7c:bf:df:09:e8:53:38:b6:f2:7a:fc:
         83:55:d3:7a:b8:d8:d2:b0:18:d9:b1:2b:ab:79:b9:4a:85:38:
         de:6b:a0:f3:c6:cc:83:c3:8f:fb:f7:39:23:0e:79:6a:9c:57:
         fc:0e:1c:4d:e3:0a:bd:bd:d7:80:3c:1a:a1:33:c4:25:4a:ae:
         c6:b2:10:5c:fd:f2:20:4f:ef:c7:44:72:66:7c:8e:6b:72:25:
         02:16:2b:20:74:f4:0e:eb:74:52:26:db:a9:39:eb:19:4c:90:
         df:24:3c:1f:96:d2:e1:10:f5:ce:27:74:2b:95:f8:38:1b:08:
         ff:2b:96:e8:6f:0a:1a:eb:ee:8d:88:80:8b:91:ac:b5:5b:a1:
         5d:16:c3:cb:8f:26:24:14:13:b0:eb:67:58:1c:2f:39:df:77:
         dc:37:37:ef:ff:0e:40:48:0c:80:11:94:29:1f:84:14:44:9a:
         08:96:62:f6:84:84:f2:59:73:ec:14:09:62:f0:6f:9c:fe:99:
         85:88:7a:f9:13:ba:a9:a5:f9:d5:30:eb:26:63:0c:c7:0f:8e:
         b7:10:a0:30:5f:40:19:ce:e2:a4:ed:b5:2c:57:16:37:16:f5:
         f9:5b:3d:d0:11:3c:47:91:6f:99:a5:9b:d9:bc:91:7a:bc:16:
         25:c8:b5:08
     -----BEGIN CERTIFICATE-----
     MIID0jCCArqgAwIBAgIBATANBgkqhkiG9w0BAQUFADBXMQswCQYDVQQGEwJVUzEO
     MAwGA1UECBMFVW5zZXQxDjAMBgNVBAcTBVVuc2V0MQ4wDAYDVQQKEwVVbnNldDEY
     MBYGA1UEAxMPd3d3LmV4YW1wbGUuY29tMB4XDTEzMDczMDAyMzExOFoXDTIzMDcy
     ODAyMzExOFowRzELMAkGA1UEBhMCVVMxDjAMBgNVBAgTBVVuc2V0MQ4wDAYDVQQK
     EwVVbnNldDEYMBYGA1UEAxMPd3d3LmV4YW1wbGUuY29tMIIBIjANBgkqhkiG9w0B
     AQEFAAOCAQ8AMIIBCgKCAQEAwreCaU52mvHbh0McuWScWZYw07DapLHTO06grvak
     Y/hA0UcS4Fc5daQBwgitnTDeBm/Y66J/bNaeDogejP/Vu9Xlh/5hbD8wF+viMLDJ
     1xAWuhKKhrrHtpFgi3GQMFL7/atP5q6RsmHgwkToLqNAnJKH9P1iHSR68AqWac9f
     XFEmcX5AaoTv3e3l7SNyR3fCDDLRC2sQGeMoCf8ZP4vI9NQfUXPiUQqwj3kT9yvW
     kaEwc7oh/qbgWtWSCnkyeQlsK5LEd8IQeFToEnsQQP7zGrQpWkg/F7b/PkqxZtE9
     91gKgr8i6X7XXCFPeQoFF/3fxFJcdK69sfi6beePJURqRwIDAQABo4G4MIG1MAkG
     A1UdEwQCMAAwHQYDVR0OBBYEFFExSDhe53ruc46Qu28ts+YX27laMIGIBgNVHSME
     gYAwfoAUR381RLbk/enNJB5s7UxFli11yiihW6RZMFcxCzAJBgNVBAYTAlVTMQ4w
     DAYDVQQIEwVVbnNldDEOMAwGA1UEBxMFVW5zZXQxDjAMBgNVBAoTBVVuc2V0MRgw
     FgYDVQQDEw93d3cuZXhhbXBsZS5jb22CCQCpnXwodrDroDANBgkqhkiG9w0BAQUF
     AAOCAQEAPMD0lMK9Wny/3wnoUzi28nr8g1XTerjY0rAY2bErq3m5SoU43mug88bM
     g8OP+/c5Iw55apxX/A4cTeMKvb3XgDwaoTPEJUquxrIQXP3yIE/vx0RyZnyOa3Il
     AhYrIHT0Dut0UibbqTnrGUyQ3yQ8H5bS4RD1zid0K5X4OBsI/yuW6G8KGuvujYiA
     i5GstVuhXRbDy48mJBQTsOtnWBwvOd933Dc37/8OQEgMgBGUKR+EFESaCJZi9oSE
     8llz7BQJYvBvnP6ZhYh6+RO6qaX51TDrJmMMxw+OtxCgMF9AGc7ipO21LFcWNxb1
     +Vs90BE8R5FvmaWb2byRerwWJci1CA==
     -----END CERTIFICATE-----


### Token Revocation List
The key use cases we need to cover:

- Retrieve a cryptographically signed list of non-expired
 token ids that have been revoked.  The CMS based PKI tokens, these will be
 the short form of the ID generated by a hash of the cryptographically signed
 token.

#### List revoked tokens: `GET OS-PKI/revoked_tokens`

Response:

    Status: 200 OK
    Content-Type: text/plain

    -----BEGIN CMS-----
    MIICWgYJKoZIhvcNAQcCoIICSzCCAkcCAQExCTAHBgUrDgMCGjBpBgkqhkiG9w0B
    BwGgXARaeyJyZXZva2VkIjpbeyJpZCI6IjdhY2ZjZmRhZjZhMTRhZWJlOTdjNjFj
    NTk0N2JjNGQzIiwiZXhwaXJlcyI6IjIwMTItMDgtMTRUMTc6NTg6NDhaIn1dfQ0K
    MYIByjCCAcYCAQEwgaQwgZ4xCjAIBgNVBAUTATUxCzAJBgNVBAYTAlVTMQswCQYD
    VQQIEwJDQTESMBAGA1UEBxMJU3Vubnl2YWxlMRIwEAYDVQQKEwlPcGVuU3RhY2sx
    ETAPBgNVBAsTCEtleXN0b25lMSUwIwYJKoZIhvcNAQkBFhZrZXlzdG9uZUBvcGVu
    c3RhY2sub3JnMRQwEgYDVQQDEwtTZWxmIFNpZ25lZAIBETAHBgUrDgMCGjANBgkq
    hkiG9w0BAQEFAASCAQC2f05VHM7zjNT3TBO80AmZ00n7AEWUjbFe5nqIM8kWGM83
    01Bi3uU/nQ0daAd3tqCmDL2EfETAjD+xnIzjlN6eIA74Vy51wFD/KiyWYPWzw8mH
    WcATHmE4E8kLdt8NhUodCY9TCFxcHJNDR1Eai/U7hH+5O4p9HcmMjv/GWegZL6HB
    Up9Cxu6haxvPFmYylzM6Qt0Ad/WiO/JZLPTA4qXJEJSa9EMFMb0c2wSDSn30swJe
    7J79VTFktTr2djv8KFvaHr4vLFYv2Y3ZkTeHqam0m91vllxLZJUP5QTSHjjY6LFE
    5eEjIlOv9wOOm1uTtPIq6pxCugU1Wm7gstkqr55R
    -----END CMS-----

The data is in crypto message syntax.  The encrypted data is a JSON document
that has been signed by the keystone servers signing certificate.
Referenced IDs
    {"revoked":[
        {"id":"7acfcfdaf6a14aebe97c61c5947bc4d3"}]}
