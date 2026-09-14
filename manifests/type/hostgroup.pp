define nagios::type::hostgroup (
  $hostgroup_alias = undef,
  $hostgroup_name  = $name,
  $use             = undef,
  $members         = []
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  concat::fragment { "nagios_hostgroup_${name}_${facts['networking']['fqdn']}":
    target  => "${cfg_dir}/conf.d/nagios_hostgroup.cfg",
    content => template('nagios/nagios_type/hostgroup.erb'),
    tag     => 'nagios_hostgroup',
    order   => '30',
  }
}
