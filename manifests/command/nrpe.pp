class nagios::command::nrpe {
  nagios::type::command {
    'check_nrpe':
      command_line => '/usr/lib/nagios/plugins/check_nrpe -H $HOSTADDRESS$ -c $ARG1$ -a $ARG2$';
    'check_nrpe_port':
      command_line => '/usr/lib/nagios/plugins/check_nrpe -H $HOSTADDRESS$ -c $ARG1$ -p $ARG2$ -a $ARG3$';
    'check_nrpe_1arg':
      command_line => '/usr/lib/nagios/plugins/check_nrpe -H $HOSTADDRESS$ -c $ARG1$';
    'check_nrpe_1arg_port':
      command_line => '/usr/lib/nagios/plugins/check_nrpe -H $HOSTADDRESS$ -c $ARG1$ -p $ARG2$';
  }
}
