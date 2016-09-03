
node /^database/ {

	# Do required actions for every host
	class {'essential':}

	# Define username and password
	$user   = 'roman'
	$passwd = extlookup('passwd')
	
	# Install mysql
	package { ['mysql','mysql-server']  :  ensure => installed, } ->
	service { ['mysqld'] : enable => true, ensure => running,   } ->

	# Assign users
	exec {'Assign users':    		  
		command => "/usr/bin/mysqladmin -u root password $passwd;
		/usr/bin/mysql -u root -p$passwd -e \"delete from mysql.user where not (host='localhost' and user='root');\";
		/usr/bin/mysql -u root -p$passwd -e \"GRANT ALL PRIVILEGES ON *.* TO $user@'%' IDENTIFIED BY '$passwd' WITH GRANT OPTION;\"
		/usr/bin/mysql -u root -p$passwd -e 'FLUSH PRIVILEGES;'",
		subscribe => Package['mysql-server'],
		refreshonly => true,
	} ->

	file { '/root/.my.cnf':
		ensure  => present,
		content => "[client]\nuser=$user\npassword=$passwd",
		mode => 0100,
	} 
}

	
