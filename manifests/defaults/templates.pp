class nagios::defaults::templates(
  $source = undef,
) {
  include nagios::params

  $real_source = $source ? {
    undef => [
      "puppet:///modules/nagios/configs/${facts['os']['name']}/nagios_templates.cfg",
      'puppet:///modules/nagios/configs/nagios_templates.cfg',
    ],
    default => $source,
  }

  file { 'nagios_templates':
    path   => "${nagios::params::cfg_dir}/conf.d/nagios_templates.cfg",
    source => $real_source,
    notify => Service[$nagios::params::service],
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
}
