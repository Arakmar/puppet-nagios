class nagios::command::imap_pop3(
    $server_name = undef
) {
  case $operatingsystem {
    debian,ubuntu: { }  # Debian/Ubuntu already define those checks
    default: {
      nagios::type::command {
        'check_imap':
          command_line => '$USER1$/check_imap -H $ARG1$ -p $ARG2$',
          server_name => $server_name;
      }
    }
  }

  nagios::type::command {
    'check_imap_ssl':
      command_line => '$USER1$/check_imap -H $ARG1$ -p $ARG2$ -S',
      server_name => $server_name;
    'check_pop3':
      command_line => '$USER1$/check_pop -H $ARG1$ -p $ARG2$',
      server_name => $server_name;
    'check_pop3_ssl':
      command_line => '$USER1$/check_pop -H $ARG1$ -p $ARG2$ -S',
      server_name => $server_name;
    'check_managesieve':
      command_line => '$USER1$/check_tcp -H $ARG1$ -p 2000',
      server_name => $server_name;
  }
}
