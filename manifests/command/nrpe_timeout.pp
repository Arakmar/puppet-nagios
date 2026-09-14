# @summary Declares check_nrpe commands with an explicit timeout.
#
# Required on the server by nagios::type::service resources using use_nrpe
# without nrpe_host.
#
# @param skip Commands not to declare because the distribution already does.
class nagios::command::nrpe_timeout (
  Array[String[1]] $skip = [],
) {
  $commands = {
    'check_nrpe_timeout'           => '$USER1$/check_nrpe -t $ARG1$ -H $HOSTADDRESS$ -c $ARG2$ -a $ARG3$',
    'check_nrpe_timeout_port'      => '$USER1$/check_nrpe -t $ARG1$ -H $HOSTADDRESS$ -c $ARG2$ -p $ARG3$ -a $ARG4$',
    'check_nrpe_1arg_timeout'      => '$USER1$/check_nrpe -t $ARG1$ -H $HOSTADDRESS$ -c $ARG2$',
    'check_nrpe_1arg_timeout_port' => '$USER1$/check_nrpe -t $ARG1$ -H $HOSTADDRESS$ -c $ARG2$ -p $ARG3$',
  }

  ($commands - $skip).each |String $command, String $command_line| {
    nagios::type::command { $command:
      command_line => $command_line,
    }
  }
}
