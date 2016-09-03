#!/bin/sh

# ip-address puppet-server
ip_puppet='10.0.0.10'

sudo -s

# Install puppet agent on every node
yum install http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm -y
yum install epel-release ntp puppet --nogpgcheck -y 
ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
service ntpd start
echo -e "${ip_puppet} puppet\n" >> /etc/hosts

# Install puppet server, git on the node 'puppet' and get puppet config from the github
if [ $HOSTNAME == "puppet" ]
then
 	yum install puppet-server puppetdb puppetdb-terminus git --nogpgcheck -y
 	cd /etc
 	rm -rf puppet
 	git clone https://github.com/rkosyk/puppet.git
 	cd /etc/puppet
 	git config --global user.name "roman"
 	git config --global user.email "rkosyk@gmail.com" 
 	puppet resource service puppetmaster ensure=running enable=true
 	puppetdb ssl-setup
 	puppet resource service puppetdb ensure=running enable=true
fi 

# Run puppet agent
echo -e "\nPuppet apply started..."
puppet agent --test
echo -e  "Puppet apply completed!\\n"
