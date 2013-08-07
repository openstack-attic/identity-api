OpenStack Identity API v3 Key Distribution Service Extension
============================================================

A Key Distribution Server is used to implement Message Security as defined
in [this document](https://wiki.openstack.org/wiki/MessageSecurity).

Assigning Keys to services and handling groups of services effectively
means assigning an identity to these services.

The principal advantage of using a Key Server compared to a pure public
key based system is that the Encryption and Signing Key exchange can be
regulated by the Key Server and it can apply access control and deny
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

The KDS supports 5 operations:

 - Getting the KDS version string
 - Requesting a Ticket
 - Requesting a group Key
 - Setting a Service Key
 - Creating a Group

#### Info Request: `GET /kds`

Returns a version string.

 - `version` (String) the protocol version number

Response:

    {
        "version": "0.0.1"
    }


#### Ticket Request: `POST /OS-KDS/ticket/{signature}`

A ticket is released to a requestor and is specific for a target.
A request is authenticated by the requestor and verified by the KDS.
To avoid replay attacks, a timestamp and a nonce are necessary.

A Ticket request comprises a metadata object and a signature.

Metadata:

Serialized JSON array including the following attributes:

 - `requestor` - the identity requesting a ticket
 - `target` - the target for which the ticket will be valid
 - `timestamp` - 1/100Th second resolution from UTC
 - `nonce` - 64bit unsigned number, timestamp+nonce must never repeat

Signature:

Base64encode(HMAC(Key, 'metadata'))

The Key is derived by the requestor long term key.

See Key_derivation Chapter in the MessageSecurity document
[here](https://wiki.openstack.org/wiki/MessageSecurity#Key_Derivation)

The Response always returns a triplet of metadata, encrypted ticket and
signature.

Metadata:

Serialized JSON array including the following attributes:

 - `source` - the identity of the requestor
 - `destination` - the target for which the ticket is valid
 - `expiration` - 1/100Th second resolution in seconds from UTC (as returned by time.time()

Ticket:

The ticket is encrypted with the requestor EncryptionKey and includes the
following attributes.

 - `skey`: Message Signing Key
 - `ekey`: Message Encryption Key
 - `esek`: encrypted SEK pair for the receiver (base64 encoded)

Signature:

An HMAC Signature over the concatenation of metadata and ticket
Base64encode(HMAC(SigningKey, 'metadata' + 'ticket'))
The Key is derived from the requestor long term key.


Request:

    {
        "metadata": base64.b64encode({
            "requestor": 'scheduler.host.example.com',
            "target": 'compute.host.example.com',
            "timestamp": 1332720061.72,
            "nonce": 1234567890
        }),
        "signature": 'c2lnbmF0dXJl...'
    }

Response:

    Status: 200 OK

    {
        "metadata": base64.b64encode({
            "source": 'scheduler.host.example.com',
            "destination": 'compute.host.example.com',
            "expiration": 1332723661.72
        }),
        "ticket": 'ZW5jcnlwdGVkIHRpY2tldA==',
        "signature": 'c2lnbmF0dXJl...'
    }


#### Group Key Request: `POST /OS-KDS/group_key/{name:generation}`

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
 - `requestor` - the identity requesting a ticket
 - `target` - the target for which the ticket will be valid
 - `timestamp` - 1/100Th second resolution from UTC
 - `nonce` - 64bit unsigned number, timestamp+nonce must never repeat

Signature:

Base64encode(HMAC(Key, 'metadata'))

The Key is derived by the requestor long term key.

The Response always returns a triplet of metadata, encrypted group key and
signature.

Metadata:

Serialized JSON array including the following attributes:

 - `source` - the identity of the requestor
 - `destination` - the target for which the ticket is valid
 - `expiration` - 1/100Th second resolution from UTC

Group_key:

The group_key is encrypted with the requestor key.

Signature:
An HMAC Signature over the concatenation of metadata and ticket
Base64encode(HMAC(SigningKey, 'metadata' + 'group_key'))
The Key is derived from the requestor long term key.


Request:

    {
        "metadata": base64.b64encode({
            "requestor": 'api.host.example.com',
            "target": 'scheduler:3',
            "timestamp": 1332720061.72,
            "nonce": 987654321
        }),
        "signature": 'c2lnbmF0dXJl...'
    }

Response:

    Status: 200 OK

    {
        "metadata": base64.b64encode({
            "source": 'api.host.example.com',
            "destination": 'scheduler:3',
            "expiration": 1332723661.72
        }),
        "group_key": 'ZW5jcnlwdGVkIGdyb3VwIGtleQ==',
        "signature": 'c2lnbmF0dXJl...'
    }


#### Set Key Request: `PUT /OS-KDS/key/{owner}`

The set_key request is used to store service keys in the KDS.
Keys are encrypted with the KDS master key before being stored in the database.
Set key operations are authenticated using keystone tokens; see keystone API
for the details.
This operation is not encrypted or signed in any way so it should be
performed through on a secure channel (HTTPS).

The request resource name is the owner of the key, and the body consists of
just the key.

 - `key` - a key (by default a 128 bit long cryptographic random key)

Request:

    {
        "key": 'TXkgcHJlY2lvdXNzcy4u...'
    }

Response:

    Status: 200 OK


#### Create Group Request: `PUT /OS-KDS/group/{group_name}`

The create_group request is used to create a group in the KDS.
Create Group operations are authenticated using keystone; see Identity
API for the details.
Membership in groups is based on the member name.
The group named `scheduler` will implicitly include any name starting with
`scheduler.` as a member (e.g. scheduler.host.example.com).

The request body is empty.

Response:

    Status: 200 OK


#### Remove Group Request: `DELETE /OS-KDS/group/{group_name}`

The delete_group request is used to remove a group from KDS.
Delete Group operations are authenticated using keystone tokens; see keystone
API for the details.

The request body is empty.

Response:

    Status: 200 OK



### Error codes

    200 OK - This status code is returned in response to a successful request
    400 Bad Request If the body of the request does not result in the
        signature passed in the URL
    401 Unauthorized - This status code is returned when either authentication
        has not been performed, or the authentication fails.
    403 Forbidden - This status code is returned when the requester field does
        not match either the sender or the receiver fields.
    503 Service Unavailable - This status code is returned when the server is
        unable to communicate with a backend service (database, memcache, ...)

