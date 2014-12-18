OpenStack Identity API v3 token formats
=======================================

The Identity API supports multiple token formats. Applications should
treat the tokens as opaque references to remote objects.  However, since
implementations of token parsing must be language agnostic, the various token
formats are documented here.


# Historical Formats

## UUID Tokens
A UUID token is the oldest format, and has no identifying data in it.
A UUID token looks like this:

e60191a29486420f96b7d660a5421aab

## ASN1 Tokens
The first form of tokens to contain a format identifier are tokens that contain
all of the data from the token validation response.  The JSON document is
converted into a Crypto Message Syntax (CMS) encoded document which is base64
encoded.  The non URL safe `/` chracter  in the encoded form is replaced with
the URL safe `-` character.  The '-----BEGIN CMS-----' and '-----END CMS-----'
delimeters are removed, as are any line breaks.

The CMS format uses ASN1 as an intermediate format.  ASN1 encodes field lengths
included the length of the overall message.  For PKI tokens, the lengths, once
Base64 encode, lead to the message starting with the string 'MII'.  This
artifact was used as a token format identifier.

## PKIZ

The Data encoded in the token quickly expanded to sizes that were impractical to transmit in headers.  The first attempt to minimize the token size was to compress the tokens.  To distinguish these tokens from the earlier format, the format identifier `PKIZ` is prepended to these tokens.


# Token Naming conventions

In order to support multiple token formats without each one coming up with an
ad-hoc naming scheme, tokens will contain the following naming scheme prefix.

The following prefix identifies the token as an OpenStack Identity API
Authorization token.

`OSAUTHZ`

The next 4 characters will be the Hexidecimal representation of the token format.  Thus the formats will range from

`OSAUTHZ0000`

to

`OSAUTHZFFFF`

The table below contains the registered Token formats.

OSAUTHZ0000 :  UUID token.  Replaces the UUID token format
OSAUTHZ0001 :  ASN1 token.  Replaces the ASN1 format indicator
OSAUTHZ0002 :  PKIZ token.  Replaces the PKIZ_ format indicator


All historical formats
are depricated and should be replaced with the values above.
