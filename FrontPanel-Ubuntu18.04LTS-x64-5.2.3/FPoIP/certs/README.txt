This directory contains *test* certificates that can be used with the test
FPOIP server for testing purposes.

The files snakeoil.{crt,key} contain a non-encrypted self-signed server key.
These files provide no real security neither on server (no password is needed
to use it) nor on the client (no verification of the server identity is
possible). They were created using the following command:

	$ openssl req -newkey rsa:2048 -nodes -keyout snakeoil.priv \
		-x509 -days 3655 -out snakeoil.pem \
		-subj "/C=US/ST=OR/L=Portland/O=Opal Kelly Inc/CN=fpoip.opalkelly.com"


The files server.{crt,key} contain the encrypted server key protected by a
password (which is "xemoip") and certificate signed by our own certificate
authority, see ca/README.txt for more about creating it. These files were
created using the following commands which create the key, create the
certificate signing request and sign it:

	$ openssl genrsa -aes256 -out server.key 2048
		# enter password when requested
	$ openssl req -key server.key -new -sha256 -out server.csr \
		-subj "/C=US/ST=OR/L=Portland/O=Opal Kelly Inc/CN=server.fpoip.opalkelly.com"
	$ openssl ca -config ca/openssl.conf # replace with the real CA config!
		-extensions server_cert -days 3655 -notext -md sha256 \
		-in server.csr -out server.crt
		# confirm the signing

The certificate request file server.csr may be deleted afterwards.


If using a real (i.e. not our own) CA, the first two steps would still be the
same however the third step would be replaced by the CA-specific procedure of
submitting the certificate for signing.
