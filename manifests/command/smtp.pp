# @summary Declares the check_smtp and check_ssmtp based commands.
#
# @param skip Commands not to declare because the distribution already does.
class nagios::command::smtp (
  Array[String[1]] $skip = [],
) {
  $commands = {
    'check_smtp'       => '$USER1$/check_smtp -H $ARG1$ -p $ARG2$',
    'check_ssmtp'      => '$USER1$/check_ssmtp -H $ARG1$ -p $ARG2$ -S',
    'check_smtp_tls'   => '$USER1$/check_smtp -H $ARG1$ -p $ARG2$ -S',
    'check_smtp_cert'  => '$USER1$/check_smtp -H $ARG1$ -p $ARG2$ -S -D $ARG3$',
    'check_ssmtp_cert' => '$USER1$/check_ssmtp -H $ARG1$ -p $ARG2$ -S -D $ARG3$',
  }

  ($commands - $skip).each |String $command, String $command_line| {
    nagios::type::command { $command:
      command_line => $command_line,
    }
  }
}
