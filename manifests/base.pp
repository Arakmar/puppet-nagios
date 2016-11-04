class nagios::base {
    # include the variables
    include nagios::defaults::vars

    package { 'nagios':
        alias => 'nagios',
        ensure => present,
    }

    service { 'nagios':
        ensure => running,
        enable => true,
        #hasstatus => true, #fixme!
        require => Package['nagios'],
    }

    # this file should contain all the nagios_puppet-paths:
    file { 'nagios_main_cfg':
            path => "${nagios::defaults::vars::int_cfgdir}/nagios.cfg",
            source => [ "puppet:///modules/site_nagios/configs/${::fqdn}/nagios.cfg",
                        "puppet:///modules/site_nagios/configs/${::operatingsystem}/${::lsbdistcodename}/nagios.cfg",
                        "puppet:///modules/site_nagios/configs/${::operatingsystem}/nagios.cfg",
                        "puppet:///modules/site_nagios/configs/nagios.cfg",
                        "puppet:///modules/nagios/configs/${::operatingsystem}/${::lsbdistcodename}/nagios.cfg",
                        "puppet:///modules/nagios/configs/${::operatingsystem}/nagios.cfg",
                        "puppet:///modules/nagios/configs/nagios.cfg" ],
            notify => Service['nagios'],
            require => Package['nagios'],
            mode => '0644', owner => root, group => root;
    }

    file { 'nagios_cgi_cfg':
        path => "${nagios::defaults::vars::int_cfgdir}/cgi.cfg",
        source => [ "puppet:///modules/site_nagios/configs/${::fqdn}/cgi.cfg",
                    "puppet:///modules/site_nagios/configs/${::operatingsystem}/${::lsbdistcodename}/cgi.cfg",
                    "puppet:///modules/site_nagios/configs/${::operatingsystem}/cgi.cfg",
                    "puppet:///modules/site_nagios/configs/cgi.cfg",
                    "puppet:///modules/nagios/configs/${::operatingsystem}/${::lsbdistcodename}/cgi.cfg",
                    "puppet:///modules/nagios/configs/${::operatingsystem}/cgi.cfg",
                    "puppet:///modules/nagios/configs/cgi.cfg" ],
        mode => '0644', owner => 'root', group => 0,
        require => Package['nagios'],
    }

    file { 'nagios_htpasswd':
        path => "${nagios::defaults::vars::int_cfgdir}/htpasswd.users",
        source => [ "puppet:///modules/site_nagios/configs/${::fqdn}/htpasswd.users",
                "puppet:///modules/site_nagios/configs/${::operatingsystem}/${::lsbdistcodename}/htpasswd.users",
                "puppet:///modules/site_nagios/configs/${::operatingsystem}/htpasswd.users",
                "puppet:///modules/site_nagios/configs/htpasswd.users",
                "puppet:///modules/nagios/configs/${::operatingsystem}/${::lsbdistcodename}/htpasswd.users",
                "puppet:///modules/nagios/configs/${::operatingsystem}/htpasswd.users",
                "puppet:///modules/nagios/configs/htpasswd.users" ],
        require => Package['nagios'],
        mode => '0640', owner => root, group => apache;
    }

    file { 'nagios_resource_cfg':
        path => "${nagios::defaults::vars::int_cfgdir}/resource.cfg",
        source => [ "puppet:///modules/site_nagios/configs/${::operatingsystem}/private/resource.cfg.${::architecture}",
                    "puppet:///modules/nagios/configs/${::operatingsystem}/private/resource.cfg.${::architecture}" ],
        notify => Service['nagios'],
        require => Package['nagios'],
        owner => root, group => nagios, mode => '0640';
    }

    file { 'nagios_confd':
        path => "${nagios::defaults::vars::int_cfgdir}/conf.d/",
        ensure => directory,
        purge => true,
        recurse => true,
        notify => Service['nagios'],
        require => Package['nagios'],
        mode => '0750', owner => root, group => nagios;
    }

    nagios::collect_type {
        "command": destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
                server_name => $nagios::defaults::vars::int_server_name;
        "contact": destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
                server_name => $nagios::defaults::vars::int_server_name;
        "contactgroup": destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
                server_name => $nagios::defaults::vars::int_server_name;
        "hosts": destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
                server_name => $nagios::defaults::vars::int_server_name;
        "service": destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
                server_name => $nagios::defaults::vars::int_server_name;
        "hostgroup": destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
                server_name => $nagios::defaults::vars::int_server_name;
        "hostextinfo": destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
                server_name => $nagios::defaults::vars::int_server_name;
        "timeperiod": destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
                server_name => $nagios::defaults::vars::int_server_name;
    }

    # manage nagios cfg files
    # must be defined after exported resource overrides and cfg file defs
    file { 'nagios_cfgdir':
        path => "${nagios::defaults::vars::int_cfgdir}/",
        ensure => directory,
        recurse => true,
        purge => true,
        notify => Service['nagios'],
        require => Package['nagios'],
        mode => '0755', owner => root, group => root;
    }
}
