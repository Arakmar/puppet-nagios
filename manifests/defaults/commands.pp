# @summary Declares the default check and notification commands.
#
# Also includes nagios::command::http, nagios::command::smtp and
# nagios::command::imap_pop3. Commands shipped by the distribution's plugin
# configuration are skipped through the skip parameter, which module data
# fills in on Debian and Ubuntu.
#
# @param mail_command Path of the mail binary used by the notification commands.
# @param skip Commands not to declare because the distribution already does.
class nagios::defaults::commands (
  Stdlib::Absolutepath $mail_command,
  Array[String[1]]     $skip = [],
) {
  include nagios::command::http
  include nagios::command::smtp
  include nagios::command::imap_pop3

  $commands = {
    'check_ping'              => '$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$',
    'check-host-alive'        => '$USER1$/check_ping -H $HOSTADDRESS$ -w 5000,100% -c 5000,100% -p 1',
    'check_tcp'               => '$USER1$/check_tcp -H $HOSTADDRESS$ -p $ARG1$',
    'check_udp'               => '$USER1$/check_udp -H $HOSTADDRESS$ -p $ARG1$',
    'check_ssh'               => '$USER1$/check_ssh $HOSTADDRESS$',
    'check_ssh_port'          => '$USER1$/check_ssh -p $ARG1$ $HOSTADDRESS$',
    'check_mysql'             => '$USER1$/check_mysql -H $ARG1$ -P $ARG2$ -u $ARG3$ -p $ARG4$',
    'check_other_ping'        => '$USER1$/check_ping -H $ARG3$ -w $ARG1$ -c $ARG2$',
    'check_dummy'             => '$USER1$/check_dummy $ARG1$',
    'check_http_url'          => '$USER1$/check_http -k \'Accept: */*\' -H $ARG1$ -u $ARG2$',
    'check_http_url_regex'    => '$USER1$/check_http -k \'Accept: */*\' -H $ARG1$ -u $ARG2$ -e $ARG3$',
    'check_https_url'         => '$USER1$/check_http -k \'Accept: */*\' --ssl -H $ARG1$ -u $ARG2$',
    'check_https_url_regex'   => '$USER1$/check_http -k \'Accept: */*\' --ssl -H $ARG1$ -u $ARG2$ -e $ARG3$',
    'check_mysql_db'          => '$USER1$/check_mysql -H $ARG1$ -P $ARG2$ -u $ARG3$ -p $ARG4$ -d $ARG5$',
    'check_ntp_time'          => '$USER1$/check_ntp_time -H $HOSTADDRESS$ -w 0.5 -c 1',
    'check_silc'              => '$USER1$/check_tcp -p 706 -H $ARG1$',
    'check_sobby'             => '$USER1$/check_tcp -H $ARG1$ -p $ARG2$',
    'check_git'               => '$USER1$/check_tcp -H $ARG1$ -p 9418',
    'check_ssh_port_host'     => '$USER1$/check_ssh -p $ARG1$ $ARG2$',
    'notify-host-by-email'    => "/usr/bin/printf \"%b\" \"***** Nagios *****\\n\\nNotification Type: \$NOTIFICATIONTYPE\$\\nHost: \$HOSTNAME\$\\nState: \$HOSTSTATE\$\\nAddress: \$HOSTADDRESS\$\\nInfo: \$HOSTOUTPUT\$\\n\\nDate/Time: \$LONGDATETIME\$\\n\" | ${mail_command} -s \"** \$NOTIFICATIONTYPE\$ Host Alert: \$HOSTNAME\$ is \$HOSTSTATE\$ **\" \$CONTACTEMAIL\$",
    'notify-service-by-email' => "/usr/bin/printf \"%b\" \"***** Nagios *****\\n\\nNotification Type: \$NOTIFICATIONTYPE\$\\n\\nService: \$SERVICEDESC\$\\nHost: \$HOSTALIAS\$\\nAddress: \$HOSTADDRESS\$\\nState: \$SERVICESTATE\$\\n\\nDate/Time: \$LONGDATETIME\$\\n\\nAdditional Info:\\n\\n\$SERVICEOUTPUT\$\" | ${mail_command} -s \"** \$NOTIFICATIONTYPE\$ Service Alert: \$HOSTALIAS\$/\$SERVICEDESC\$ is \$SERVICESTATE\$ **\" \$CONTACTEMAIL\$",
  }

  ($commands - $skip).each |String $command, String $command_line| {
    nagios::type::command { $command:
      command_line => $command_line,
    }
  }
}
