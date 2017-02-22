class nagios::defaults::contactgroups
(
    $server_name = undef
) {
    nagios::type::contactgroup {
        'admins':
            server_name => $server_name,
            contactgroup_alias   => 'Nagios Administrators',
            members => ['root'],
    }

}
