class nagios::command::imap_pop3 {
  case $facts['os']['family'] {
    'debian': { }  # Debian/Ubuntu already define those checks
    default: {
      nagios::type::command {
        'check_imap':
          command_line => '$USER1$/check_imap -H $ARG1$ -p $ARG2$',
      }
    }
  }

  nagios::type::command {
    'check_imap_ssl':
      command_line => '$USER1$/check_imap -H $ARG1$ -p $ARG2$ -S';
    'check_pop3':
      command_line => '$USER1$/check_pop -H $ARG1$ -p $ARG2$';
    'check_pop3_ssl':
      command_line => '$USER1$/check_pop -H $ARG1$ -p $ARG2$ -S';
    'check_managesieve':
      command_line => '$USER1$/check_tcp -H $ARG1$ -p 2000';
  }
}
