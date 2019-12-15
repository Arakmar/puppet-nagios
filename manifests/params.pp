class nagios::params {
  $check_external_commands = true
  $command_check_interval = '-1'
  $temp_path = '/tmp'

  case $::osfamily {
    'redhat': {
      $package = 'nagios'
      $nrpe_package = 'nagios-plugins-nrpe'
      $plugin_package = 'nagios-plugins'
      $service = 'nagios'
      $user = 'nagios'
      $group = 'nagios'
      $cfg_dir = '/etc/nagios'
      $plugin_dir = $::architecture ? {
        /x86_64/ => '/usr/lib64/nagios/plugins',
        default  => '/usr/lib/nagios/plugins',
      }

      $subcfg_dirs = ['/etc/nagios/conf.d']
      $log_file = '/var/log/nagios/nagios.log'
      $object_cache_file = '/var/spool/nagios/objects.cache'
      $precached_object_file = '/var/spool/nagios/objects.precache'
      $resource_file = '/etc/nagios/private/resource.cfg'
      $status_file = '/var/spool/nagios/status.dat'
      $command_file = '/var/spool/nagios/cmd/nagios.cmd'
      $lock_file = '/var/run/nagios/nagios.pid'
      $temp_file = '/var/spool/nagios/nagios.tmp'
      $admin_email = 'nagios@localhost'
      $admin_pager = 'pagenagios@localhost'
      $enable_environment_macros = true
      $log_archive_path = '/var/log/nagios/archives'
      $check_result_path = '/var/spool/nagios/checkresults'
      $state_retention_file = '/var/spool/nagios/retention.dat'
      $debug_file = 'var/spool/nagios/nagios.debug'
    }
    'debian': {
      $package = 'nagios3'
      $nrpe_package = 'nagios-nrpe-plugin'
      $plugin_package = 'monitoring-plugins'
      $service = 'nagios3'
      $cfg_dir = '/etc/nagios3'
      $user = 'nagios'
      $group = 'nagios'
      $plugin_dir = '/usr/lib/nagios/plugins'

      $subcfg_dirs = ['/etc/nagios-plugins/config', '/etc/nagios3/conf.d']
      $log_file = '/var/log/nagios3/nagios.log'
      $object_cache_file = '/var/cache/nagios3/objects.cache'
      $precached_object_file = '/var/lib/nagios3/objects.precache'
      $resource_file = '/etc/nagios3/resource.cfg'
      $status_file = '/var/cache/nagios3/status.dat'
      $command_file = '/var/lib/nagios3/rw/nagios.cmd'
      $lock_file = '/var/run/nagios3/nagios3.pid'
      $temp_file = '/var/cache/nagios3/nagios.tmp'
      $admin_email = 'root@localhost'
      $admin_pager = 'pageroot@localhost'
      $enable_environment_macros = false
      $log_archive_path = '/var/log/nagios3/archives'
      $check_result_path = '/var/lib/nagios3/spool/checkresults'
      $state_retention_file = '/var/lib/nagios3/retention.dat'
      $debug_file = '/var/log/nagios3/nagios.debug'
    }
    default: { fail("No such operatingsystem: ${::osfamily} yet defined") }
  }
}
