define nagios::type::timeperiod (
	$timeperiod_name = $name,
	$timeperiod_alias = '',
	$monday = '',
	$tuesday = '',
	$wednesday = '',
	$thursday = '',
	$friday = '',
	$saturday = '',
	$sunday = ''
)
{
	concat::fragment { "nagios_timeperiod_${name}_${::fqdn}":
		target  => '/etc/nagios3/conf.d/nagios_timeperiod.cfg',
		content => template("nagios/nagios_type/timeperiod.erb"),
		tag     => 'nagios_timeperiod',
	}
}
