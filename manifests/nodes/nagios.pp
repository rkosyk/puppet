node 'nagios' {

	# Do required actions for every host
	class {'essential':}

    # Install required packages
	package { ['nagios','nagios-plugins-nrpe','nrpe','php','httpd'] : ensure => installed, } ->
	service {['httpd','nagios']: enable => true, ensure => running, }
    
    # Configure nagios
	file { "/etc/nagios":
		ensure  => 'directory',
  		source  => "puppet:///modules/nagios/nagios",
  		recurse => 'true',
  		owner   => "root", group => "root", mode => 664,
  		notify  => Service['nagios'],
    } 
    # Add public key
	file { "/root/.ssh/id_rsa.pub":
  		source  => "puppet:///modules/nagios/id_rsa.pub",
  		owner   => "root", group => "root", mode => 644,
	} 
	# Add private key
	file { "/root/.ssh/id_rsa":
  		source  => "puppet:///modules/nagios/id_rsa",
  		owner   => "root", group => "root", mode => 600,
	} 	
	# Avoid ssh asking permission
	file { "/root/.ssh/config":
		ensure  => present,
  		content => "StrictHostKeyChecking no",
	} 

}