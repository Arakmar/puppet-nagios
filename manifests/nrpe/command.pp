define nagios::nrpe::command (
    $ensure = present,
    $command = '',
    $arguments = '',
    $expand_plugindir = true,
    $use_sudo = false,
    $source = ''
)
{
    if ($command == '' and $source == '') {
        fail ( "Either one of 'command_line' or 'source' must be given to nagios::nrpe::command." )
    }

    file { "${nagios::nrpe::cfgdir}/nrpe.d/${name}_command.cfg":
                    ensure => $ensure,
                    mode => '644', owner => root, group => 0,
                    notify => Service['nagios-nrpe-server'],
                    require => File["${nagios::nrpe::cfgdir}/nrpe.d"]
    }

    case $source {
        '': {
             File["${nagios::nrpe::cfgdir}/nrpe.d/${name}_command.cfg"] {
                content => template( "nagios/nrpe/nrpe_command.erb" ),
            }
        }
        default: {
            File["${nagios::nrpe::cfgdir}/nrpe.d/${name}_command.cfg"] {
                source => $source,
            }
        }
    }
}
