OpenStack Identity API v3 Key Distribution Service Extension
============================================================

A cryptographic key management store for openstack.

Assigning Keys to services and handling group of services effectively means assigning an identity to these services. 

The principal advantage of using a Key Server compared to a pure public key based system is that the Encryption and Signing Key exchange can be regulated by the Key Server and it can apply access control and deny communication between arbitrary peers in the system. This allows to more easily perform cenralized access control, prevent unauthorized communication and avoid the need to perform post authentication access control and policy lookpus on the receiving side.
Given that otherwise the overhead for either a public key based system or a shared key based system in terms of security of the trusted server or communication requirements looks similar we put forward the proposal of using a Shared Key system based on a Key Server.
Note that the service long term key stored in Key Server may be used for derivation and may be used for authentication, however authentication to the Key Server can also be deferred to existing components, for example password based authentication over an HTTPS connection would be sufficient to authenticate a Service to the Key Server. Other methods that would work as well would be Kerberos keytabs and a KDC for authentication, x509 User Certificates and so on. Basically, the authentication to the key server part can be abstracted away if needed.

The KDS will aslo support authentication based on shared keys that will work for communication over pure HTTP (non encrypted) transport with the Key Server

The standard for providing message integrity is HMAC. For encryption the most respected algorithm is currently AES, a block cipher with a fixed 128bits block size.

Since encryption may not be necessary, it is option in this format.
 In order to avoid changing message formats in the future, this means it is more convenient to use an
 "encryption first, authentication later" approach, whereby the authentication step does not differ based
 on whether encryption is performed or not, rather the message being authenticated can be either plain text
 or encrypted.

The next step is sketching out how to apply encryption and authentication to the message keeping in mind the Horton Principle: "Authenticate what is being meant, not what is being said". 
Message Signature

The Signature is calculated over the concatenation of the version string and the buffers.

Version = null terminated string containing the version number
MetaData = serialized JSON Metadata
Message = serialized JSON Message

Signature = HMAC(SignKey, (Version || MetaData || Message))

We propose to use HMAC-SHA-256 by default as the authentication function as per RFC 6234. 

API Resources
-------------

### KDS 


Required attributes:

- `metadata` (string)

  All of the data about the key that is not part of the key itself.  It contains the subfields:
    'source': identifier of the principal that sent the key,
    'destination': identifier of the principal that is expected to consume the key
    'timestamp': 1/100th second resolution from UTC
    'nonce': 64bit unsigned number, must not repeat until the timestamp changes
    'esek': encrypted SEK pair for the receiver (base64 encoded),
    'encryption': true | false
  

- `ticket` (string)

  Represents..

- `ticket` (string)

  Represents..

'signature'(string) 
  
  Represents..

Optional Attributes:
   Message Encryption: Boolean

    Optionally the message may be encrypted, in this case the MetaData field 'encryption' will be set to True.

Because the use of nonces is particularly difficult to get right, and the use of message queues may involve multiple parties using the same keys when they act in a cluster and because there is a desire to allow as much as possible stateless services, we propose to use AES-128-CBC with a Random IV by default in order to encrypt the content. This requires the availability of a pseudo-random generator on the sender side, we do not expect this to be an issue in practice on the machines used in a typical OpenStack deployment.

Encryption:

Plain-Text = P1 || P2 || P3 || ...
C0 = Random IV (128bit)
for i in range(1, N):
   Ci = ENC(EncKey, Pi^Ci-1)
Encrypted-Message = C0 || C1 || C2 || C3 || ...

Decryption:

IV = C0
Cipher-Text = C1 || C2 || C3 || ...
for i in range (1, N):
    Pi = DEC(EncKey, Ci)^Ci-1
Plain-Text = P1 || P2 || P3 || ...



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

#### GET /kds/ticket/

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