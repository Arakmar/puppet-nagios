define nagios::type::command (
	$command_name = $name,
	$command_line,
	$use = ''
)
{
	concat::fragment { "nagios_command_${name}":
		target  => '/etc/nagios3/conf.d/nagios_command.cfg',
		content => template("nagios/nagios_type/command.erb"),
		tag     => 'nagios_command',
	}
}
