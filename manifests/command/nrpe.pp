class nagios::command::nrpe(
    $server_name = "default"
) {

  # this command runs a program $ARG1$ with arguments $ARG2$
  nagios::type::command {
    'check_nrpe':
       command_line => '/usr/lib/nagios/plugins/check_nrpe -H $HOSTADDRESS$ -c $ARG1$ -a $ARG2$',
       server_name => $server_name
  }

  # this command runs a program $ARG1$ with no arguments
  nagios::type::command {
    'check_nrpe_1arg':
       command_line => '/usr/lib/nagios/plugins/check_nrpe -H $HOSTADDRESS$ -c $ARG1$',
       server_name => $server_name
  }
}
