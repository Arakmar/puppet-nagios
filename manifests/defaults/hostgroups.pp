# @summary Declares the default Nagios host groups.
#
# @param hostgroups Host groups to declare, as nagios::type::hostgroup titles
#   mapped to their parameters.
class nagios::defaults::hostgroups (
  Hash[String[1], Hash] $hostgroups,
) {
  $hostgroups.each |String $group, Hash $params| {
    nagios::type::hostgroup { $group:
      * => $params,
    }
  }
}
