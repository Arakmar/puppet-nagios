# @summary Declares a Nagios host group on the server.
#
# @param hostgroup_name Name of the group, defaults to the resource title.
# @param hostgroup_alias Long name of the group.
# @param use Hostgroup template to inherit from.
# @param members Hosts belonging to the group, `*` for all of them.
define nagios::type::hostgroup (
  String[1]           $hostgroup_name  = $name,
  Optional[String[1]] $hostgroup_alias = undef,
  Optional[String[1]] $use             = undef,
  Array[String[1]]    $members         = [],
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  concat::fragment { "nagios_hostgroup_${name}_${facts['networking']['fqdn']}":
    target  => "${cfg_dir}/conf.d/nagios_hostgroup.cfg",
    order   => '30',
    tag     => 'nagios_hostgroup',
    content => nagios::object('hostgroup', {
        'hostgroup_name' => $hostgroup_name,
        'alias'          => $hostgroup_alias,
        'use'            => $use,
        'members'        => $members,
    }),
  }
}
