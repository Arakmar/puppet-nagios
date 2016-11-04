class nagios::nrpe(
    $processorcount = '1',
    $user = 'nagios',
    $group = 'nagios',
    $log_facility = 'daemon',
    $pid_file = '/var/run/nagios/nrpe.pid',
    $server_port = '5666',
    $server_address = 'UNSET',
    $allowed_hosts = ['127.0.0.1'],
    $dont_blame_nrpe = '0',
    $command_prefix = 'UNSET',
    $nrpedebug = '0',
    $command_timeout = '600',
    $connection_timeout = '300',
    $allow_weak_random_seed = 'UNSET',
    $includecfg = 'UNSET'
) {
  
    case $::operatingsystem {
        'archlinux': {
          $cfgdir = '/etc/nrpe'
          $cfgfile = '/etc/nrpe/nrpe.cfg'
          $plugindir = '/usr/lib/monitoring-plugins'
          include nagios::nrpe::archlinux
        }
        'debian': {
          $cfgdir = '/etc/nagios'
          $cfgfile = '/etc/nagios/nrpe.cfg'
          $plugindir = '/usr/lib/nagios/plugins'
          include nagios::nrpe::debian
        }
        default: { fail("No such operatingsystem: ${::operatingsystem} yet defined") }
    }
    
    file { 
        "$cfgdir": 
            ensure => directory;
        "$cfgdir/nrpe.d": 
            ensure => directory,
            purge => true,
            recurse => true
    }

    file { "$cfgfile":
	    content => template('nagios/nrpe/nrpe.cfg'),
	    owner => root, group => 0, mode => '644';
    }
    
    # default commands
    nagios::nrpe::command { "basic_nrpe":
        source => [ "puppet:///modules/site_nagios/configs/nrpe/nrpe_commands.${fqdn}.cfg",
                    "puppet:///modules/site_nagios/configs/nrpe/nrpe_commands.cfg",
                    "puppet:///modules/nagios/nrpe/nrpe_commands.cfg" ],
    }
    # the check for load should be customized for each server based on number
    # of CPUs and the type of activity.
    $warning_1_threshold = 7 * $processorcount
    $warning_5_threshold = 6 * $processorcount
    $warning_15_threshold = 5 * $processorcount
    $critical_1_threshold = 10 * $processorcount
    $critical_5_threshold = 9 * $processorcount
    $critical_15_threshold = 8 * $processorcount
    nagios::nrpe::command { "check_load":
        command => "check_load", arguments => "-w ${warning_1_threshold},${warning_5_threshold},${warning_15_threshold} -c ${critical_1_threshold},${critical_5_threshold},${critical_15_threshold}",
    }
}
