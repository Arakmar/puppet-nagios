define nagios::type::timeperiod (
	$timeperiod_name = "$name",
	$timeperiod_alias = '',
	$monday = '',
	$tuesday = '',
	$wednesday = '',
	$thursday = '',
	$friday = '',
	$saturday = '',
	$sunday = '',
	$server_name = undef
)
{
	if ! ($server_name) {
		@@concat::fragment{ "nagios_timeperiod_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_timeperiod.cfg',
			content => template("nagios/nagios_type/timeperiod.erb"),
			tag => 'nagios_timeperiod',
		}
	} else {
		$tagArray = prefix("nagios_timeperiod_", $server_name)
		@@concat::fragment{ "nagios_timeperiod_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_timeperiod.cfg',
			content => template("nagios/nagios_type/timeperiod.erb"),
			tag => $tagArray,
		}
	}
}
