#!/bin/bash

# If you want to download a new version just change the OpenSSL version below.
OPENSSL_VERSION="1.0.1h"

# An example of an OpenSSL download link https://www.openssl.org/source/openssl-1.0.1h.tar.gz
# Since we want to be sure we will download it in curl over non-secure http connection.


curl -O http://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
tar -xvzf openssl-$OPENSSL_VERSION.tar.gz

# We need to check what kind of system you are running, 32-Bit or 64-Bit.

if $(uname -m | grep '64');
then
	# If you are on a 64-Bit system we are doing this below.
	mv openssl-$OPENSSL_VERSION openssl_x86_64
	cd openssl_x86_64
	./Configure darwin64-x86_64-cc -shared
	make
else
	# If you are on a 32-Bit system we are doing this below.
	mv openssl-$OPENSSL_VERSION openssl_i386
	cd openssl_i386
	./Configure darwin-i386-cc -shared
	make
fi

cd ../

# Then we need to install what we have compiled.
lipo -create openssl_i386/libcrypto.1.0.0.dylib openssl_x86_64/libcrypto.1.0.0.dylib -output libcrypto.1.0.0.dylib
lipo -create openssl_i386/libssl.1.0.0.dylib openssl_x86_64/libssl.1.0.0.dylib -output libssl.1.0.0.dylib


# We will also remove any garbage on your system
rm openssl-$OPENSSL_VERSION.tar.gz
rm openssl_x86_64
rm openssl_i386


# Have a nice day!
# Original author: https://gist.github.com/tmiz/1441111
# This script is made by Remzi Cavdar