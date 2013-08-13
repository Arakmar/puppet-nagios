class nagios::apache(
  $allow_external_cmd = false,
  $manage_shorewall = false,
  $manage_munin = false,
  $server_name = "default"
) {
  class{'nagios':
    allow_external_cmd => $allow_external_cmd,
    manage_munin => $manage_munin,
    manage_shorewall => $manage_shorewall,
    server_name => $server_name
  }

  case $::operatingsystem {
    'debian': {
      file { "${nagios::defaults::vars::int_cfgdir}/apache2.conf":
        ensure => present,
        source => [ "puppet:///modules/site-nagios/configs/${::fqdn}/apache2.conf",
                    "puppet:///modules/site-nagios/configs/apache2.conf",
                    "puppet:///modules/nagios/configs/apache2.conf"],
      }

      apache::config::global { "nagios3.conf":
        ensure => link,
        target => "${nagios::defaults::vars::int_cfgdir}/apache2.conf",
        require => File["${nagios::defaults::vars::int_cfgdir}/apache2.conf"]
      }
    }
  }
}
