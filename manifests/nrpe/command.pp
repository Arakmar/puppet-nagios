define nagios::nrpe::command (
    $ensure = present,
    $command = '',
    $arguments = '',
    $expand_plugindir = "true",
    $source = '' )
{
    if ($command == '' and $source == '') {
        fail ( "Either one of 'command_line' or 'source' must be given to nagios::nrpe::command." )
    }

    if $nagios_nrpe_cfg_dir == '' {
        $nagios_nrpe_cfgdir = $nagios::nrpe::cfgdir
    }

    file { "$nagios_nrpe_cfgdir/nrpe.d/${name}_command.cfg":
                    ensure => $ensure,
                    mode => 644, owner => root, group => 0,
                    notify => Service['nagios-nrpe-server'],
                    require => File [ "$nagios_nrpe_cfgdir/nrpe.d" ]
    }

    case $source {
        '': {
             File["$nagios_nrpe_cfgdir/nrpe.d/${name}_command.cfg"] {
                content => template( "nagios/nrpe/nrpe_command.erb" ),
            }
        }
        default: {
            File["$nagios_nrpe_cfgdir/nrpe.d/${name}_command.cfg"] {
                source => $source,
            }
        }
    }
}
