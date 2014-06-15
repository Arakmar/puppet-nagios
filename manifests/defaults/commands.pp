class nagios::defaults::commands
(
    $server_name = "default"
) {

  class {
      "nagios::command::http":
          server_name => $server_name;
      "nagios::command::smtp":
          server_name => $server_name;
      "nagios::command::imap_pop3":
          server_name => $server_name;
  }

  # common service commands
  case $::operatingsystem {
      debian,ubuntu: {
        nagios::type::command {
          check_dummy:
            server_name => $server_name,
            command_line => '$USER1$/check_dummy $ARG1$';
          check_http_url:
            server_name => $server_name,
            command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$';
          check_http_url_regex:
            server_name => $server_name,
            command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$ -e $ARG3$';
          check_https_url:
            server_name => $server_name,
            command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$';
          check_https_url_regex:
            server_name => $server_name,
            command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$ -e $ARG3$';
          check_mysql_db:
            server_name => $server_name,
            command_line => '$USER1$/check_mysql -H $ARG1$ -P $ARG2$ -u $ARG3$ -p $ARG4$ -d $ARG5$';
          check_ntp_time:
            server_name => $server_name,
            command_line => '$USER1$/check_ntp_time -H $HOSTADDRESS$ -w 0.5 -c 1';
          check_silc:
            server_name => $server_name,
            command_line => '$USER1$/check_tcp -p 706 -H $ARG1$';
          check_sobby:
            server_name => $server_name,
            command_line => '$USER1$/check_tcp -H $ARG1$ -p $ARG2$';
          check_jabber:
            server_name => $server_name,
            command_line => '$USER1$/check_jabber -H $ARG1$';
          check_git:
            server_name => $server_name,
            command_line => '$USER1$/check_tcp -H $ARG1$ -p 9418';
        }
      }
      default: {
        nagios::type::command {
          check_dummy:
            server_name => $server_name,
            command_line => '$USER1$/check_dummy $ARG1$';
          check_ping:
            server_name => $server_name,
            command_line => '$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$';
          check-host-alive:
            server_name => $server_name,
            command_line => '$USER1$/check_ping -H $HOSTADDRESS$ -w 5000,100% -c 5000,100% -p 1';
          check_tcp:
            server_name => $server_name,
            command_line => '$USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$';
          check_udp:
            server_name => $server_name,
            command_line => '$USER1$/check_udp -H $HOSTADDRESS$ -p $ARG1$';
          check_load:
            server_name => $server_name,
            command_line => '$USER1$/check_load --warning=$ARG1$,$ARG2$,$ARG3$ --critical=$ARG4$,$ARG5$,$ARG6$';
          check_disk:
            server_name => $server_name,
            command_line => '$USER1$/check_disk -w $ARG1$ -c $ARG2$ -e -p $ARG3$';
          check_all_disks:
            server_name => $server_name,
            command_line => '$USER1$/check_disk -w $ARG1$ -c $ARG2$ -e';
          check_ssh:
            server_name => $server_name,
            command_line => '$USER1$/check_ssh $HOSTADDRESS$';
          check_ssh_port:
            server_name => $server_name,
            command_line => '$USER1$/check_ssh -p $ARG1$ $HOSTADDRESS$';
          check_ssh_port_host:
            server_name => $server_name,
            command_line => '$USER1$/check_ssh -p $ARG1$ $ARG2$';
          check_http:
            server_name => $server_name,
            command_line => '$USER1$/check_http -H $HOSTADDRESS$ -I $HOSTADDRESS$';
          check_https:
            server_name => $server_name,
            command_line => '$USER1$/check_http --ssl -H $HOSTADDRESS$ -I $HOSTADDRESS$';
          check_https_cert:
            server_name => $server_name,
            command_line => '$USER1$/check_http --ssl -C 20 -H $HOSTADDRESS$ -I $HOSTADDRESS$';
          check_http_url:
            server_name => $server_name,
            command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$';
          check_http_url_regex:
            server_name => $server_name,
            command_line => '$USER1$/check_http -H $ARG1$ -p $ARG2$ -u $ARG3$ -e $ARG4$';
          check_https_url:
            server_name => $server_name,
            command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$';
          check_https_url_regex:
            server_name => $server_name,
            command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$ -e $ARG3$';
          check_mysql:
            server_name => $server_name,
            command_line => '$USER1$/check_mysql -H $ARG1$ -P $ARG2$ -u $ARG3$ -p $ARG4$';
          check_mysql_db:
            server_name => $server_name,
            command_line => '$USER1$/check_mysql -H $ARG1$ -P $ARG2$ -u $ARG3$ -p $ARG4$ -d $ARG5$';
          check_ntp_time:
            server_name => $server_name,
            command_line => '$USER1$/check_ntp_time -H $HOSTADDRESS$ -w 0.5 -c 1';
          check_silc:
            server_name => $server_name,
            command_line => '$USER1$/check_tcp -p 706 -H $ARG1$';
          check_sobby:
            server_name => $server_name,
            command_line => '$USER1$/check_tcp -H $ARG1$ -p $ARG2$';
          check_jabber:
            server_name => $server_name,
            command_line => '$USER1$/check_jabber -H $ARG1$';
          check_git:
            server_name => $server_name,
            command_line => '$USER1$/check_tcp -H $ARG1$ -p 9418';
        }
      }
  }

    # commands for services defined by other modules

    nagios::type::command {
        # from apache module
        http_port:
            server_name => $server_name,
            command_line => '$USER1$/check_http -p $ARG1$ -H $HOSTADDRESS$ -I $HOSTADDRESS$';

        check_http_port_url_content:
            server_name => $server_name,
            command_line => '$USER1$/check_http -H $ARG1$ -p $ARG2$ -u $ARG3$ -s $ARG4$';
        check_https_port_url_content:
            server_name => $server_name,
            command_line => '$USER1$/check_http --ssl -H $ARG1$ -p $ARG2$ -u $ARG3$ -s $ARG4$';
        check_http_url_content:
            server_name => $server_name,
            command_line => '$USER1$/check_http -H $ARG1$ -u $ARG2$ -s $ARG3$';
        check_https_url_content:
            server_name => $server_name,
            command_line => '$USER1$/check_http --ssl -H $ARG1$ -u $ARG2$ -s $ARG3$';

        # from bind module
        check_dig2:
           server_name => $server_name,
           command_line => '$USER1$/check_dig -H $HOSTADDRESS$ -l $ARG1$ --record_type=$ARG2$';

        # from mysql module
        check_mysql_health:
           server_name => $server_name,
           command_line => '$USER1$/check_mysql_health --hostname $ARG1$ --port $ARG2$ --username $ARG3$ --password $ARG4$ --mode $ARG5$ --database $ARG6$ $ARG7$ $ARG8$';

        # better check_dns
        check_dns2:
          server_name => $server_name,
          command_line => '$USER1$/check_dns2 -c $ARG1$ A $ARG2$';

        # dnsbl checking
        check_dnsbl:
          server_name => $server_name,
          command_line => '$USER1$/check_dnsbl -H $ARG1$';
    }

    # notification commands

    $mail_cmd_location = $::operatingsystem ? {
      centos => '/bin/mail',
      default => '/usr/bin/mail'
    }

    nagios::type::command {
        'notify-host-by-email':
            server_name => $server_name,
            command_line => "/usr/bin/printf \"%b\" \"***** Nagios *****\\n\\nNotification Type: \$NOTIFICATIONTYPE\$\\nHost: \$HOSTNAME\$\\nState: \$HOSTSTATE\$\\nAddress: \$HOSTADDRESS\$\\nInfo: \$HOSTOUTPUT\$\\n\\nDate/Time: \$LONGDATETIME\$\\n\" | ${mail_cmd_location} -s \"** \$NOTIFICATIONTYPE\$ Host Alert: \$HOSTNAME\$ is \$HOSTSTATE\$ **\" \$CONTACTEMAIL\$";
        'notify-service-by-email':
            server_name => $server_name,
            command_line => "/usr/bin/printf \"%b\" \"***** Nagios *****\\n\\nNotification Type: \$NOTIFICATIONTYPE\$\\n\\nService: \$SERVICEDESC\$\\nHost: \$HOSTALIAS\$\\nAddress: \$HOSTADDRESS\$\\nState: \$SERVICESTATE\$\\n\\nDate/Time: \$LONGDATETIME\$\\n\\nAdditional Info:\\n\\n\$SERVICEOUTPUT\$\" | ${mail_cmd_location} -s \"** \$NOTIFICATIONTYPE\$ Service Alert: \$HOSTALIAS\$/\$SERVICEDESC\$ is \$SERVICESTATE\$ **\" \$CONTACTEMAIL\$";
    }

}
