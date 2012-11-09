#init.pp
stage { 'yum' : before => Stage['main'] }
node 'scaner' {
   package { "": ensure => installed, require => Yumrepo["IUS"] }
   yumrepo { "Atomicorp":
      baseurl => "http://dl.iuscommunity.org/pub/ius/stable/$operatingsystem/$operatingsystemrelease/$architecture",
      descr => "IUS Community repository",
      enabled => 1,
      gpgcheck => 0
   }
}
