
node 'puppet' {

	# Install required packages, configure and start required services (file, service) and add to the autostart:
	class {'essential':}	

	# Install puppet-server
	package { ['puppet-server','puppetdb','puppetdb-terminus']: ensure => latest, } ->
	service { ['puppetmaster','puppetdb']: ensure => running, enable => true, }


	file_line {'git_config':
    	path  => '/etc/puppet/.git/config',
    	line  => '	url = https://rkosyk@github.com/rkosyk/puppet.git',
    	match => 'url = https:',
  	}	

}