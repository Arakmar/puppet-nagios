define nagios::type::command (
  $command_line,
  $command_name = $name,
  $use          = undef
) {
  concat::fragment { "nagios_command_${name}":
    target  => "${nagios::params::cfg_dir}/conf.d/nagios_command.cfg",
    content => template('nagios/nagios_type/command.erb'),
    tag     => 'nagios_command',
    order   => '30',
  }
}
