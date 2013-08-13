class nagios::command::nrpe_timeout {
  nagios::type::command {
    'check_nrpe_timeout':
       command_line => '/usr/lib/nagios/plugins/check_nrpe -t $ARG1$ -H $HOSTADDRESS$ -c $ARG2$ -a $ARG3$'
  }

  nagios::type::command {
    'check_nrpe_1arg_timeout':
       command_line => '/usr/lib/nagios/plugins/check_nrpe -t $ARG1$ -H $HOSTADDRESS$ -c $ARG2$'
  }
}
