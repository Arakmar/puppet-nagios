# @summary Declares the default Nagios contact groups.
#
# @param contactgroups Contact groups to declare, as nagios::type::contactgroup
#   titles mapped to their parameters. Defaults to an admins group.
class nagios::defaults::contactgroups (
  Hash[String[1], Hash] $contactgroups,
) {
  $contactgroups.each |String $group, Hash $params| {
    nagios::type::contactgroup { $group:
      * => $params,
    }
  }
}
