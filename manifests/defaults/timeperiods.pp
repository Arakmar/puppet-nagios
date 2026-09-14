# @summary Declares the default Nagios timeperiods.
#
# @param timeperiods Timeperiods to declare, as nagios::type::timeperiod titles
#   mapped to their parameters. Defaults to 24x7, workhours, nonworkhours
#   and never.
class nagios::defaults::timeperiods (
  Hash[String[1], Hash] $timeperiods,
) {
  $timeperiods.each |String $timeperiod, Hash $params| {
    nagios::type::timeperiod { $timeperiod:
      * => $params,
    }
  }
}
