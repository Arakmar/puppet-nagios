# @summary Exports a Nagios servicedependency object for collection by the server.
#
# @param host_name Host of the master service.
# @param service_description Description of the master service.
# @param hostgroup_name Host group of the master service.
# @param servicegroup_name Service group of the master service.
# @param dependent_host_name Host of the dependent service.
# @param dependent_hostgroup_name Host group of the dependent service.
# @param dependent_servicegroup_name Service group of the dependent service.
# @param dependent_service_description Description of the dependent service.
# @param inherits_parent Whether the dependency inherits the master's dependencies.
# @param execution_failure_criteria Master states preventing dependent checks.
# @param notification_failure_criteria Master states preventing dependent notifications.
# @param dependency_period Timeperiod during which the dependency applies.
# @param server_names Nagios servers that collect this object; empty means
#   servers declared without a server_name.
define nagios::type::servicedependency (
  Optional[String[1]]    $host_name                     = undef,
  Optional[String[1]]    $service_description           = undef,
  Optional[String[1]]    $hostgroup_name                = undef,
  Optional[String[1]]    $servicegroup_name             = undef,
  Optional[String[1]]    $dependent_host_name           = undef,
  Optional[String[1]]    $dependent_hostgroup_name      = undef,
  Optional[String[1]]    $dependent_servicegroup_name   = undef,
  Optional[String[1]]    $dependent_service_description = undef,
  Optional[Nagios::Flag] $inherits_parent               = undef,
  Optional[String[1]]    $execution_failure_criteria    = undef,
  Optional[String[1]]    $notification_failure_criteria = undef,
  Optional[String[1]]    $dependency_period             = undef,
  Nagios::ServerNames    $server_names                  = [],
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  @@concat::fragment { "nagios_servicedependency_${name}_${facts['networking']['fqdn']}":
    target  => "${cfg_dir}/conf.d/nagios_servicedependency.cfg",
    order   => '30',
    tag     => nagios::tags('servicedependency', $server_names),
    content => nagios::object('servicedependency', {
        'host_name'                     => $host_name,
        'service_description'           => $service_description,
        'hostgroup_name'                => $hostgroup_name,
        'servicegroup_name'             => $servicegroup_name,
        'dependent_host_name'           => $dependent_host_name,
        'dependent_hostgroup_name'      => $dependent_hostgroup_name,
        'dependent_servicegroup_name'   => $dependent_servicegroup_name,
        'dependent_service_description' => $dependent_service_description,
        'inherits_parent'               => $inherits_parent,
        'execution_failure_criteria'    => $execution_failure_criteria,
        'notification_failure_criteria' => $notification_failure_criteria,
        'dependency_period'             => $dependency_period,
    }),
  }
}
