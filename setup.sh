#!/bin/bash

if [ $UID -ne 0 ]; then
    echo "You need to be root for this"
    exit 127
fi

yum -y install centos-release-SCL
yum -y install ruby193 ruby193-rubygems ruby193-ruby-devel gcc kernel-headers
echo "source /opt/rh/ruby193/enable" | sudo tee -a /etc/profile.d/ruby193.sh
chmod +x /etc/profile.d/ruby193.sh
/etc/profile.d/ruby193.sh 2>&1 >/dev/null

gem install hiera -v 1.3.4
gem install puppet -v 3.8.4
gem install kafo
gem install librarian-puppet

cd cluster-installer
export PATH=/opt/rh/ruby193/root/usr/local/bin:$PATH
librarian-puppet install

if [ ! -f ~/answers.yaml ]; then
    echo -e "---\nkvmcluster: true" > ~/answers.yaml

    # TODO: We should generate the answers file from the network configuration
fi
