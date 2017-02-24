class nagios::command::smtp {
  case $::osfamily {
    'debian': { }  # Debian/Ubuntu already define those checks
    default: {
      nagios::type::command {
        'check_smtp':
           command_line => '$USER1$/check_smtp -H $ARG1$ -p $ARG2$';
        'check_ssmtp':
           command_line => '$USER1$/check_ssmtp -H $ARG1$ -p $ARG2$ -S';
      }
    }
  }

  nagios::type::command {
    'check_smtp_tls':
       command_line => '$USER1$/check_smtp -H $ARG1$ -p $ARG2$ -S';
    'check_smtp_cert':
       command_line => '$USER1$/check_smtp -H $ARG1$ -p $ARG2$ -S -D $ARG3$';
    'check_ssmtp_cert':
       command_line => '$USER1$/check_ssmtp -H $ARG1$ -p $ARG2$ -S -D $ARG3$';
  }
}
