class nagios::defaults::pnp4nagios
(
    $server_name = undef
) {
    # performance data cmds
    # http://docs.pnp4nagios.org/de/pnp-0.6/config#bulk_mode_mit_npcd
    nagios::type::command {
        'process-service-perfdata-file-pnp4nagios-bulk-npcd':
            server_name => $server_name,
            command_line => '/bin/mv /var/lib/nagios3/service-perfdata /var/spool/pnp4nagios/npcd/service-perfdata.$TIMET$';
        'process-host-perfdata-file-pnp4nagios-bulk-npcd':
            server_name => $server_name,
            command_line => '/bin/mv /var/lib/nagios3/host-perfdata /var/spool/pnp4nagios/npcd/host-perfdata.$TIMET$'
    }
}
