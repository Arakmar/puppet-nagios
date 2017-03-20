class nagios::defaults::templates {

  file { 'nagios_templates':
    path   => "${nagios::params::cfg_dir}/conf.d/nagios_templates.cfg",
    source => [ "puppet:///modules/nagios/configs/${::operatingsystem}/nagios_templates.cfg",
      'puppet:///modules/nagios/configs/nagios_templates.cfg' ],
    notify => Service[$nagios::params::service],
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
}
