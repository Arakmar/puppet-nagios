define nagios::type::servicedependency (
  $host_name                     = undef,
  $service_description           = undef,
  $hostgroup_name                = undef,
  $servicegroup_name             = undef,
  $dependent_host_name           = undef,
  $dependent_hostgroup_name      = undef,
  $dependent_servicegroup_name   = undef,
  $dependent_service_description = undef,
  $inherits_parent               = undef,
  $execution_failure_criteria    = undef,
  $notification_failure_criteria = undef,
  $dependency_period             = undef,
  $server_names                  = []
) {
  validate_array($server_names)

  if (empty($server_names)) {
    $tag_array = ['nagios_servicedependency']
  } else {
    $tag_array = prefix($server_names, 'nagios_servicedependency_')
  }

  @@concat::fragment { "nagios_servicedependency_${name}_${::fqdn}":
    target  => "${nagios::params::cfg_dir}/conf.d/nagios_servicedependency.cfg",
    content => template('nagios/nagios_type/servicedependency.erb'),
    tag     => $tag_array,
  }
}