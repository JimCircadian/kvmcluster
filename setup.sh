#!/bin/bash

if [ $UID ne 0 ]; then
    echo "You need to be root for this"
    exit 127
fi

yum -y install ruby

bundle install

cd cluster-installer
librarian-puppet install
