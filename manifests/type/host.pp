define nagios::type::host (
	$ensure = "present",
	$use = 'generic-host',
	$host_name = $::fqdn,
	$address = '',
	$hostgroups = [],
	$host_alias = '',
	$parents = [],
	$contact_groups = [],
	$notifications_enabled = '',
	$event_handler_enabled = '',
	$flap_detection_enabled = '',
	$failure_prediction_enabled = '',
	$process_perf_data = '',
	$retain_status_information = '',
	$retain_nonstatus_information = '',
	$check_command = '',
	$max_check_attempts = '',
	$notification_interval = '',
	$notification_period = '',
	$notification_options = '',
	$register = '',
	$server_name = "default",
)
{
        $real_address = $address ? {
                "" => $host_name,
                default => $address
        }
	$nagios_custom_hostgroups = $nagios_custom_hostgroups ? {
		"" => [],
		default => $nagios_custom_hostgroups
	}
	
	if ($server_name == "") {
		@@concat::fragment{ "nagios_host_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_hosts.cfg',
			content => template("nagios/nagios_type/host.erb"),
			tag => 'nagios_hosts',
			ensure => $ensure,
		}
	}
	else {
		$tableau = prepend_array("nagios_hosts_", $server_name)
		@@concat::fragment{ "nagios_host_${name}_${server_name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_hosts.cfg',
			content => template("nagios/nagios_type/host.erb"),
			tag => $tableau,
			ensure => $ensure,
		}
	}
}
