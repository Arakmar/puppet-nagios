# @summary Declares a Nagios command on the server.
#
# The definition is rendered into conf.d/nagios_command.cfg on the node
# declaring it, so this define is meant for the Nagios server.
#
# @param command_line Command line executed by Nagios.
# @param command_name Name of the command, defaults to the resource title.
# @param use Command template to inherit from.
define nagios::type::command (
  String[1]           $command_line,
  String[1]           $command_name = $name,
  Optional[String[1]] $use          = undef,
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  concat::fragment { "nagios_command_${name}":
    target  => "${cfg_dir}/conf.d/nagios_command.cfg",
    order   => '30',
    tag     => 'nagios_command',
    content => nagios::object('command', {
        'command_name' => $command_name,
        'command_line' => $command_line,
        'use'          => $use,
    }),
  }
}
