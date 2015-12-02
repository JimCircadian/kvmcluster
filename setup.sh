#!/bin/bash

if [ $UID -ne 0 ]; then
    echo "You need to be root for this"
    exit 127
fi

yum -y install centos-release-SCL
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum -y install puppet hiera ruby193 ruby193-rubygems
sed -ri 's/enabled=1/enabled=0/g' /etc/yum.repos.d/puppetlabs.repo

# gem install hiera -v 1.3.4
# gem install puppet -v 3.8.4
gem install kafo
gem install librarian-puppet

cd cluster-installer
librarian-puppet install

if [ ! -f ~/answers.yaml ]; then
    echo -e "---\nkvmcluster: true" > ~/answers.yaml

    # TODO: We should generate the answers file from the network configuration
fi
