class openvas($version = '0.1') {
	Exec {
		path => '/sbin:/bin:/usr/sbin:/usr/bin',
	}
	Class['files'] -> Class['packages']
	class files {
		file {
			'/etc':
				ensure => directory;
			'/etc/openvas':
				ensure => directory;
			'/etc/openvas/openvassd.rules':
				content => template('openvas/etc/openvas/openvassd.rules'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/sysconfig':
				ensure => directory;
			'/etc/sysconfig/openvas-scanner':
				content => template('etc/sysconfig/openvas-scanner'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/yum.repos.d':
				ensure => directory;
			'/etc/yum.repos.d/atomic.repo':
				content => template('etc/yum.repos.d/atomic.repo'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
		}
	}
	include files
	class packages {
		exec { 'yum makecache':
			before => Class['yum'],
		}
		class yum {
			package {
				'nmap':
					ensure => '2:6.01-2.el6.art.x86_64';
				'openvas':
					ensure => '1.0-3.el6.art.noarch';
				'openvas-administrator':
					ensure => '1.2.1-2.el6.art.x86_64';
				'openvas-cli':
					ensure => '1.1.5-3.el6.art.x86_64';
				'openvas-libraries':
					ensure => '5.0.4-5.el6.art.x86_64';
				'openvas-manager':
					ensure => '3.0.4-4.el6.art.x86_64';
				'openvas-scanner':
					ensure => '3.3.1-2.el6.art.x86_64';
			}
		}
		include yum
	}
	include packages
	class services {
		class sysvinit {
			service {
				'openvas-scanner':
					enable    => true,
					ensure    => running,
					subscribe => [File['/etc/openvas/openvassd.rules'], File['/etc/sysconfig/openvas-scanner'], Package['openvas-scanner']];
			}
		}
		include sysvinit
	}
	include services
}

# Then, declare it:
    class {'openvas': }
