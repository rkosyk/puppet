
node /^webserver/ {

	# Do required actions for every host
	class {'essential':}

	# Install tomcat:
	package { 'tomcat6':	ensure => 'installed', } ->

	# Start tomcat and add to autostart:
	service {'tomcat6':
		enable => 'true',
		ensure => 'running',
		require => Package['tomcat6'],
	}
	
}	