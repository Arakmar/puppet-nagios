# @summary Declares the check_http based commands used by nagios::service::http.
#
# @param ssl_warning_delay Days before certificate expiry that trigger a warning.
# @param skip Commands not to declare because the distribution already does.
class nagios::command::http (
  Nagios::Interval $ssl_warning_delay = 5,
  Array[String[1]] $skip              = [],
) {
  $commands = {
    'check_http'                    => '$USER1$/check_http -k \'Accept: */*\' --sni -H $HOSTADDRESS$ -I $HOSTADDRESS$',
    'check_https'                   => '$USER1$/check_http -k \'Accept: */*\' --ssl --sni -H $HOSTADDRESS$ -I $HOSTADDRESS$',
    'http_port'                     => '$USER1$/check_http -k \'Accept: */*\' --sni -p $ARG1$ -H $HOSTADDRESS$ -I $HOSTADDRESS$',
    'check_http_url_content'        => '$USER1$/check_http -k \'Accept: */*\' --sni -H $ARG1$ -u $ARG2$ -s $ARG3$ -f $ARG4$',
    'check_http_port_url_content'   => '$USER1$/check_http -k \'Accept: */*\' --sni -H $ARG1$ -p $ARG2$ -u $ARG3$ -s $ARG4$ -f $ARG5$',
    'check_https_url_content'       => '$USER1$/check_http -k \'Accept: */*\' --ssl --sni -H $ARG1$ -u $ARG2$ -s $ARG3$ -f $ARG4$',
    'check_https_port_url_content'  => '$USER1$/check_http -k \'Accept: */*\' --ssl --sni -H $ARG1$ -p $ARG2$ -u $ARG3$ -s $ARG4$ -f $ARG5$',
    'check_http_code'               => '$USER1$/check_http -k \'Accept: */*\' --sni -H $ARG1$ -u $ARG2$ -e $ARG3$',
    'check_http_port_code'          => '$USER1$/check_http -k \'Accept: */*\' --sni -H $ARG1$ -p $ARG2$ -u $ARG3$ -e $ARG4$',
    'check_https_code'              => '$USER1$/check_http -k \'Accept: */*\' --ssl --sni -H $ARG1$ -u $ARG2$ -e $ARG3$',
    'check_https_port_code'         => '$USER1$/check_http -k \'Accept: */*\' --ssl --sni -H $ARG1$ -p $ARG2$ -u $ARG3$ -e $ARG4$',
    'check_https_cert'              => "\$USER1\$/check_http -k 'Accept: */*' --ssl --sni -H \$ARG1\$ -C ${ssl_warning_delay}",
    'check_https_port_cert'         => "\$USER1\$/check_http -k 'Accept: */*' --ssl --sni -H \$ARG1\$ -p \$ARG2\$ -C ${ssl_warning_delay}",
    'check_http_auth_content'       => '$USER1$/check_http -k \'Accept: */*\' --sni -H $ARG1$ -u $ARG2$ -s $ARG3$ -a $ARG4$:$ARG5$ -f $ARG6$',
    'check_http_port_auth_content'  => '$USER1$/check_http -k \'Accept: */*\' --sni -H $ARG1$ -p $ARG2$ -u $ARG3$ -s $ARG4$ -a $ARG5$:$ARG6$ -f $ARG7$',
    'check_https_auth_content'      => '$USER1$/check_http -k \'Accept: */*\' --ssl --sni -H $ARG1$ -u $ARG2$ -s $ARG3$ -a $ARG4$:$ARG5$ -f $ARG6$',
    'check_https_port_auth_content' => '$USER1$/check_http -k \'Accept: */*\' --ssl --sni -H $ARG1$ -p $ARG2$ -u $ARG3$ -s $ARG4$ -a $ARG5$:$ARG6$ -f $ARG7$',
  }

  ($commands - $skip).each |String $command, String $command_line| {
    nagios::type::command { $command:
      command_line => $command_line,
    }
  }
}
