define nagios::type::command (
	$command_name = "$name",
	$command_line,
	$use = '',
	$server_name = undef
)
{
	if ! ($server_name) {
		@@concat::fragment{ "nagios_command_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_command.cfg',
			content => template("nagios/nagios_type/command.erb"),
			tag => 'nagios_command',
		}
	} else {
		$tableau = prepend_array("nagios_command_", $server_name)
		@@concat::fragment{ "nagios_command_${name}_${server_name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_command.cfg',
			content => template("nagios/nagios_type/command.erb"),
			tag => $tableau,
		}
	}
}
