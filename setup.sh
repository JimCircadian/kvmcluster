#!/bin/bash

if [ $UID -ne 0 ]; then
    echo "You need to be root for this"
    exit 127
fi

yum -y install centos-release-SCL
yum -y install ruby193 ruby193-rubygems ruby193-ruby-devel gcc kernel-headers

RPROF=/etc/profile.d/ruby193.sh
if [ ! -f $RPROF ]; then 
    cat <<R193SH >$RPROF
source /opt/rh/ruby193/enable
export PATH=/opt/rh/ruby193/root/usr/local/bin:$PATH
R193SH
fi

chmod +x /etc/profile.d/ruby193.sh
/etc/profile.d/ruby193.sh 2>&1 >/dev/null

GEMS=`gem list`
if [ $( echo "$GEMS" | grep 'hiera' | wc -l ) -le 1 ]; then
    gem install hiera -v 1.3.4
fi

if [ $( echo "$GEMS" | grep 'puppet' | wc -l ) -le 1 ]; then
    gem install puppet -v 3.8.4
fi 

if [ $( echo "$GEMS" | grep 'kafo' | wc -l ) -le 1 ]; then
    gem install kafo
fi 

if [ $( echo "$GEMS" | grep 'librarian-puppet' | wc -l ) -le 1 ]; then
    gem install librarian-puppet
fi

cd cluster-installer
librarian-puppet install

if [ ! -f ~/cluster-installer-answers.yaml ]; then
    echo -e "---\nkvmcluster: true" > ~/cluster-installer-answers.yaml

    # TODO: We should generate the answers file from the network configuration
fi
