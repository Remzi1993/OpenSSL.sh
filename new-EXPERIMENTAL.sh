#!/bin/bash
exec 5> >(logger -t $0)
BASH_XTRACEFD="5"
PS4='$LINENO: '
set -x

openssl version -a

# OpenSSL.sh
sudo apt update
sudo apt install curl build-essential checkinstall zlib1g-dev -y

read -p "Enter the Linux Kernel version you would like to install: " version
read -p "Are you sure? Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

sudo curl -O https://www.openssl.org/source/openssl-"$version".tar.gz
sudo tar -xf openssl-"$version".tar.gz
cd openssl-"$version"
sudo ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
sudo make
sudo make test
sudo make install
cd /etc/ld.so.conf.d/
echo '/usr/local/ssl/lib' | sudo tee -a openssl-"$version".conf > /dev/null
sudo ldconfig -v
sudo mv /usr/bin/c_rehash /usr/bin/c_rehash.BEKUP
sudo mv /usr/bin/openssl /usr/bin/openssl.BEKUP


# sudo nano /etc/environment 
# PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/ssl/bin"
source /etc/environment echo $PATH
which openssl
openssl version -a