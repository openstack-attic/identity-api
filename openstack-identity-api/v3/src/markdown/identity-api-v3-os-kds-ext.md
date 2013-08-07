OpenStack Identity API v3 Key Distribution Service Extension
============================================================

The Key Distribution Server (KDS) is an integral part of the implementation of
RPC message security.  KDS serves as a trusted third party that is responsible
for generation and secure distribution of signing and encryption keys to
communicating parties.  These shared keys allow messages to be exchanged
between communicating parties with message authentication, integrity and
confidentiality.

To establish a trusted relationship between a service and KDS, a long term
shared key needs to be assigned to the service.  Assigning a key to a service
requires assigning an identity to the service in KDS.  An identity is comprised
of a service name and the long term shared key that it is associated with.

When a service wants to obtain keys to be used for communication with another
party, it makes an authenticated request to KDS for a ticket.  KDS returns
a ticket to the service that is encrypted with the long term shared key that
is associated with the service.  This encryption ensures that the ticket can
only be decrypted by one who possesses the long term key, which should only be
the associated service and KDS itself.

A ticket that has been issued by KDS contains a copy of shared encryption
and signing keys.  These keys are for the source party, which is the service
that requested the ticket.  The ticket also contains a payload that is intended
for the destination party, which is the service that the source party wants to
communicate with.  This payload contains the information that is needed for the
destination to derive the share encryption and signing keys, and it is
encrypted by KDS with the long term shared key that is associated with the
destination party.  This encryption allows the destination party to trust that
the information was supplied by KDS.  When the source party is ready to
communicate with the destination party, it sends this encrypted payload to the
destination party.  The destination party can then decrypt the payload using
it's long term shared key, and derive the shared encryption and signing keys
using the information in the payload.  This results in both parties having a
copy of the shared signing and encryption keys that are trusted as being issued
by KDS.  These shared keys can then be used to authenticate and encrypt
messages between the two parties.

The signing and encryption keys that are shared between services are
short-lived.  The lifetime of these keys is defined by an validity period that
is set by KDS when it issues the ticket.  Once the validity period for the keys
expires, a service should refuse to use those keys anymore.  This requires a
service to request a new ticket from KDS to get a new set of keys.

When a service needs to send secure messages to multiple recipients, groups
can be defined in KDS.  A group is a list of member services.  When a service
requests a ticket where the destination party is a group, KDS generates a
short-lived group key and assigns it to the group.  This group key is used to
encrypt the destination group's copy of the shared signing and encryption keys
in the ticket.  When a destination service needs to decrypt the shared signing
and encryption keys that it receives from the source party, it makes an
authenticated request to KDS to obtain the short-lived group key.

The principal advantage of using a key server compared to a pure public key
based system is that the encryption and signing key exchange can be regulated
by the key server.  Since the key server is actively involved in distributing
keys to the communicating parties, it has the ability to apply access control
and deny communication between arbitrary peers in the system when keys are
requested. This allows for centralized access control, prevents unauthorized
communication and avoids the need to perform post-authentication access control
and policy look-ups on the receiving side.

API Considerations
------------------

The Key Distribution Server (KDS) requires that all ticket requests are
authenticated and data is encrypted where appropriate.

All timestamp values used in the API must be specified as a UTC ISO 8601
extended format date/time string that includes microseconds.  An example of a
properly formatted timestamp is `2012-03-26T10:01:01.720000`.

The default algorithms for message authentication and encryption are
respectively HMAC-SHA-256 and AES-128-CBC. Therefore the default block
size is 128bit.

The service that obtains a ticket is responsible for sending the encrypted
payload `esek` to the destination party.  The source and destination strings
used when requesting the ticket also need to be sent to the destination party
to allow it to derive the shared signing end encryption keys.  Transferring
this data to the destination party is handled outside of the API described in
this document, as it's expected to be performed by the messaging
implementation.

The key derivation used to generate the shared signing and encryption keys uses
the Hashed Message Authentication Code (HMAC)-based key derivation function
(HKDF) standard as described in RFC 5869.  The destination party needs to use
the HKDF expand function using the information that it receives from the source
party in order to complete derivation of the shared signing and encryption
keys.  The inputs to the HKDF expand function are as follows:

    HKDF-Expand(esek.key, source, destination, esek.timestamp, 256)

The output of the HKDF expand function is an array of bytes of 256 bit length.
The first half is used as the signing key, and the second half is used as the
encryption key. 

CRUD operations
---------------

#### Create Ticket: `POST /v1/keys`

A ticket is created to facilitate messaging between a `source` and a
`destination`.  A request is authenticated by the source and verified by the
KDS.  To avoid replay attacks, a timestamp and a nonce are necessary.

A ticket request comprises a metadata object and a signature.

Request metadata:

Serialized JSON object containing the following key/value pairs:

 - `source` - The identity requesting a ticket.
 - `destination` - The target for which the ticket will be valid.
 - `timestamp` - Current timestamp from the requestor.
 - `nonce` - Random single use data.

Signature:

Base64encode(HMAC(Key, 'metadata'))

The key is derived by the source's long term key.

See key derivation chapter in the MessageSecurity document
[here](https://wiki.openstack.org/wiki/MessageSecurity#Key_Derivation)

The response always returns a triplet of metadata, encrypted ticket and
signature.

Response metadata:

Serialized JSON object containing the following key/value pairs:

 - `source` - The identity of the requestor.
 - `destination` - The target for which the ticket is valid.
 - `expiration` - Timestamp of when the ticket expires.

Ticket:

The ticket is encrypted with the requestor's long term key and contains a
serialized JSON object containing the following key/value pairs:

 - `skey`: Message Signing Key
 - `ekey`: Message Encryption Key
 - `esek`: encrypted SEK pair for the receiver (base64 encoded)

The `esek` is encrypted with the target's key and contains a serialized JSON
object containing the following key/value pairs:

 - `key`: The base64 encoded random key used to derive the signing and encryption keys.
 - `timestamp`: Timestamp of when the key was created.
 - `ttl`: An integer containing the validity length of the key in seconds.

Signature:

An HMAC Signature over the concatenation of metadata and ticket:

    Base64encode(HMAC(SigningKey, 'metadata' + 'ticket'))

The key used for the signature is the requestor's long term key.  The requestor
should verify the signature upon receipt of the response.

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

 - `key` - A base64 encoded 128 bit long cryptographic random key.

The response contains a name and generation value.

 - `name` - The service name associated with the key.
 - `generation` - A unique integer used to identity the key.

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
amount of time. Any member of the group can request the key as long as it is
still valid. Keys are deleted from the database when they expire.  Group keys
are necessary to verify signatures of messages that have a group name as the
target.

A group key request is identical to a ticket request except the target is a
group name instead of a hostname.

A group key request comprises a metadata object and a signature.

Metadata:

Serialized JSON object containing the following key/value pairs:

 - `source` - The identity requesting a ticket.
 - `destination` - The target group for which the ticket will be valid.
 - `timestamp` - Current timestamp from the requestor.
 - `nonce` - Random single use data.

Signature:

Base64encode(HMAC(Key, metadata))

The key is derived from the requestor's long term key.

The response always returns a triplet of metadata, encrypted group key and
signature.

Metadata:

Serialized JSON object containing the following key/value pairs:

 - `source` - The identity of the requestor.
 - `destination` - The target for which the ticket is valid.
 - `expiration` - Timestamp of when the ticket expires.

Group key:
The group key encrypted with the requestor's key.

Signature:
An HMAC Signature over the concatenation of metadata and ticket
Base64encode(HMAC(SigningKey, 'metadata' + 'group key'))
The key is derived from the requestor's long term key.

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

The response returns the service name from the request.

Response:

    Status: 200 OK

    {
        "name": "--name--"
    }


#### Remove Group: `DELETE /OS-KDS/groups/{name}`

Remove a group from the KDS.

The request body is empty.

Response:

    Status: 204 No Content


### Error codes

    200 OK - This status code is returned in response to a successful request.
    204 No Content - This status code is returned in response to a successful
        request, but no content body is returned.
    400 Bad Request - This status code is returned if the body of the request
        does not result in the signature passed in the URL.
    401 Unauthorized - This status code is returned when either authentication
        has not been performed, or authentication fails.
    403 Forbidden - This status code is returned when the requester field does
        not match either the sender or the receiver fields.
    500 Internal Service Error - This status code is returned when an unexpected
        error has occurred in the KDS implementation.
