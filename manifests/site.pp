 ######################################################################################################################
################################# Puppet manifest to define infrastructure ######################################
 ######################################################################################################################

$extlookup_datadir    = '/etc/puppet/manifests/extdata'
$extlookup_precedence = 'common'

include stdlib

# Import nodes manifests from /etc/puppet/manifests
import '/etc/puppet/manifests/nodes/*.pp'


# Actions that are required to do on every host
class essential {

	#Install required packages:
	package { ['epel-release','nagios-plugins-all','mc']:
		ensure => installed
	}

	# Install community check_mem nagios plugin
	file { "/usr/lib64/nagios/plugins/check_mem":
		ensure    => present,
  		source    => "puppet:///modules/nagios/check_mem",
  		owner     => "root", group => "root", mode => 755,
  		require	  => Package['nagios-plugins-all'],
	} 
	# Add nagios server public key to the authorized keys
	ssh_authorized_key { 'root@nagios':
		user => 'root',
		type => 'rsa',
		key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA4IigFS2aeZExBUlss2dMiVTjyJVMWpTl2k8GHJ1rC0leAFelRyDHOaptbBByA7C6d7DSzaiU3Q+pQVNn6cuFOMWfXO6kAV8yZpv3wrn+5Ab5ATElSpxn3gTvXJTMK0IHq5w51p0q1QTPExi/aQUpdxJddgHbQCMJhP08s6fXECOC1QiR3/B9lZ0SpfB06pzkfUj+pKdllPEGOlp7ITlcC1D5vj51zSdS3PKp0T41Cvson9SF9xpaNw8pJu4Djydc3b/GioZoRi9kStE8kIj7+i+3tpYMNPKtBpxH53vcxojzXvz3FLfeSnj1a0iTWwB0pOM5WoyRohYi/8P1M4xWMQ==',
	}		
}

node default {}

