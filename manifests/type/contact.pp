define nagios::type::contact (
	$ensure = "present",
	$contact_name = "$name",
	$use = 'generic-contact',
	$contact_alias = '',
	$service_notification_period = '',
	$host_notification_period = '',
	$service_notification_options = '',
	$host_notification_options = '',
	$service_notification_commands = '',
	$host_notification_commands = '',
	$email = 'root@localhost',
	$server_name = "default"
)
{
	if ($server_name == "") {
		@@concat::fragment{ "nagios_contact_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_contact.cfg',
			content => template("nagios/nagios_type/contact.erb"),
			tag => 'nagios_contact',
			ensure => $ensure,
		}
	}
	else {
		$tableau = prepend_array("nagios_contact_", $server_name)
		@@concat::fragment{ "nagios_contact_${name}_${server_name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_contact.cfg',
			content => template("nagios/nagios_type/contact.erb"),
			tag => $tableau,
			ensure => $ensure,
		}
	}
}
