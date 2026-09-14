# @summary Exports a Nagios service object for collection by the server.
#
# With use_nrpe the check command is wrapped into one of the check_nrpe
# commands declared by nagios::command::nrpe_timeout and
# nagios::command::nrpe_host, which the server must include.
#
# @example An NRPE check with arguments against the current node
#   nagios::type::service { 'load':
#     host_name     => $facts['networking']['fqdn'],
#     use_nrpe      => true,
#     check_command => 'check_load',
#     nrpe_args     => '-w 5,4,3 -c 10,8,6',
#     server_names  => ['monitoring1'],
#   }
#
# @param host_name Host the service runs on.
# @param template_name Registers the object as a template with this name.
# @param hostgroup_name Host groups the service applies to.
# @param check_command Command checking the service, or the NRPE command name with use_nrpe.
# @param check_period Timeperiod during which the service is checked.
# @param check_interval Minutes between checks.
# @param normal_check_interval Legacy name of check_interval.
# @param retry_check_interval Minutes between retries in a soft state.
# @param max_check_attempts Retries before a hard state.
# @param notification_interval Minutes between renotifications, 0 to notify once.
# @param notification_period Timeperiod during which notifications are sent.
# @param notification_options Service states to notify about.
# @param first_notification_delay Minutes to wait before the first notification.
# @param contacts Contacts notified about the service.
# @param contact_groups Contact groups notified about the service.
# @param use Service template to inherit from.
# @param service_description Description of the service, unique per host.
# @param active_checks_enabled Whether active checks run.
# @param passive_checks_enabled Whether passive results are accepted.
# @param parallelize_check Legacy parallelisation flag.
# @param obsess_over_service Whether the OCSP command runs.
# @param check_freshness Whether freshness is checked.
# @param notifications_enabled Whether notifications are sent.
# @param event_handler Command run on state changes.
# @param event_handler_enabled Whether the event handler runs.
# @param flap_detection_enabled Whether flap detection is active.
# @param failure_prediction_enabled Legacy failure prediction flag.
# @param process_perf_data Whether performance data is processed.
# @param retain_status_information Whether status is retained across restarts.
# @param retain_nonstatus_information Whether non-status data is retained across restarts.
# @param is_volatile Whether the service is volatile.
# @param register Whether the object is a real service (1) or a template (0).
# @param use_nrpe Run check_command through check_nrpe on the monitored host.
# @param nrpe_port Port of the NRPE daemon.
# @param nrpe_args Arguments passed to the NRPE command.
# @param nrpe_host Host running the NRPE daemon when it is not the checked host.
# @param nrpe_timeout Timeout of check_nrpe in seconds.
# @param server_names Nagios servers that collect this object; empty means
#   servers declared without a server_name.
define nagios::type::service (
  Optional[String[1]]        $host_name                    = undef,
  Optional[String[1]]        $template_name                = undef,
  Array[String[1]]           $hostgroup_name               = [],
  Optional[String[1]]        $check_command                = undef,
  Optional[String[1]]        $check_period                 = undef,
  Optional[Nagios::Interval] $check_interval               = undef,
  Optional[Nagios::Interval] $normal_check_interval        = undef,
  Optional[Nagios::Interval] $retry_check_interval         = undef,
  Optional[Nagios::Interval] $max_check_attempts           = undef,
  Optional[Nagios::Interval] $notification_interval        = undef,
  Optional[String[1]]        $notification_period          = undef,
  Optional[String[1]]        $notification_options         = undef,
  Optional[Nagios::Interval] $first_notification_delay     = undef,
  Array[String[1]]           $contacts                     = [],
  Array[String[1]]           $contact_groups               = [],
  String[1]                  $use                          = 'generic-service',
  Optional[String[1]]        $service_description          = undef,
  Optional[Nagios::Flag]     $active_checks_enabled        = undef,
  Optional[Nagios::Flag]     $passive_checks_enabled       = undef,
  Optional[Nagios::Flag]     $parallelize_check            = undef,
  Optional[Nagios::Flag]     $obsess_over_service          = undef,
  Optional[Nagios::Flag]     $check_freshness              = undef,
  Optional[Nagios::Flag]     $notifications_enabled        = undef,
  Optional[String[1]]        $event_handler                = undef,
  Optional[Nagios::Flag]     $event_handler_enabled        = undef,
  Optional[Nagios::Flag]     $flap_detection_enabled       = undef,
  Optional[Nagios::Flag]     $failure_prediction_enabled   = undef,
  Optional[Nagios::Flag]     $process_perf_data            = undef,
  Optional[Nagios::Flag]     $retain_status_information    = undef,
  Optional[Nagios::Flag]     $retain_nonstatus_information = undef,
  Optional[Nagios::Flag]     $is_volatile                  = undef,
  Optional[Nagios::Flag]     $register                     = undef,
  Boolean                    $use_nrpe                     = false,
  Nagios::Port               $nrpe_port                    = 5666,
  Optional[String[1]]        $nrpe_args                    = undef,
  Optional[String[1]]        $nrpe_host                    = undef,
  Nagios::Interval           $nrpe_timeout                 = 60,
  Nagios::ServerNames        $server_names                 = [],
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  if $use_nrpe {
    if $check_command =~ Undef {
      fail("nagios::type::service[${name}]: check_command is required when use_nrpe is true")
    }

    if $nrpe_args =~ NotUndef {
      $real_check_command = $nrpe_host ? {
        undef   => "check_nrpe_timeout_port!${nrpe_timeout}!${check_command}!${nrpe_port}!\"${nrpe_args}\"",
        default => "check_nrpe_host_timeout_port!${nrpe_host}!${check_command}!${nrpe_port}!\"${nrpe_args}\"!${nrpe_timeout}",
      }
    } else {
      $real_check_command = $nrpe_host ? {
        undef   => "check_nrpe_1arg_timeout_port!${nrpe_timeout}!${check_command}!${nrpe_port}",
        default => "check_nrpe_1arg_host_timeout_port!${nrpe_host}!${check_command}!${nrpe_port}!${nrpe_timeout}",
      }
    }
  } else {
    $real_check_command = $check_command
  }

  @@concat::fragment { "nagios_service_${name}_${facts['networking']['fqdn']}":
    target  => "${cfg_dir}/conf.d/nagios_service.cfg",
    order   => '30',
    tag     => nagios::tags('service', $server_names),
    content => nagios::object('service', {
        'use'                          => $use,
        'name'                         => $template_name,
        'service_description'          => $service_description,
        'host_name'                    => $host_name,
        'hostgroup_name'               => $hostgroup_name,
        'check_command'                => $real_check_command,
        'check_period'                 => $check_period,
        'check_interval'               => $check_interval,
        'normal_check_interval'        => $normal_check_interval,
        'retry_check_interval'         => $retry_check_interval,
        'max_check_attempts'           => $max_check_attempts,
        'notification_interval'        => $notification_interval,
        'notification_period'          => $notification_period,
        'notification_options'         => $notification_options,
        'first_notification_delay'     => $first_notification_delay,
        'contacts'                     => $contacts,
        'contact_groups'               => $contact_groups,
        'active_checks_enabled'        => $active_checks_enabled,
        'passive_checks_enabled'       => $passive_checks_enabled,
        'parallelize_check'            => $parallelize_check,
        'obsess_over_service'          => $obsess_over_service,
        'check_freshness'              => $check_freshness,
        'notifications_enabled'        => $notifications_enabled,
        'event_handler_enabled'        => $event_handler_enabled,
        'event_handler'                => $event_handler,
        'flap_detection_enabled'       => $flap_detection_enabled,
        'failure_prediction_enabled'   => $failure_prediction_enabled,
        'process_perf_data'            => $process_perf_data,
        'retain_status_information'    => $retain_status_information,
        'retain_nonstatus_information' => $retain_nonstatus_information,
        'is_volatile'                  => $is_volatile,
        'register'                     => $register,
    }),
  }
}
