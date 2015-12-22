#!/bin/bash

# TODO General: add LAMP use case
# TODO General: fix setup scripts
# TODO General: wiki for usage of use cases

if [ $UID -ne 0 ]; then
    echo "You need to be root for this"
    exit 1
fi

OSVER=`uname -r | sed -r -e '/el[67]/!d' -e 's/^.+\.el([0-9]+)\..*$/\1/g'`
PUPPETVER="3.8.4"
HIERAVER="1.3.4"
INSTALLER=""

if [ $# -ne 1 ]; then
	echo "Usage setup.sh <installer>"
else 
	INSTALLER="$1"
	
	if [ ! -d "./$INSTALLER" ]; then
		echo "Installer directory $INSTALLER is not an option under this repo..."
		exit 1
	fi
fi

if [ $OSVER == '6' ]; then
	yum -y install centos-release-SCL
	yum -y install ruby193 ruby193-rubygems ruby193-ruby-devel gcc kernel-headers

	RPROF=/etc/profile.d/ruby193.sh
	if [ ! -f $RPROF ]; then 
		cat <<R193SH >$RPROF
source /opt/rh/ruby193/enable
export PATH=/opt/rh/ruby193/root/usr/local/bin:\$PATH
R193SH
	fi

	chmod +x /etc/profile.d/ruby193.sh
	/etc/profile.d/ruby193.sh 2>&1 >/dev/null
elif [ $OSVER == '7' ]; then
	# yum install ruby ruby-devel rubygems gcc kernel-headers rubygems-devel
	# gem install syck
else 
	echo "This isn't an EL6 or EL7 distro so I'm bailing..."
	exit 1
fi

GEMS=`gem list`
if [ $( echo "$GEMS" | grep 'hiera' | wc -l ) -le 1 ]; then
    gem install hiera -v $HIERAVER
fi

if [ $( echo "$GEMS" | grep 'puppet' | wc -l ) -le 1 ]; then
    gem install puppet -v $PUPPETVER
fi 

if [ $( echo "$GEMS" | grep 'kafo' | wc -l ) -le 1 ]; then
    gem install kafo
fi 

if [ $( echo "$GEMS" | grep 'librarian-puppet' | wc -l ) -le 1 ]; then
    gem install librarian-puppet
fi

cd $INSTALLER
librarian-puppet install

SAMPLEFILE="./$INSTALLER/config/answers.sample.yaml"
ANSWERSFILE="~/$INSTALLER-answers.yaml"

if [ ! -f $ANSWERSFILE ] && [ -f $SAMPLEFILE ]; then
	cp $SAMPLEFILE $ANSWERSFILE

    # TODO: We could customize the answers file from the local instance (a la facter)
fi
