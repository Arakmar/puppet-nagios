class nagios::command::smtp(
    $server_name = undef
) {
  case $operatingsystem {
    debian,ubuntu: { }  # Debian/Ubuntu already define those checks
    default: {
      nagios::type::command {
        'check_smtp':
           command_line => '$USER1$/check_smtp -H $ARG1$ -p $ARG2$',
           server_name => $server_name;
        'check_ssmtp':
           command_line => '$USER1$/check_ssmtp -H $ARG1$ -p $ARG2$ -S',
           server_name => $server_name;
      }
    }
  }

  nagios::type::command {
    'check_smtp_tls':
       command_line => '$USER1$/check_smtp -H $ARG1$ -p $ARG2$ -S',
       server_name => $server_name;
    'check_smtp_cert':
       command_line => '$USER1$/check_smtp -H $ARG1$ -p $ARG2$ -S -D $ARG3$',
       server_name => $server_name;
    'check_ssmtp_cert':
       command_line => '$USER1$/check_ssmtp -H $ARG1$ -p $ARG2$ -S -D $ARG3$',
       server_name => $server_name;
  }
}
