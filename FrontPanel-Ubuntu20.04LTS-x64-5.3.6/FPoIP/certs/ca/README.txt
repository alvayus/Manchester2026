This directory contains the files of an example certificate authority (CA).
It must *NOT* be used directly as its private key is not stored securely,
meaning that anybody in its possession and knowing the pass phrase (which is
"caoip") can create new "trusted" keys. Also, this CA doesn't use an
intermediate CA but it should to allow revoking the certificates signed by it
in case of a compromise.

See

	https://jamielinux.com/docs/openssl-certificate-authority/index.html

for more details of how a CA should be really set up. In this particular
example just the following commands were used in this directory:

	$ mkdir certs crl newcerts private
	$ touch index.txt
	$ echo 1000 > serial.txt
	$ openssl genrsa -aes256 -out private/ca.key.pem 4096
	$ openssl req -config openssl.conf -key private/ca.key.pem \
		-new -x509 -days 7300 -sha256 -extensions v3_ca -out certs/ca.cert.pem \
		-subj "/C=US/ST=OR/L=Portland/O=Opal Kelly Inc/CN=fpoip.opalkelly.com"
