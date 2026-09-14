# @summary Exports a Nagios host object for collection by the server.
#
# @example Monitor the current node from the server named monitoring1
#   nagios::type::host { $facts['networking']['fqdn']:
#     parents      => ['router01'],
#     server_names => ['monitoring1'],
#   }
#
# @param use Host template to inherit from.
# @param template_name Registers the object as a template with this name.
# @param host_name Name of the host, defaults to the node FQDN.
# @param address Address checked by Nagios, defaults to host_name.
# @param hostgroups Host groups the host belongs to.
# @param host_alias Long name of the host.
# @param parents Hosts this host is reached through.
# @param contact_groups Contact groups notified about the host.
# @param notifications_enabled Whether notifications are sent.
# @param event_handler_enabled Whether the event handler runs.
# @param flap_detection_enabled Whether flap detection is active.
# @param failure_prediction_enabled Legacy failure prediction flag.
# @param process_perf_data Whether performance data is processed.
# @param retain_status_information Whether status is retained across restarts.
# @param retain_nonstatus_information Whether non-status data is retained across restarts.
# @param check_command Command checking the host.
# @param max_check_attempts Retries before a hard state.
# @param notification_interval Minutes between renotifications, 0 to notify once.
# @param notification_period Timeperiod during which notifications are sent.
# @param notification_options Host states to notify about.
# @param register Whether the object is a real host (1) or a template (0).
# @param server_names Nagios servers that collect this object; empty means
#   servers declared without a server_name.
define nagios::type::host (
  String[1]                  $use                          = 'generic-host',
  Optional[String[1]]        $template_name                = undef,
  String[1]                  $host_name                    = $facts['networking']['fqdn'],
  Optional[String[1]]        $address                      = undef,
  Array[String[1]]           $hostgroups                   = [],
  Optional[String[1]]        $host_alias                   = undef,
  Array[String[1]]           $parents                      = [],
  Array[String[1]]           $contact_groups               = [],
  Optional[Nagios::Flag]     $notifications_enabled        = undef,
  Optional[Nagios::Flag]     $event_handler_enabled        = undef,
  Optional[Nagios::Flag]     $flap_detection_enabled       = undef,
  Optional[Nagios::Flag]     $failure_prediction_enabled   = undef,
  Optional[Nagios::Flag]     $process_perf_data            = undef,
  Optional[Nagios::Flag]     $retain_status_information    = undef,
  Optional[Nagios::Flag]     $retain_nonstatus_information = undef,
  Optional[String[1]]        $check_command                = undef,
  Optional[Nagios::Interval] $max_check_attempts           = undef,
  Optional[Nagios::Interval] $notification_interval        = undef,
  Optional[String[1]]        $notification_period          = undef,
  Optional[String[1]]        $notification_options         = undef,
  Optional[Nagios::Flag]     $register                     = undef,
  Nagios::ServerNames        $server_names                 = [],
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  @@concat::fragment { "nagios_host_${name}_${facts['networking']['fqdn']}":
    target  => "${cfg_dir}/conf.d/nagios_hosts.cfg",
    order   => '30',
    tag     => nagios::tags('hosts', $server_names),
    content => nagios::object('host', {
        'use'                          => $use,
        'host_name'                    => $host_name,
        'name'                         => $template_name,
        'address'                      => pick($address, $host_name),
        'hostgroups'                   => $hostgroups,
        'alias'                        => $host_alias,
        'contact_groups'               => $contact_groups,
        'parents'                      => $parents,
        'notifications_enabled'        => $notifications_enabled,
        'event_handler_enabled'        => $event_handler_enabled,
        'flap_detection_enabled'       => $flap_detection_enabled,
        'failure_prediction_enabled'   => $failure_prediction_enabled,
        'process_perf_data'            => $process_perf_data,
        'retain_status_information'    => $retain_status_information,
        'retain_nonstatus_information' => $retain_nonstatus_information,
        'check_command'                => $check_command,
        'max_check_attempts'           => $max_check_attempts,
        'notification_interval'        => $notification_interval,
        'notification_period'          => $notification_period,
        'notification_options'         => $notification_options,
        'register'                     => $register,
    }),
  }
}
