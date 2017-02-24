define nagios::type::contactgroup (
	$ensure = "present",
	$contactgroup_name = "$name",
	$contactgroup_alias = '',
	$members = [],
	$server_name = undef
)
{
	if ! ($server_name) {
		@@concat::fragment{ "nagios_contactgroup_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_contactgroup.cfg',
			content => template("nagios/nagios_type/contactgroup.erb"),
			tag => 'nagios_contactgroup',
		}
	} else {
		$tagArray = prefix("nagios_contactgroup_", $server_name)
		@@concat::fragment{ "nagios_contactgroup_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_contactgroup.cfg',
			content => template("nagios/nagios_type/contactgroup.erb"),
			tag => $tagArray,
		}
	}
}
