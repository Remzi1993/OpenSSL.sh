#!/bin/bash

# If you want to download a new version just change the OpenSSL version below.
OPENSSL_VERSION="1.0.1h"

# An example of an OpenSSL download link https://www.openssl.org/source/openssl-1.0.1h.tar.gz
# Since we want to be sure we will download it in curl over non-secure http connection.


# Switch to /usr/local/src and download the source package.
cd /usr/local/src
curl -O http://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz


# Extract the archive and move into the folder.
tar -xvzf openssl-$OPENSSL_VERSION.tar.gz
cd openssl-$OPENSSL_VERSION


# We need to check what kind of system you are running, 32-Bit or 64-Bit.
if $(uname -m | grep '64');
then
	# Configure, compile and install into /usr/local/openssl-$OPENSSL_VERSION
	# This is done so that you could have multiple installations on your system.
	sudo ./configure darwin64-x86_64-cc --prefix=/usr/local/openssl-$OPENSSL_VERSION
	sudo make
	sudo make install
	
else
	# If you are on a 32-Bit system we are doing this below.
	sudo ./configure darwin-i386-cc --prefix=/usr/local/openssl-$OPENSSL_VERSION
	sudo make
	sudo make install
fi

# Create a symbolic link that points /usr/local/openssl to /usr/local/openssl-$OPENSSL_VERSION
# This need to be done and if you have more than one installation of OpenSSL on your system you could easily switch just create a symbolic link.
ln -s openssl-$OPENSSL_VERSION /usr/local/openssl
	
# Execute the following lines to update your Bash startup script.
echo 'export PATH=/usr/local/openssl/bin:$PATH' >> ~/.bash_profile
echo 'export MANPATH=/usr/local/openssl/ssl/man:$MANPATH' >> ~/.bash_profile
	
# Load the new shell configurations.
source ~/.bash_profile
	
# Execute the following lines to install the certificates.
security find-certificate -a -p /Library/Keychains/System.keychain > /usr/local/openssl/ssl/cert.pem
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain >> /usr/local/openssl/ssl/cert.pem



# We will also remove any remaining garbage on your system.
rm openssl-$OPENSSL_VERSION.tar.gz
rm openssl-$OPENSSL_VERSION

sudo port uninstall curl
sudo port install curl +ssl

# Have a nice day!
# Original author: https://gist.github.com/tmiz/1441111
# This script is made by Remzi Cavdar