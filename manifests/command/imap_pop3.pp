# @summary Declares the IMAP, POP3 and ManageSieve check commands.
#
# @param skip Commands not to declare because the distribution already does.
class nagios::command::imap_pop3 (
  Array[String[1]] $skip = [],
) {
  $commands = {
    'check_imap'        => '$USER1$/check_imap -H $ARG1$ -p $ARG2$',
    'check_imap_ssl'    => '$USER1$/check_imap -H $ARG1$ -p $ARG2$ -S',
    'check_pop3'        => '$USER1$/check_pop -H $ARG1$ -p $ARG2$',
    'check_pop3_ssl'    => '$USER1$/check_pop -H $ARG1$ -p $ARG2$ -S',
    'check_managesieve' => '$USER1$/check_tcp -H $ARG1$ -p 2000',
  }

  ($commands - $skip).each |String $command, String $command_line| {
    nagios::type::command { $command:
      command_line => $command_line,
    }
  }
}
