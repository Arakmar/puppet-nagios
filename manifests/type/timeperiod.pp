define nagios::type::timeperiod (
  $timeperiod_name  = $name,
  $timeperiod_alias = undef,
  $monday           = undef,
  $tuesday          = undef,
  $wednesday        = undef,
  $thursday         = undef,
  $friday           = undef,
  $saturday         = undef,
  $sunday           = undef
) {
  include nagios::params

  concat::fragment { "nagios_timeperiod_${name}_${facts['networking']['fqdn']}":
    target  => "${nagios::params::cfg_dir}/conf.d/nagios_timeperiod.cfg",
    content => template('nagios/nagios_type/timeperiod.erb'),
    tag     => 'nagios_timeperiod',
    order   => '30',
  }
}
