OpenStack Identity API v3 Key Distribution Service Extension
============================================================

Key Distribution Server (KDS) serves as a trusted third party that is
responsible for generation and secure distribution of signing and
encryption keys to communicating parties. These shared keys allow
messages to be exchanged between communicating parties with message
authentication, integrity and confidentiality. KDS is an integral part
of the implementation of RPC message security.

To establish a trusted relationship between a communicating party and
KDS, a long term shared key needs to be assigned to the party by a
properly authorized user, such as a cloud administrator. Assigning a key
to a party requires assigning an identity to that party in KDS. An
identity is comprised of a unique party name and the long term shared
key that it is associated with. This party name is used to identify a
party when it communicates with KDS or another party.

KDS is designed to enable secure messages to be exchanged between two
individual parties as well as between one individual party and a group
party. When a party wants to obtain keys to be used for communication
with another party, it makes an authenticated request to KDS for a
ticket. KDS returns a ticket to the requesting party that is encrypted
with the long term shared key that is associated with that party. This
encryption ensures that the ticket can only be decrypted by one who
possesses the long term key, which should only be the associated party
and KDS itself.

A ticket that has been issued by KDS contains a copy of the shared
encryption and signing keys. These keys are for the source party, which
is the party that requested the ticket. The ticket also contains a
payload that is intended for the destination party, which is the party
that the source party wants to communicate with. This payload contains
the information that is needed for the destination party to be able to
derive the shared encryption and signing keys. When the destination
party is an individual, the payload is encrypted with the long term
shared key that is associated with the destination party. When the
destination party is a group, the payload is encrypted with a shared
group key that KDS makes available to all members of the group. This
encryption allows the destination party to trust that the information in
the payload was supplied by KDS. When the source party is ready to
communicate with the destination party, it sends this encrypted payload
to the destination party along with whatever data it has protected with
the shared signing and encryption keys. The destination party can then
decrypt the payload and derive the shared encryption and signing keys
using the information in the payload. This results in both parties
having a copy of the shared signing and encryption keys that are trusted
as being issued by KDS. These shared keys can then be used by the
destination party to authenticate and decrypt the data sent by the
source party.

When a source party needs to send secure messages to multiple
recipients, an authorized user can define a group for those recipients
in KDS. Membership in a group is determined by comparing a party name
with the group name. If the name of a party matches ``<group name>.*``,
it is considered to be a member. For example, a party named
``scheduler.host.example.com`` would be considered a member of a group
named ``scheduler``. This matches up with the way that message queues
are named within OpenStack.

When a source party requests a ticket where the destination party is a
group, KDS generates a short-lived group key and assigns it to the
group. This group key is used to encrypt the payload in the ticket,
which contains the information that the destination party uses to derive
the shared signing and encryption keys. When an individual destination
party needs to decrypt the payload that it receives from the source
party as a part of a group message, it makes an authenticated request to
KDS to obtain the short-lived group key. If the requester is a member of
the target group, KDS provides the short-lived group key encrypted with
the long term shared key associated with the individual destination
party. The group key can then be decrypted by the individual destination
party, allowing it to decrypt the payload and derive the shared signing
and encryption keys that can be used to authenticate and decrypt the
data sent by the source party.

When keys are obtained to send a message to a group, it is important to
note that all members of the group and the sender share the signing and
encryption keys. This makes it impossible for an individual destination
party to determine if a message was truly sent by the source party or
another destination party who is a member of the group. The only
assurance that a destination party has is that a message was sent by a
party who has possession of the shared signing and encryption keys. This
requires that all parties within a group trust each other to not
impersonate the source party.

The signing and encryption keys that are shared between communicating
parties are short-lived. The lifetime of these keys is defined by an
validity period that is set by KDS when it issues the ticket. A
suggested reasonable default validity period is 15 minutes, though it is
left up to the implementation to determine the appropriate validity
period. Once the validity period for the keys expires, a party should
refuse to use those keys anymore to prevent using keys that may have
been compromised. This requires the source party to request a new ticket
from KDS to get a new set of keys. If desired, an implementation could
choose to implement a grace period to account for clock skew between
parties. This grace period would allow a destination party to accept
messages that use recently expired keys. If a grace period is used, it
is recommended that the duration be kept small, such as 5 minutes or
less.

The principal advantage of using a key server compared to a pure public
key based system is that the encryption and signing key exchange can be
regulated by the key server. Since the key server is actively involved
in distributing keys to the communicating parties, it has the ability to
apply access control and deny communication between arbitrary peers in
the system when keys are requested. This allows for centralized access
control, prevents unauthorized communication and avoids the need to
perform post-authentication access control and policy look-ups on the
receiving side.

API Considerations
------------------

The Key Distribution Server (KDS) requires that all ticket requests are
authenticated and data is encrypted where appropriate.

All timestamp values used in the API must be specified as a UTC ISO 8601
extended format date/time string that includes microseconds. An example
of a properly formatted timestamp is ``2012-03-26T10:01:01.720000``.

The default algorithms for message authentication and encryption are
respectively HMAC-SHA-256 and AES-128-CBC. Therefore the default block
size is 128bit.

The source party that obtains a ticket is responsible for sending the
encrypted payload ``esek`` to the destination party. The source and
destination strings used when requesting the ticket also need to be sent
to the destination party to allow it to derive the shared signing end
encryption keys. Transferring this data to the destination party is
handled outside of the API described in this document, as it's expected
to be performed by the messaging implementation.

The key derivation used to generate the shared signing and encryption
keys uses the Hashed Message Authentication Code (HMAC)-based key
derivation function (HKDF) standard as described in RFC 5869. The
destination party needs to use the HKDF ``expand`` function using the
information that it receives from the source party in order to complete
derivation of the shared signing and encryption keys. The inputs to the
HKDF ``expand`` function are as follows:

::

    HKDF-Expand(esek.key, info, 256)

The ``info`` input for the HKDF ``expand`` function is a string that
concatenates the source, destination, and ``esek.timestamp`` strings
using a ``,`` separator between each element. An example of a valid
``info`` string where ``scheduler.host.example.com`` is the source,
``compute.host.example.com`` is the destination, and
``2012-03-26T10:01:01.720000`` is the ``esek.timestamp`` is as follows:

::

    scheduler.host.example.com,compute.host.example.com,2012-03-26T10:01:01.720000

The output of the HKDF expand function is an array of bytes of 256 bit
length. The first half is used as the signing key, and the second half
is used as the encryption key.

The requests to create and delete long term keys should be restricted
such that only a properly authorized user, such as a cloud administrator
is allowed to successfully perform the operations. The authentication
and authorization for these requests is left up to the implementation,
though it expected that one would leverage the Identity API for these
purposes.

Resources and Operations
------------------------

Create Key
^^^^^^^^^^

::

    PUT /v1/keys/{name}

Create a long term key in the KDS.

Request
'''''''

The request resource name is the party associated with the key, and the
body consists of just the key.

-  ``key`` - A base64 encoded 128 bit long cryptographic random key.

   { "key": "TXkgcHJlY2lvdXNzcy4u..." }

Response
''''''''

The response contains a name and generation value. The generation value
will only be changed if a new key is set. If the request sets the key to
the same value that already exists, the existing generation value will
be returned in the response. This makes the request idempotent.

-  ``name`` - The party name associated with the key.
-  ``generation`` - A unique integer used to identify the key.

   Status: 201 Created Location: /v1/keys/--key-name--

   { "name": "--key-name--", "generation": 2 }

Delete Key
^^^^^^^^^^

::

    DELETE /v1/keys/{name}

Delete a key from KDS.

Request
'''''''

The request body is empty.

Response
''''''''

::

    Status: 204 No Content

Generate Ticket
^^^^^^^^^^^^^^^

::

    POST /v1/tickets

A ticket is generated to facilitate messaging between a ``source`` and a
``destination``.

Request
'''''''

A generate ticket request comprises metadata supplied as a base64
encoded JSON object and a signature.

::

    {
        "metadata": "Zhn8yhasf8hihkf...",
        "signature": "c2lnbmF0dXJl..."
    }

Metadata:

A base64 encoded JSON object containing the following key/value pairs:

-  ``source`` - The identity requesting a ticket.
-  ``destination`` - The target for which the ticket will be valid.
-  ``timestamp`` - Current timestamp from the requester.
-  ``nonce`` - Random single use data.

A timestamp and a nonce are necessary to avoid replay attacks.

::

    {
        "source": "scheduler.host.example.com",
        "destination": "compute.host.example.com",
        "timestamp": "2012-03-26T10:01:01.720000",
        "nonce": 1234567890
    }

Signature:

A base64 encoded HMAC Signature over the base64 encoded request metadata
object.

::

    Base64encode(HMAC(SigningKey, RequestMetadata))

The key used for the signature is the requester's long term key. The KDS
should verify the signature upon receipt of the request. This requires
that the KDS access the ``source`` from the request metadata in order to
lookup the associated long term key that can be used to verify the
signature. The KDS should not access any other data contained in the
request metadata before verifying the signature. Failure to verify the
signature leaves the KDS open to issuing a ticket to a party that is
impersonating the source.

Response
''''''''

The response always returns a triplet of metadata, encrypted ticket and
signature.

::

    Status: 200 OK

    {
        "metadata": "Zhn8yhasf8hihkf...",
        "ticket": "ZW5jcnlwdGVkIHRpY2tldA==",
        "signature": "c2lnbmF0dXJl..."
    }

Metadata:

A base64 encoded JSON object containing the following key/value pairs:

-  ``source`` - The identity of the requester.
-  ``destination`` - The target for which the ticket is valid.
-  ``expiration`` - Timestamp of when the ticket expires.

   { "source": "scheduler.host.example.com", "destination":
   "compute.host.example.com", "expiration":
   "2012-03-26T11:01:01.720000" }

Ticket:

The ticket is encrypted with the source's long term key and contains a
base64 encoded JSON object containing the following key/value pairs:

-  ``skey`` - The newly generated base64 encoded message signing key.
-  ``ekey`` - The newly generated base64 encoded message encryption key.
-  ``esek`` - Encrypted signing and encryption key pair for the
   receiver.

   { "skey": "ZjhkuYZH8y87rzhgi7..." "ekey": "Fk8yksa8z8zKtakc8s..."
   "esek": "KBo8fajfo8ysad5hq2..." }

The ``esek`` is encrypted with the destination's long term key and
contains a base64 encoded JSON object containing the following key/value
pairs:

-  ``key`` - The base64 encoded random key used to derive the signing
   and encryption keys.
-  ``timestamp`` - Timestamp of when the key was created.
-  ``ttl`` - An integer containing the validity length of the key in
   seconds.

   { "key": "Afa8sad2hgsd7asv7ad..." "timestamp":
   "2012-03-26T10:01:01.720000" "ttl": 28800 }

The ``key`` and ``timestamp`` are used as inputs to the HKDF ``expand``
function to derive the signing and encryption keys as described in the
``API Considerations`` section of this document.

The ``timestamp`` plus ``ttl`` should be equivalent to the
``expiration`` timestamp contained in the response metadata.

Signature:

A base64 encoded HMAC signature over the concatenation of the base64
encoded response metadata object and base64 encoded ticket object.

::

    Base64encode(HMAC(SigningKey, ResponseMetadata + Ticket))

The key used for the signature is the requester's long term key. The
requester should verify the signature upon receipt of the response
before accessing any data contained in the response metadata or the
ticket. Failure to verify the signature leaves the requester open to
using metadata that was not actually issued by the KDS.

Create Group
^^^^^^^^^^^^

::

    PUT /v1/groups/{name}

Create a group in the KDS.

Membership in groups is based on the party name. For example, a group
named ``scheduler`` will implicitly include any party name starting with
``scheduler.`` as a member (e.g. scheduler.host.example.com).

Request
'''''''

The request body is empty.

Response
''''''''

The response returns the group name from the request.

::

    Status: 201 Created
    Location: /v1/groups/--group-name--

    {
        "name": "--group-name--"
    }

Delete Group
^^^^^^^^^^^^

::

    DELETE /v1/groups/{name}

Delete a group from the KDS.

Request
'''''''

The request body is empty.

Response
''''''''

::

    Status: 204 No Content

Retrieve Group Key
^^^^^^^^^^^^^^^^^^

::

    POST /v1/groups

When a ticket is requested where the destination is a group, a group key
is generated that is valid for a predetermined amount of time. Any
member of the group can retrieve the key as long as it is still valid.
Group keys are necessary to verify signatures and decrypt messages that
have a group name as the target.

Request
'''''''

A group key retrieval request is identical to a generate ticket request
except the destination is a group name instead of an individual party
name.

Response
''''''''

The response always returns a triplet of metadata, encrypted group key
and signature.

::

    Status: 200 OK

    {
        "metadata": "Zhn8yhasf8hihkf...",
        "group_key": "ZW5jcnlwdGVkIGdyb3VwIGtleQ==",
        "signature": "c2lnbmF0dXJl"
    }

Metadata:

A base64 encoded JSON object containing the following key/value pairs:

-  ``source`` - The identity of the requester.
-  ``destination`` - The target for which the ticket is valid.
-  ``expiration`` - Timestamp of when the ticket expires.

   { "source": "api.host.example.com", "destination": "scheduler",
   "expiration": "2012-03-26T11:01:01.720000" }

Group key:

The group key is encrypted with the requester's long term key.

Signature:

A base64 encoded HMAC signature over the concatenation of the base64
encoded response metadata object and the group key.

::

    Base64encode(HMAC(SigningKey, ResponseMetadata + GroupKey))

The key used for the signature is the requester's long term key. The
requester should verify the signature upon receipt of the response
before accessing any data contained in the response metadata or the
group key. Failure to verify the signature leaves the requester open to
using data that was not actually issued by the KDS.

HTTP Status Codes
~~~~~~~~~~~~~~~~~

KDS uses the following HTTP status codes to communicate specific success
and failure conditions to the client.

200 OK
^^^^^^

This status code is returned in response to a successful ``POST``
request to generate a ticket or a retrieve a group key.

201 Created
^^^^^^^^^^^

This status code is returned in response to a successful ``PUT`` request
to create a group or long term key.

204 No Content
^^^^^^^^^^^^^^

This status code is returned in response to a successful ``DELETE``
request to delete a group or long term key. No content body is returned.

401 Unauthorized
^^^^^^^^^^^^^^^^

This status code is returned when either authentication has not been
performed, or authentication fails.

403 Forbidden
^^^^^^^^^^^^^

This status code is returned when the requester field does not match
either the sender or the receiver fields, or if the body of the request
does not result in the supplied signature.

404 Not Found
^^^^^^^^^^^^^

This status code is returned in response to a failed ``DELETE`` request
when a referenced entity cannot be found. It is also returned when a
``POST`` request is made where the destination party specified in the
request does not exist.
