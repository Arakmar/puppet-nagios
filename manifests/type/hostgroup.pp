define nagios::type::hostgroup (
  $hostgroup_alias = undef,
  $hostgroup_name  = $name,
  $use             = undef,
  $members         = []
) {
  concat::fragment { "nagios_hostgroup_${name}_${facts['networking']['fqdn']}":
    target  => "${nagios::params::cfg_dir}/conf.d/nagios_hostgroup.cfg",
    content => template('nagios/nagios_type/hostgroup.erb'),
    tag     => 'nagios_hostgroup',
    order   => '30',
  }
}
