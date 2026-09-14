class nagios::defaults::templates(
  $source = undef,
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)
  $service = lookup('nagios::service', String[1])

  $real_source = $source ? {
    undef => [
      "puppet:///modules/nagios/configs/${facts['os']['name']}/nagios_templates.cfg",
      'puppet:///modules/nagios/configs/nagios_templates.cfg',
    ],
    default => $source,
  }

  file { 'nagios_templates':
    path   => "${cfg_dir}/conf.d/nagios_templates.cfg",
    source => $real_source,
    notify => Service[$service],
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
}
