# @summary Declares check_nrpe commands run against an explicit host.
#
# Required on the server by nagios::type::service resources using use_nrpe
# together with nrpe_host.
#
# @param skip Commands not to declare because the distribution already does.
class nagios::command::nrpe_host (
  Array[String[1]] $skip = [],
) {
  $commands = {
    'check_nrpe_host'                   => '$USER1$/check_nrpe -H $ARG1$ -c $ARG2$ -a $ARG3$',
    'check_nrpe_host_port'              => '$USER1$/check_nrpe -H $ARG1$ -c $ARG2$ -p $ARG3$ -a $ARG4$',
    'check_nrpe_1arg_host'              => '$USER1$/check_nrpe -H $ARG1$ -c $ARG2$',
    'check_nrpe_1arg_host_port'         => '$USER1$/check_nrpe -H $ARG1$ -c $ARG2$ -p $ARG3$',
    'check_nrpe_host_timeout'           => '$USER1$/check_nrpe -H $ARG1$ -c $ARG2$ -a $ARG3$ -t $ARG4$',
    'check_nrpe_host_timeout_port'      => '$USER1$/check_nrpe -H $ARG1$ -c $ARG2$ -p $ARG3$ -a $ARG4$ -t $ARG5$',
    'check_nrpe_1arg_host_timeout'      => '$USER1$/check_nrpe -H $ARG1$ -c $ARG2$ -t $ARG3$',
    'check_nrpe_1arg_host_timeout_port' => '$USER1$/check_nrpe -H $ARG1$ -c $ARG2$ -p $ARG3$ -t $ARG4$',
  }

  ($commands - $skip).each |String $command, String $command_line| {
    nagios::type::command { $command:
      command_line => $command_line,
    }
  }
}
