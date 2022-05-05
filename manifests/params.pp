class nagios::params {
  $check_external_commands = true
  $command_check_interval = '-1'
  $soft_state_dependencies = 0
  $temp_path = '/tmp'

  $use_authentication = true
  $default_user_name = 'nagiosadmin'
  $ack_no_sticky = true
  $ack_no_send = true

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

      $main_config_file = '/etc/nagios/nagios.cfg'
      $physical_html_path = '/usr/share/nagios/htdocs'
      $url_html_path = '/nagios'
    }
    'debian': {

      if ($::operatingsystem == 'Debian' and versioncmp($::operatingsystemrelease, '8') <= 0) or ($::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '18.04') <= 0) {
        $nagios_major_release = '3'
        $object_cache_file = "/var/cache/nagios${nagios_major_release}/objects.cache"
        $status_file = "/var/cache/nagios${nagios_major_release}/status.dat"
        $temp_file = "/var/cache/nagios${nagios_major_release}/nagios.tmp"
      } else {
        $nagios_major_release = '4'
        $object_cache_file = "/var/lib/nagios${nagios_major_release}/objects.cache"
        $status_file = "/var/lib/nagios${nagios_major_release}/status.dat"
        $temp_file = "/var/lib/nagios${nagios_major_release}/nagios.tmp"
      }

      $package = "nagios${nagios_major_release}"
      $nrpe_package = 'nagios-nrpe-plugin'
      $plugin_package = 'monitoring-plugins'
      $service = "nagios${nagios_major_release}"
      $cfg_dir = "/etc/nagios${nagios_major_release}"
      $user = 'nagios'
      $group = 'nagios'
      $plugin_dir = '/usr/lib/nagios/plugins'

      $subcfg_dirs = ['/etc/nagios-plugins/config', "/etc/nagios${nagios_major_release}/conf.d"]
      $log_file = "/var/log/nagios${nagios_major_release}/nagios.log"

      $precached_object_file = "/var/lib/nagios${nagios_major_release}/objects.precache"
      $resource_file = "/etc/nagios${nagios_major_release}/resource.cfg"
      $command_file = "/var/lib/nagios${nagios_major_release}/rw/nagios.cmd"
      $lock_file = "/var/run/nagios${nagios_major_release}/nagios${nagios_major_release}.pid"
      $admin_email = 'root@localhost'
      $admin_pager = 'pageroot@localhost'
      $enable_environment_macros = false
      $log_archive_path = "/var/log/nagios${nagios_major_release}/archives"
      $check_result_path = "/var/lib/nagios${nagios_major_release}/spool/checkresults"
      $state_retention_file = "/var/lib/nagios${nagios_major_release}/retention.dat"
      $debug_file = "/var/log/nagios${nagios_major_release}/nagios.debug"

      $main_config_file = "/etc/nagios${nagios_major_release}/nagios.cfg"
      $physical_html_path = "/usr/share/nagios${nagios_major_release}/htdocs"
      $url_html_path = "/nagios${nagios_major_release}"
    }
    default: { fail("No such operatingsystem: ${::osfamily} yet defined") }
  }
}
