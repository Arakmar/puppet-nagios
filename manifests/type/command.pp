define nagios::type::command (
  $command_line,
  $command_name = $name,
  $use          = undef
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  concat::fragment { "nagios_command_${name}":
    target  => "${cfg_dir}/conf.d/nagios_command.cfg",
    content => template('nagios/nagios_type/command.erb'),
    tag     => 'nagios_command',
    order   => '30',
  }
}
