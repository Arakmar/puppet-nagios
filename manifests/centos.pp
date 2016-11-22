class nagios::centos inherits nagios::base {

    Service[nagios]{
        hasstatus => true,
    }

    if $nagios::allow_external_cmd {
        file { '/var/spool/nagios/cmd':
            ensure => 'directory',
            require => Package['nagios'],
            mode => '2660', owner => apache, group => nagios,
        }
    }
}
