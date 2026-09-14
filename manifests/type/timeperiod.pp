# @summary Declares a Nagios timeperiod on the server.
#
# @param timeperiod_name Name of the timeperiod, defaults to the resource title.
# @param timeperiod_alias Long name of the timeperiod.
# @param monday Time ranges on Monday, for example `09:00-17:00`.
# @param tuesday Time ranges on Tuesday.
# @param wednesday Time ranges on Wednesday.
# @param thursday Time ranges on Thursday.
# @param friday Time ranges on Friday.
# @param saturday Time ranges on Saturday.
# @param sunday Time ranges on Sunday.
define nagios::type::timeperiod (
  String[1]           $timeperiod_name  = $name,
  Optional[String[1]] $timeperiod_alias = undef,
  Optional[String[1]] $monday           = undef,
  Optional[String[1]] $tuesday          = undef,
  Optional[String[1]] $wednesday        = undef,
  Optional[String[1]] $thursday         = undef,
  Optional[String[1]] $friday           = undef,
  Optional[String[1]] $saturday         = undef,
  Optional[String[1]] $sunday           = undef,
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  concat::fragment { "nagios_timeperiod_${name}_${facts['networking']['fqdn']}":
    target  => "${cfg_dir}/conf.d/nagios_timeperiod.cfg",
    order   => '30',
    tag     => 'nagios_timeperiod',
    content => nagios::object('timeperiod', {
        'timeperiod_name' => $timeperiod_name,
        'alias'           => $timeperiod_alias,
        'monday'          => $monday,
        'tuesday'         => $tuesday,
        'wednesday'       => $wednesday,
        'thursday'        => $thursday,
        'friday'          => $friday,
        'saturday'        => $saturday,
        'sunday'          => $sunday,
    }),
  }
}
