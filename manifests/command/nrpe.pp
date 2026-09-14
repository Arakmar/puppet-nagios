# @summary Declares check_nrpe commands run against the checked host.
#
# Not included by nagios::defaults because Debian and Ubuntu ship check_nrpe
# and check_nrpe_1arg with the nagios-nrpe-plugin package.
#
# @param skip Commands not to declare because the distribution already does.
class nagios::command::nrpe (
  Array[String[1]] $skip = [],
) {
  $commands = {
    'check_nrpe'           => '$USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$ -a $ARG2$',
    'check_nrpe_port'      => '$USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$ -p $ARG2$ -a $ARG3$',
    'check_nrpe_1arg'      => '$USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$',
    'check_nrpe_1arg_port' => '$USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$ -p $ARG2$',
  }

  ($commands - $skip).each |String $command, String $command_line| {
    nagios::type::command { $command:
      command_line => $command_line,
    }
  }
}
