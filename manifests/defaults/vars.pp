class nagios::defaults::vars {
  $int_cfgdir = $::osfamily ? {
    'debian' => '/etc/nagios3',
    default  => '/etc/nagios'
  }

  $resource_cfgpath = $::osfamily ? {
    'debian' => '/etc/nagios3/resource.cfg',
    default => '/etc/nagios/private/resource.cfg'
  }
  
  $int_server_name = $nagios::server_name
}
