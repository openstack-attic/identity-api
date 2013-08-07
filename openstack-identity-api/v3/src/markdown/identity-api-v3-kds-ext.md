OpenStack Identity API v3 Key Distribution Service Extension
============================================================

A cryptographic key management store for openstack.

Assigning Keys to services and handling group of services effectively means assigning an identity to these services. 

The principal advantage of using a Key Server compared to a pure public key based system is that the Encryption
and Signing Key exchange can be regulated by the Key Server and it can apply access control and deny communication
between arbitrary peers in the system. This allows to more easily perform centralized access control, prevent
unauthorized communication and avoid the need to perform post authentication access control and policy
lookups on the receiving side.

The standard for providing message integrity is HMAC. For encryption the most respected algorithm is currently
AES, a block cipher with a fixed 128bits block size.

Since encryption may not be necessary, it is option in this format.
 In order to avoid changing message formats in the future, this means it is more convenient to use an
 "encryption first, authentication later" approach, whereby the authentication step does not differ based
 on whether encryption is performed or not, rather the message being authenticated can be either plain text
 or encrypted.

API Resources
-------------

### Key


Required attributes:

- `metadata` (string)

  All of the data about the key that is not part of the key itself.  It contains the subfields:
    'source': identifier of the principal that sent the key,
    'destination': identifier of the principal that is expected to consume the key
    'timestamp': 1/100th second resolution from UTC
    'nonce': 64bit unsigned number, must not repeat until the timestamp changes
    'esek': encrypted SEK pair for the receiver (base64 encoded),
    'encryption': true | false
  

   `Version` (String) the protocol version number


'signature'(string) 
  
	Signature = HMAC(SignKey, (Version || MetaData || Message))
	HMAC-SHA-256 by  as per RFC 6234. 

Optional Attributes:
   Message Encryption: Boolean

    Optionally the message may be encrypted, in this case the MetaData field 'encryption' will be set to True.
    The nonce should be comparable to AES-128-CBC with a Random IV .

### Ticket 



Example entity:

{
    'reply': {
        'metadata': {
          'source': 'f01234',
          'destination': 'e01235',
          'expiration': '2013-02-27T18:30:59.999999Z',
        }
        'ticket': 'ab4321',
        'signature': 'de5432',
    }
}

#### PUT /kds/key/<name>

Store a Key
Request

{
        'version`: _RPC_ENVELOPE_VERSION,
        'metadata': {
          'source': 'f01234',
          'destination': 'e01235',
          'expiration': '2013-02-27T18:30:59.999999Z',
	      'nonce': <64bit unsigned number>, # must not repeat until the timestamp changes
    	  'esek': <encrypted SEK pair for the receiver (base64 encoded)>,
          'encryption': <true | false>
        }
    'Message': Message,
    'Signature': Signature
}



Response

200 OK




#### GET /kds/ticket/<name>

While it is unusual to have a body in an HTTP request, it is allowed.  The GET api uses the body
as the request parameters.  Due to the cryptographic nature of the signature algorithm, the body
cannot be transformed.  Thus, it is unacceptable to pass the metadata in request parameters.

Error codes

    200 OK - This status code is returned in response to a successful GET operation
    400 Bad Request If the body of the request does not result in the signature passed in the URL
    401 Unauthorized - This status code is returned when either authentication has not been performed, or the authentication fails.
    403 Forbidden - This status code is returned when the requester field does not match either the sender or the receiver fields.
    503 Service Unavailable - This status code is returned when the server is unable to communicate with a backend service (database, memcache, ...) 

Request

{
    'request': {
        'metadata': {
          'source': 'f01234',
          'destination': 'e01235',
          'expiration': '2013-02-27T18:30:59.999999Z',
        }
        'signature': 'de5432',
    }
}

Response

200 OK

{
    'reply': {
        'metadata': {
          'source': 'f01234',
          'destination': 'e01235',
          'expiration': '2013-02-27T18:30:59.999999Z',
        }
        'ticket': 'ab4321',
        'signature': 'de5432',
    }
}