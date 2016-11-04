define nagios::config (
    $ensure = present,
    $source = 'absent',
    $content = 'absent',
    $destination = 'absent'
) {
    
    $real_destination = $destination ? {
        'absent' => "${nagios::defaults::vars::int_cfgdir}/conf.d/${name}",
        default => $destination
    }
    
    file {"nagios_${name}":
        ensure => $ensure,
        path => $real_destination,
        notify => Service[nagios],
        owner => root, group => 0, mode => '0644';
    }
    
    case $ensure {
        'absent','purged': {
            # We want to avoid all stuff related to source and content
        }
        default: {
            case $content {
                'absent': {
                    $real_source = $source ? {
                        'absent' => [
                            "puppet:///modules/site_nagios/configs/${::fqdn}/${name}",
                            "puppet:///modules/site_nagios/configs/${::operatingsystem}.${::lsbdistcodename}/${name}",
                            "puppet:///modules/site_nagios/configs/${::operatingsystem}/${name}",
                            "puppet:///modules/site_nagios/configs/${name}",
                            "puppet:///modules/nagios/configs/${::operatingsystem}.${::lsbdistcodename}/${name}",
                            "puppet:///modules/nagios/configs/${::operatingsystem}/${name}",
                            "puppet:///modules/nagios/configs/${name}"
                        ],
                        default => $source,
                    }
                    File["nagios_${name}"]{
                        source => $real_source,
                    }
                }
                default: {
                    File["nagios_${name}"]{
                        content => $content,
                    }
                }
            }
        }
    }
}
