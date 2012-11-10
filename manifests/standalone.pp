# /etc/puppet/manifests/site.pp
stage { 'yum' : before => Stage['main'] }

node scanner {
	include openvas
	group {
		'puppet':
		ensure => present,
		gid => 20000
	} 
}
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
				content => template('/tmp/vagrant-puppet/modules-0/openvas/templates/etc/openvas/openvassd.rules'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/sysconfig':
				ensure => directory;
			'/etc/sysconfig/openvas-scanner':
				content => template('/tmp/vagrant-puppet/modules-0/openvas/templates/etc/sysconfig/openvas-scanner'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/yum.repos.d':
				ensure => directory;
			'/etc/yum.repos.d/atomic.repo':
				content => template('/tmp/vagrant-puppet/modules-0/openvas/templates/etc/yum.repos.d/atomic.repo'),
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
					ensure => present;
				'openvas':
					ensure => present;
				'openvas-administrator':
					ensure => present;
				'openvas-cli':
					ensure => present;
				'openvas-libraries':
					ensure => present;
				'openvas-manager':
					ensure => present;
				'openvas-scanner':
					ensure => present;
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
