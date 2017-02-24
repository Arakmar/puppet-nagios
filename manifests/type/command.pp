define nagios::type::command (
	$command_name = $name,
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
		$tagArray = prefix("nagios_command_", $server_name)
		@@concat::fragment{ "nagios_command_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_command.cfg',
			content => template("nagios/nagios_type/command.erb"),
			tag => $tagArray,
		}
	}
}
