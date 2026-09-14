# @summary Declares a Nagios contact group on the server.
#
# @param contactgroup_name Name of the group, defaults to the resource title.
# @param contactgroup_alias Long name of the group.
# @param members Contacts belonging to the group.
define nagios::type::contactgroup (
  String[1]           $contactgroup_name  = $name,
  Optional[String[1]] $contactgroup_alias = undef,
  Array[String[1]]    $members            = [],
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  concat::fragment { "nagios_contactgroup_${name}_${facts['networking']['fqdn']}":
    target  => "${cfg_dir}/conf.d/nagios_contactgroup.cfg",
    order   => '30',
    tag     => 'nagios_contactgroup',
    content => nagios::object('contactgroup', {
        'contactgroup_name' => $contactgroup_name,
        'alias'             => $contactgroup_alias,
        'members'           => $members,
    }),
  }
}
