OpenStack Identity API v3 Key Distribution Service Extension
============================================================

A Key Distribution Server is an integral part of the implementation of RPC message security.

Assigning keys to services and handling groups of services
means assigning an identity to these services.

The principal advantage of using a key server compared to a pure public
key based system is that the encryption and signing key exchange can be
regulated by the key server and it can apply access control and deny
communication between arbitrary peers in the system. This allows for
centralized access control, prevents unauthorized communication and
avoids the need to perform post-authentication access control and policy
look-ups on the receiving side.

API Considerations
------------------

The Key Distribution Server (KDS) requires that all ticket requests are
authenticated and data is encrypted where appropriate.

The default algorithms for message authentication and encryption are
respectively HMAC-SHA-256 and AES-128-CBC. Therefore the default block
size is 128bit.

CRUD operations
---------------

#### Create Ticket: `POST /v1/keys`

A ticket is created to facilitate messaging between a `source` and a `destination`.
A request is authenticated by the source and verified by the KDS.
To avoid replay attacks, a timestamp and a nonce are necessary.

A ticket request comprises a metadata object and a signature.

Metadata:

Serialized JSON array including the following attributes:

 - `source` - the identity requesting a ticket
 - `destination` - the target for which the ticket will be valid
 - `timestamp` - UTC time string in ISO 8601 extended format date time with microseconds
 - `nonce` - random single use data

Signature:

Base64encode(HMAC(Key, 'metadata'))

The key is derived by the source's long term key.

See key derivation chapter in the MessageSecurity document
[here](https://wiki.openstack.org/wiki/MessageSecurity#Key_Derivation)

The response always returns a triplet of metadata, encrypted ticket and
signature.

Metadata:

Serialized JSON array including the following attributes:

 - `source` - the identity of the requestor
 - `destination` - the target for which the ticket is valid
 - `expiration` - UTC time string in ISO 8601 extended format date time with microseconds

Ticket:

The ticket is encrypted with the requestor EncryptionKey and includes the
following attributes.

 - `skey`: Message Signing Key
 - `ekey`: Message Encryption Key
 - `esek`: encrypted SEK pair for the receiver (base64 encoded)

The `esek` is encrypted with the target's key and contains a JSON serialized
array containing the following attributes:

 - `key`: The base64 encoded key used for encrypting data.
 - `timestamp`: UTC time string in ISO 8601 extended format date time with microseconds of when the key was created.
 - `ttl`: An integer containing the validity length of the key in seconds.

Signature:

An HMAC Signature over the concatenation of metadata and ticket
Base64encode(HMAC(SigningKey, 'metadata' + 'ticket'))
The Key is derived from the requestor long term key.


Request:

    {
        "metadata": Base64encode({
            "source": "scheduler.host.example.com",
            "destination": "compute.host.example.com",
            "timestamp": "2012-03-26T10:01:01.720000",
            "nonce": 1234567890
        }),
        "signature": "c2lnbmF0dXJl..."
    }

Response:

    Status: 200 OK

    {
        "metadata": Base64encode({
            "source": "scheduler.host.example.com:1",
            "destination": "compute.host.example.com:1",
            "expiration": "2012-03-26T11:01:01.720000"
        }),
        "ticket": "ZW5jcnlwdGVkIHRpY2tldA==",
        "signature": "c2lnbmF0dXJl..."
    }


#### Set Key: `PUT /v1/keys/{name}`

Store service keys in the KDS.

The request resource name is the owner of the key, and the body consists of
just the key.

 - `key` - a key (by default a 128 bit long cryptographic random key)

Request:

    {
        "key": "TXkgcHJlY2lvdXNzcy4u..."
    }

Response:

    Status: 200

    {
        "name": "--key-name--",
        "generation": 2
    }


#### Remove Key: `DELETE /v1/keys/{name}`

Remove a key from KDS.

The request body is empty.

Response:

    Status: 204 No Content



#### Retrieve Group Key: `POST /v1/groups`

If a group exists, a group key is generated and is valid for a predetermined
amount of time. Any member of the group can request the key as long as it
is still valid. Keys are deleted from the database when they expire.
Group Keys are necessary to verify signatures of messages that have a group
name as target.

A group key request is identical to a ticket request except the target is
a group name instead of a hostname.

A group key request comprises a metadata object and a signature.

Metadata:

Serialized JSON array including the following attributes:
 - `source` - the identity requesting a ticket
 - `destination` - the target for which the ticket will be valid
 - `timestamp` - UTC time string in ISO 8601 extended format date time with microseconds
 - `nonce` - random single use data

Signature:

Base64encode(HMAC(Key, metadata))

The Key is derived from the requestor long term key.

The Response always returns a triplet of metadata, encrypted group key and
signature.

Metadata:

Serialized JSON array including the following attributes:

 - `source` - the identity of the requestor
 - `destination` - the target for which the ticket is valid
 - `expiration` - UTC time string in ISO 8601 extended format date time with microseconds

Group key:

The group key is encrypted with the requestor key.

Signature:
An HMAC Signature over the concatenation of metadata and ticket
Base64encode(HMAC(SigningKey, 'metadata' + 'group key'))
The Key is derived from the requestor long term key.


Request:

    {
        "metadata": Base64encode({
            "source": "api.host.example.com",
            "destination": "scheduler",
            "timestamp": "2012-03-26T10:01:01.720000",
            "nonce": 987654321
        }),
        "signature": "c2lnbmF0dXJl"
    }

Response:

    Status: 200 OK

    {
        "metadata": Base64encode({
            "source": "api.host.example.com:1",
            "destination": "scheduler:3",
            "expiration": "2012-03-26T11:01:01.720000"
        }),
        "group_key": "ZW5jcnlwdGVkIGdyb3VwIGtleQ==",
        "signature": "c2lnbmF0dXJl"
    }



#### Create Group: `PUT /OS-KDS/groups/{name}`

Create a group in the KDS.
Membership in groups is based on the member name.
The group named `scheduler` will implicitly include any name starting with
`scheduler.` as a member (e.g. scheduler.host.example.com).

The request body is empty.

Response:

    Status: 200 OK

    {
        "name": "--name--"
    }


#### Remove Group: `DELETE /OS-KDS/groups/{name}`

Remove a group from KDS.

The request body is empty.

Response:

    Status: 204 No Content



### Error codes

    200 OK - This status code is returned in response to a successful request
    204 No Content - Operation Succesful but no content body is returned
    400 Bad Request If the body of the request does not result in the
        signature passed in the URL
    401 Unauthorized - This status code is returned when either authentication
        has not been performed, or the authentication fails.
    403 Forbidden - This status code is returned when the requester field does
        not match either the sender or the receiver fields.
    500 Internal Service Error - May be raised in certain situations where
        there is an internal cryptographic failure.
