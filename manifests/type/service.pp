define nagios::type::service (
	$host_name = '',
	$hostgroup_name = [],
	$check_command = '',
	$check_period = '',
	$check_interval = '',
	$normal_check_interval = '',
	$retry_check_interval = '',
	$max_check_attempts = '',
	$notification_interval = '',
	$notification_period = '',
	$notification_options = '',
	$first_notification_delay = '',
	$contacts = [],
	$contact_groups = [],
	$use = 'generic-service',
	$service_description = '',
	$active_checks_enabled = '',
	$passive_checks_enabled = '',
	$parallelize_check = '',
	$obsess_over_service = '',
	$check_freshness = '',
	$notifications_enabled = '',
	$event_handler = '',
	$event_handler_enabled = '',
	$flap_detection_enabled = '',
	$failure_prediction_enabled = '',
	$process_perf_data = '',
	$retain_status_information = '',
	$retain_nonstatus_information = '',
	$is_volatile = '',
	$register = '',
	$use_nrpe = false,
        $nrpe_port = '5666',
	$nrpe_args = '',
        $nrpe_timeout = '',
	$server_name = undef
)
{

	if ($use_nrpe) {

		if ($nrpe_args != '') {
			if ($nrpe_timeout != '') {
				$real_check_command = "check_nrpe_timeout_port!${nrpe_timeout}!${check_command}!${nrpe_port}!\"${nrpe_args}\""
			}
			else {
				$real_check_command = "check_nrpe_port!${check_command}!${nrpe_port}!\"${nrpe_args}\""
			}
		}
		else {
			if ($nrpe_timeout != '') {
				$real_check_command = "check_nrpe_1arg_timeout_port!${nrpe_timeout}!${check_command}!${nrpe_port}"
			}
			else {
				$real_check_command = "check_nrpe_1arg_port!$check_command!${nrpe_port}"
			}
			
		}
	}
	else {
		$real_check_command = "$check_command"
	}

	if ! ($server_name) {
		@@concat::fragment{ "nagios_service_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_service.cfg',
			content => template("nagios/nagios_type/service.erb"),
			tag => 'nagios_service',
		}
	} else {
		$tableau = prepend_array("nagios_service_", $server_name)
		@@concat::fragment{ "nagios_service_${name}_${server_name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_service.cfg',
			content => template("nagios/nagios_type/service.erb"),
			tag => $tableau,
		}
	}
}

