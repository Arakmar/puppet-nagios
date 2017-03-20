define nagios::type::host (
	$use = 'generic-host',
	$template_name = undef,
	$host_name = $::fqdn,
	$address = undef,
	$hostgroups = [],
	$host_alias = undef,
	$parents = [],
	$contact_groups = [],
	$notifications_enabled = undef,
	$event_handler_enabled = undef,
	$flap_detection_enabled = undef,
	$failure_prediction_enabled = undef,
	$process_perf_data = undef,
	$retain_status_information = undef,
	$retain_nonstatus_information = undef,
	$check_command = undef,
	$max_check_attempts = undef,
	$notification_interval = undef,
	$notification_period = undef,
	$notification_options = undef,
	$register = undef,
	$server_names = []
)
{
	$real_address = $address ? {
    undef   => $host_name,
    default => $address
  }

	validate_array($server_names)

	if (empty($server_names)) {
		$tagArray = ['nagios_hosts']
	} else {
		$tagArray = prefix($server_names, "nagios_hosts_")
	}

	@@concat::fragment { "nagios_host_${name}_${::fqdn}":
		target  => "${nagios::params::cfg_dir}/conf.d/nagios_hosts.cfg",
		content => template("nagios/nagios_type/host.erb"),
		tag     => $tagArray
	}
}
