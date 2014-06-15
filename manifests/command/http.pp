class nagios::command::http(
    $server_name = "default",
    $ssl_warning_delay = '5',
) {

    nagios::type::command {"http_string":
        command_name => "check_http_string",
        command_line => '$USER1$/check_http -I $HOSTADDRESS$ -H $ARG1$ -u $ARG2$ -s $ARG3$',
        server_name => $server_name
    }
    nagios::type::command {"http_auth_string":
        command_name => "check_http_auth_string",
        command_line => '$USER1$/check_http -I $HOSTADDRESS$ -H $ARG1$ -u $ARG2$ -s $ARG3$ -a $ARG4$:$ARG5$',
        server_name => $server_name
    }
    nagios::type::command {"https_string":
        command_name => "check_https_string",
        command_line => '$USER1$/check_http --ssl --sni -I $HOSTADDRESS$ -H $ARG1$ -u $ARG2$ -s $ARG3$',
        server_name => $server_name
    }
    nagios::type::command {"https_auth_string":
        command_name => "check_https_auth_string",
        command_line => '$USER1$/check_http --ssl --sni -I $HOSTADDRESS$ -H $ARG1$ -u $ARG2$ -s $ARG3$ -a $ARG4$:$ARG5$',
        server_name => $server_name
    }
    nagios::type::command {"https_cert":
        command_name => "check_https_cert",
        command_line => "\$USER1\$/check_http --ssl --sni -I \$HOSTADDRESS\$ -H \$ARG1\$ -C ${ssl_warning_delay}",
        server_name => $server_name
    }
    nagios::type::command {"http_code":
        command_name => "check_http_code",
        command_line => '$USER1$/check_http -I $HOSTADDRESS$ -H $ARG1$ -u $ARG2$ -e $ARG3$',
        server_name => $server_name
    }
}
