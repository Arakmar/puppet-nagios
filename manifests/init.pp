# @summary Installs and configures a Nagios 4 server and collects exported object definitions.
#
# The class installs the Nagios, NRPE and plugin packages, renders nagios.cfg,
# cgi.cfg and resource.cfg, and declares one nagios::collect_type per object
# type so that fragments exported by nagios::type::* resources on monitored
# nodes are assembled into conf.d/nagios_<type>.cfg.
#
# Paths and package names default to module Hiera data (data/os/*.yaml). The
# nagios::type::* defines resolve the same keys through lookup(), so override
# them in Hiera rather than with a resource-like class declaration to keep the
# server and its clients consistent.
#
# @example A monitoring server collecting objects targeted at it
#   class { 'nagios':
#     server_name => 'monitoring1',
#   }
#   include nagios::defaults
#
# @param server_name
#   Identifier matched against the server_names of nagios::type::* resources
#   exported by monitored nodes. When undef, fragments exported without any
#   server name are collected.
# @param allow_external_cmd
#   Whether Nagios accepts external commands (check_external_commands).
# @param cgi_authorized_users
#   Users allowed to see and act on every host and service in the CGIs. A
#   string or an array of contact names, `*` for everyone.
# @param soft_state_dependencies
#   Whether dependency logic uses soft states (soft_state_dependencies).
# @param package Name of the Nagios server package.
# @param nrpe_package Name of the check_nrpe plugin package.
# @param plugin_package Name of the monitoring plugins package.
# @param service Name of the Nagios service.
# @param user System user Nagios runs as.
# @param group System group Nagios runs as.
# @param cfg_dir Nagios configuration directory holding nagios.cfg and conf.d.
# @param plugin_dir Directory holding the plugins, exported as $USER1$.
# @param subcfg_dirs Directories listed as cfg_dir in nagios.cfg.
# @param log_file Path of the main log file.
# @param object_cache_file Path of the object cache file.
# @param precached_object_file Path of the precached object file.
# @param resource_file Path of resource.cfg.
# @param status_file Path of the status file.
# @param command_file Path of the external command file.
# @param lock_file Path of the pid/lock file.
# @param temp_file Path of the temporary file.
# @param temp_path Directory for temporary files.
# @param log_archive_path Directory for rotated log files.
# @param check_result_path Directory for check result files.
# @param state_retention_file Path of the state retention file.
# @param debug_file Path of the debug log file.
# @param command_check_interval
#   How often external commands are checked, in seconds, `-1` for as often
#   as possible, or a value suffixed with `s`.
# @param admin_email Value of the $ADMINEMAIL$ macro.
# @param admin_pager Value of the $ADMINPAGER$ macro.
# @param enable_environment_macros Whether macros are exported as environment variables.
# @param main_config_file Path of nagios.cfg as seen by the CGIs.
# @param physical_html_path Filesystem path of the web interface files.
# @param url_html_path URL path of the web interface.
# @param use_authentication Whether the CGIs require authentication.
# @param default_user_name User name assumed by the CGIs when unauthenticated.
# @param ack_no_sticky Whether acknowledgements default to non-sticky.
# @param ack_no_send Whether acknowledgements default to not sending notifications.
class nagios (
  String[1]                                $package,
  String[1]                                $nrpe_package,
  String[1]                                $plugin_package,
  String[1]                                $service,
  String[1]                                $user,
  String[1]                                $group,
  Stdlib::Absolutepath                     $cfg_dir,
  Stdlib::Absolutepath                     $plugin_dir,
  Array[Stdlib::Absolutepath]              $subcfg_dirs,
  Stdlib::Absolutepath                     $log_file,
  Stdlib::Absolutepath                     $object_cache_file,
  Stdlib::Absolutepath                     $precached_object_file,
  Stdlib::Absolutepath                     $resource_file,
  Stdlib::Absolutepath                     $status_file,
  Stdlib::Absolutepath                     $command_file,
  Stdlib::Absolutepath                     $lock_file,
  Stdlib::Absolutepath                     $temp_file,
  Stdlib::Absolutepath                     $temp_path,
  Stdlib::Absolutepath                     $log_archive_path,
  Stdlib::Absolutepath                     $check_result_path,
  Stdlib::Absolutepath                     $state_retention_file,
  Stdlib::Absolutepath                     $debug_file,
  Variant[Integer, Pattern[/\A-?\d+s?\z/]] $command_check_interval,
  String[1]                                $admin_email,
  String[1]                                $admin_pager,
  Boolean                                  $enable_environment_macros,
  Stdlib::Absolutepath                     $main_config_file,
  Stdlib::Absolutepath                     $physical_html_path,
  String[1]                                $url_html_path,
  Boolean                                  $use_authentication,
  String[1]                                $default_user_name,
  Boolean                                  $ack_no_sticky,
  Boolean                                  $ack_no_send,
  Boolean                                  $allow_external_cmd,
  Variant[String[1], Array[String[1], 1]]  $cgi_authorized_users,
  Variant[Boolean, Integer[0, 1]]          $soft_state_dependencies,
  Optional[String[1]]                      $server_name = undef,
) {
  stdlib::ensure_packages([$package, $nrpe_package, $plugin_package])

  $conf_d = "${cfg_dir}/conf.d"

  file { 'nagios_cfgdir':
    ensure  => directory,
    path    => $cfg_dir,
    recurse => true,
    purge   => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package[$package],
    notify  => Service[$service],
  }

  file { 'nagios_main_cfg':
    ensure  => file,
    path    => "${cfg_dir}/nagios.cfg",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('nagios/nagios.cfg.epp', {
        'log_file'                  => $log_file,
        'subcfg_dirs'               => $subcfg_dirs,
        'object_cache_file'         => $object_cache_file,
        'precached_object_file'     => $precached_object_file,
        'resource_file'             => $resource_file,
        'status_file'               => $status_file,
        'user'                      => $user,
        'group'                     => $group,
        'check_external_commands'   => $allow_external_cmd,
        'command_check_interval'    => $command_check_interval,
        'command_file'              => $command_file,
        'lock_file'                 => $lock_file,
        'temp_file'                 => $temp_file,
        'temp_path'                 => $temp_path,
        'log_archive_path'          => $log_archive_path,
        'check_result_path'         => $check_result_path,
        'soft_state_dependencies'   => $soft_state_dependencies,
        'state_retention_file'      => $state_retention_file,
        'admin_email'               => $admin_email,
        'admin_pager'               => $admin_pager,
        'enable_environment_macros' => $enable_environment_macros,
        'debug_file'                => $debug_file,
    }),
    require => Package[$package],
    notify  => Service[$service],
  }

  file { 'nagios_cgi_cfg':
    ensure  => file,
    path    => "${cfg_dir}/cgi.cfg",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('nagios/cgi.cfg.epp', {
        'main_config_file'   => $main_config_file,
        'physical_html_path' => $physical_html_path,
        'url_html_path'      => $url_html_path,
        'use_authentication' => $use_authentication,
        'default_user_name'  => $default_user_name,
        'authorized_users'   => join(Array($cgi_authorized_users, true), ','),
        'ack_no_sticky'      => $ack_no_sticky,
        'ack_no_send'        => $ack_no_send,
    }),
    require => Package[$package],
  }

  file { 'nagios_resource_cfg':
    ensure  => file,
    path    => $resource_file,
    owner   => 'root',
    group   => $group,
    mode    => '0640',
    content => epp('nagios/resource.cfg.epp', { 'plugin_dir' => $plugin_dir }),
    require => Package[$package],
    notify  => Service[$service],
  }

  file { 'nagios_confd':
    ensure  => directory,
    path    => $conf_d,
    recurse => true,
    purge   => true,
    owner   => 'root',
    group   => $group,
    mode    => '0750',
    require => Package[$package],
    notify  => Service[$service],
  }

  file { 'nagios_commands_cfg':
    ensure => absent,
    path   => "${cfg_dir}/commands.cfg",
    notify => Service[$service],
  }

  file { 'nagios_stylesheets':
    ensure  => directory,
    path    => "${cfg_dir}/stylesheets",
    recurse => true,
    purge   => false,
  }

  service { $service:
    ensure  => running,
    enable  => true,
    require => Package[$package],
  }

  ['hosts', 'service', 'servicedependency', 'hostextinfo'].each |String $type| {
    nagios::collect_type { $type:
      destdir     => $conf_d,
      server_name => $server_name,
    }
  }

  ['command', 'contact', 'contactgroup', 'hostgroup', 'timeperiod'].each |String $type| {
    nagios::collect_type { $type:
      destdir  => $conf_d,
      exported => false,
    }
  }
}
