# @summary Declares a usable set of default Nagios objects on the server.
#
# Includes the default commands, contacts, contact groups, host groups,
# timeperiods and the generic host, service and contact templates.
#
# @example
#   include nagios
#   include nagios::defaults
class nagios::defaults {
  include nagios::defaults::commands
  include nagios::defaults::contactgroups
  include nagios::defaults::contacts
  include nagios::defaults::hostgroups
  include nagios::defaults::templates
  include nagios::defaults::timeperiods
}
