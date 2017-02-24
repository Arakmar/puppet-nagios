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
            source => [ "puppet:///modules/nagios/configs/${::osfamily}/${::operatingsystemmajrelease}/nagios.cfg",
                        "puppet:///modules/nagios/configs/${::osfamily}/nagios.cfg",
                        "puppet:///modules/nagios/configs/nagios.cfg" ],
            notify => Service['nagios'],
            require => Package['nagios'],
            mode => '0644', owner => root, group => root;
    }

    file { 'nagios_cgi_cfg':
        path => "${nagios::defaults::vars::int_cfgdir}/cgi.cfg",
        source => [ "puppet:///modules/nagios/configs/${::osfamily}/${::operatingsystemmajrelease}/cgi.cfg",
                    "puppet:///modules/nagios/configs/${::osfamily}/cgi.cfg",
                    "puppet:///modules/nagios/configs/cgi.cfg" ],
        mode => '0644', owner => 'root', group => 0,
        require => Package['nagios'],
    }

    file { 'nagios_resource_cfg':
        path => $nagios::defaults::vars::resource_cfgpath,
        source => [ "puppet:///modules/nagios/configs/${::osfamily}/private/resource.cfg.${::architecture}" ],
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
        "command":
            destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
            exported => false;
        "contact":
            destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
            exported => false;
        "contactgroup":
            destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
            exported => false;
        "hosts":
            destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
            server_name => $nagios::defaults::vars::int_server_name;
        "service":
            destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
            server_name => $nagios::defaults::vars::int_server_name;
        "hostgroup":
            destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
            exported => false;
        "hostextinfo":
            destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
            server_name => $nagios::defaults::vars::int_server_name;
        "timeperiod":
            destdir => "${nagios::defaults::vars::int_cfgdir}/conf.d",
            exported => false;
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
