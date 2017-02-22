class nagios::command::nrpe_timeout(
    $server_name = undef
) {
  nagios::type::command {
    'check_nrpe_timeout':
       command_line => '/usr/lib/nagios/plugins/check_nrpe -t $ARG1$ -H $HOSTADDRESS$ -c $ARG2$ -a $ARG3$',
       server_name => $server_name
  }
  
  nagios::type::command {
    'check_nrpe_timeout_port':
       command_line => '/usr/lib/nagios/plugins/check_nrpe -t $ARG1$ -H $HOSTADDRESS$ -c $ARG2$ -p $ARG3$ -a $ARG4$',
       server_name => $server_name
  }

  nagios::type::command {
    'check_nrpe_1arg_timeout':
       command_line => '/usr/lib/nagios/plugins/check_nrpe -t $ARG1$ -H $HOSTADDRESS$ -c $ARG2$',
       server_name => $server_name
  }
  
  nagios::type::command {
    'check_nrpe_1arg_timeout_port':
       command_line => '/usr/lib/nagios/plugins/check_nrpe -t $ARG1$ -H $HOSTADDRESS$ -c $ARG2$ -p $ARG3$',
       server_name => $server_name
  }
}
