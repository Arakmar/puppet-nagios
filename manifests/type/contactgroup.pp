define nagios::type::contactgroup (
  $contactgroup_name  = $name,
  $contactgroup_alias = undef,
  $members            = [],
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  concat::fragment { "nagios_contactgroup_${name}_${facts['networking']['fqdn']}":
    target  => "${cfg_dir}/conf.d/nagios_contactgroup.cfg",
    content => template('nagios/nagios_type/contactgroup.erb'),
    tag     => 'nagios_contactgroup',
    order   => '30',
  }
}
