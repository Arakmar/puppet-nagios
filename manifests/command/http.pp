class nagios::command::http (
  $ssl_warning_delay = '5',
) {
  case $::osfamily {
    'debian': { }
    default: {
      nagios::type::command {
        'check_http':
          command_line => '$USER1$/check_http -H $HOSTADDRESS$ -I $HOSTADDRESS$';
        'check_https':
          command_line => '$USER1$/check_http --ssl -H $HOSTADDRESS$ -I $HOSTADDRESS$';
      }
    }
  }
  nagios::type::command {
    'http_port':
      command_line => '$USER1$/check_http -p $ARG1$ -H $HOSTADDRESS$ -I $HOSTADDRESS$';
    'check_http_port_url_content':
      command_line => '$USER1$/check_http -H $ARG1$ -p $ARG2$ -u $ARG3$ -s $ARG4$ -f $ARG5$';
    'check_https_port_url_content':
      command_line => '$USER1$/check_http --ssl -H $ARG1$ -p $ARG2$ -u $ARG3$ -s $ARG4$ -f $ARG5$';
    'check_http_port_code':
      command_line => '$USER1$/check_http -H $ARG1$ -p $ARG2$ -u $ARG3$ -e $ARG4$';
    'check_https_port_code':
      command_line => '$USER1$/check_http --ssl -H $ARG1$ -p $ARG2$ -u $ARG3$ -e $ARG4$';
    'check_http_url_content':
      command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$ -s $ARG3$ -f $ARG4$';
    'check_https_url_content':
      command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$ -s $ARG3$ -f $ARG4$';
    'check_http_code':
      command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$ -e $ARG3$';
    'check_https_code':
      command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$ -e $ARG3$';
    'check_https_cert':
      command_line => "\$USER1\$/check_http --ssl --sni -H \$ARG1\$ -C ${ssl_warning_delay}";
    'check_http_auth_content':
      command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$ -s $ARG3$ -a $ARG4$:$ARG5$ -f $ARG6$';
    'check_https_auth_content':
      command_line => '$USER1$/check_http --ssl --sni -H $ARG1$ -u $ARG2$ -s $ARG3$ -a $ARG4$:$ARG5$ -f $ARG6$';
  }
}
