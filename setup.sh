#!/bin/bash

if [ $UID -ne 0 ]; then
    echo "You need to be root for this"
    exit 127
fi

yum -y install ruby ruby-devel

gem install kafo
gem install librarian-puppet

cd cluster-installer
librarian-puppet install
