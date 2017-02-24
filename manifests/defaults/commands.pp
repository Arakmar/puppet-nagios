class nagios::defaults::commands {

  include nagios::command::http
  include nagios::command::smtp
  include nagios::command::imap_pop3

  nagios::type::command {
    check_dummy:
      command_line => '$USER1$/check_dummy $ARG1$';
    check_http_url:
      command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$';
    check_http_url_regex:
      command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$ -e $ARG3$';
    check_https_url:
      command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$';
    check_https_url_regex:
      command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$ -e $ARG3$';
    check_mysql_db:
      command_line => '$USER1$/check_mysql -H $ARG1$ -P $ARG2$ -u $ARG3$ -p $ARG4$ -d $ARG5$';
    check_ntp_time:
      command_line => '$USER1$/check_ntp_time -H $HOSTADDRESS$ -w 0.5 -c 1';
    check_silc:
      command_line => '$USER1$/check_tcp -p 706 -H $ARG1$';
    check_sobby:
      command_line => '$USER1$/check_tcp -H $ARG1$ -p $ARG2$';
    check_git:
      command_line => '$USER1$/check_tcp -H $ARG1$ -p 9418';
    check_ping:
      command_line => '$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$';
    check-host-alive:
      command_line => '$USER1$/check_ping -H $HOSTADDRESS$ -w 5000,100% -c 5000,100% -p 1';
    check_tcp:
      command_line => '$USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$';
    check_udp:
      command_line => '$USER1$/check_udp -H $HOSTADDRESS$ -p $ARG1$';
    check_ssh:
      command_line => '$USER1$/check_ssh $HOSTADDRESS$';
    check_ssh_port:
      command_line => '$USER1$/check_ssh -p $ARG1$ $HOSTADDRESS$';
    check_ssh_port_host:
      command_line => '$USER1$/check_ssh -p $ARG1$ $ARG2$';
    check_http:
      command_line => '$USER1$/check_http -H $HOSTADDRESS$ -I $HOSTADDRESS$';
    check_https:
      command_line => '$USER1$/check_http --ssl -H $HOSTADDRESS$ -I $HOSTADDRESS$';
    check_https_cert:
      command_line => '$USER1$/check_http --ssl -C 20 -H $HOSTADDRESS$ -I $HOSTADDRESS$';
    check_mysql:
      command_line => '$USER1$/check_mysql -H $ARG1$ -P $ARG2$ -u $ARG3$ -p $ARG4$';
  }

    # commands for services defined by other modules

    nagios::type::command {
        # from apache module
        http_port:
            command_line => '$USER1$/check_http -p $ARG1$ -H $HOSTADDRESS$ -I $HOSTADDRESS$';
        check_http_port_url_content:
            command_line => '$USER1$/check_http -H $ARG1$ -p $ARG2$ -u $ARG3$ -s $ARG4$';
        check_https_port_url_content:
            command_line => '$USER1$/check_http --ssl -H $ARG1$ -p $ARG2$ -u $ARG3$ -s $ARG4$';
        check_http_url_content:
            command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$ -s $ARG3$';
        check_https_url_content:
            command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$ -s $ARG3$';
    }

    # notification commands

    $mail_cmd_location = $::operatingsystem ? {
      centos => '/bin/mail',
      default => '/usr/bin/mail'
    }

    nagios::type::command {
        'notify-host-by-email':
            command_line => "/usr/bin/printf \"%b\" \"***** Nagios *****\\n\\nNotification Type: \$NOTIFICATIONTYPE\$\\nHost: \$HOSTNAME\$\\nState: \$HOSTSTATE\$\\nAddress: \$HOSTADDRESS\$\\nInfo: \$HOSTOUTPUT\$\\n\\nDate/Time: \$LONGDATETIME\$\\n\" | ${mail_cmd_location} -s \"** \$NOTIFICATIONTYPE\$ Host Alert: \$HOSTNAME\$ is \$HOSTSTATE\$ **\" \$CONTACTEMAIL\$";
        'notify-service-by-email':
            command_line => "/usr/bin/printf \"%b\" \"***** Nagios *****\\n\\nNotification Type: \$NOTIFICATIONTYPE\$\\n\\nService: \$SERVICEDESC\$\\nHost: \$HOSTALIAS\$\\nAddress: \$HOSTADDRESS\$\\nState: \$SERVICESTATE\$\\n\\nDate/Time: \$LONGDATETIME\$\\n\\nAdditional Info:\\n\\n\$SERVICEOUTPUT\$\" | ${mail_cmd_location} -s \"** \$NOTIFICATIONTYPE\$ Service Alert: \$HOSTALIAS\$/\$SERVICEDESC\$ is \$SERVICESTATE\$ **\" \$CONTACTEMAIL\$";
    }

}
