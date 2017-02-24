define nagios::type::contact (
	$contact_name = $name,
	$use = 'generic-contact',
	$contact_alias = undef,
	$service_notification_period = undef,
	$host_notification_period = undef,
	$service_notification_options = undef,
	$host_notification_options = undef,
	$service_notification_commands = undef,
	$host_notification_commands = undef,
	$email = 'root@localhost',
)
{

	concat::fragment { "nagios_contact_${name}_${::fqdn}":
		target  => "${nagios::cfgdir}/conf.d/nagios_contact.cfg",
		content => template("nagios/nagios_type/contact.erb"),
		tag     => 'nagios_contact'
	}
}
