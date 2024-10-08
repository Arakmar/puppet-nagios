define nagios::type::service (
  $host_name                    = undef,
  $template_name                = undef,
  $hostgroup_name               = [],
  $check_command                = undef,
  $check_period                 = undef,
  $check_interval               = undef,
  $normal_check_interval        = undef,
  $retry_check_interval         = undef,
  $max_check_attempts           = undef,
  $notification_interval        = undef,
  $notification_period          = undef,
  $notification_options         = undef,
  $first_notification_delay     = undef,
  $contacts                     = [],
  $contact_groups               = [],
  $use                          = 'generic-service',
  $service_description          = undef,
  $active_checks_enabled        = undef,
  $passive_checks_enabled       = undef,
  $parallelize_check            = undef,
  $obsess_over_service          = undef,
  $check_freshness              = undef,
  $notifications_enabled        = undef,
  $event_handler                = undef,
  $event_handler_enabled        = undef,
  $flap_detection_enabled       = undef,
  $failure_prediction_enabled   = undef,
  $process_perf_data            = undef,
  $retain_status_information    = undef,
  $retain_nonstatus_information = undef,
  $is_volatile                  = undef,
  $register                     = undef,
  $use_nrpe                     = false,
  $nrpe_port                    = '5666',
  $nrpe_args                    = undef,
  $nrpe_host                    = undef,
  $nrpe_timeout                 = 60,
  Array $server_names           = []
) {
  include nagios::params

  if (empty($server_names)) {
    $tag_array = ['nagios_service']
  } else {
    $tag_array = prefix($server_names, 'nagios_service_')
  }

  if ($use_nrpe) {
    if ($nrpe_args) {
      if ($nrpe_host) {
        $real_check_command = "check_nrpe_timeout_port!${nrpe_timeout}!${check_command}!${nrpe_port}!\"${nrpe_args}\""
      } else {
        $real_check_command = "check_nrpe_host_timeout_port!${nrpe_host}!${check_command}!${nrpe_port}!\"${nrpe_args}\"!${nrpe_timeout}"
      }
    }
    else {
      if ($nrpe_host) {
        $real_check_command = "check_nrpe_1arg_host_timeout_port!${nrpe_host}!${check_command}!${nrpe_port}!${nrpe_timeout}"
      } else {
        $real_check_command = "check_nrpe_1arg_timeout_port!${nrpe_timeout}!${check_command}!${nrpe_port}"
      }
    }
  }
  else {
    $real_check_command = $check_command
  }

  @@concat::fragment { "nagios_service_${name}_${facts['networking']['fqdn']}":
    target  => "${nagios::params::cfg_dir}/conf.d/nagios_service.cfg",
    content => template('nagios/nagios_type/service.erb'),
    tag     => $tag_array,
  }
}

