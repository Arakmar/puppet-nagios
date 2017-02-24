class nagios::defaults::contactgroups {
    nagios::type::contactgroup {
        'admins':
            contactgroup_alias   => 'Nagios Administrators',
            members => ['root'],
    }

}
