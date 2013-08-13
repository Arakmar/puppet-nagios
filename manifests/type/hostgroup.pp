define nagios::type::hostgroup (
	$ensure = "present",
	$hostgroup_alias = "",
	$hostgroup_name = "$name",
	$use = '',
	$members = [],
	$server_name = "default"
)
{
	if ($server_name == "") {
		@@concat::fragment{ "nagios_hostgroup_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_hostgroup.cfg',
			content => template("nagios/nagios_type/hostgroup.erb"),
			tag => 'nagios_hostgroup',
			ensure => $ensure,
		}
	}
	else {
		$tableau = prepend_array("nagios_hostgroup_", $server_name)
		@@concat::fragment{ "nagios_hostgroup_${name}_${server_name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_hostgroup.cfg',
			content => template("nagios/nagios_type/hostgroup.erb"),
			tag => $tableau,
			ensure => $ensure,
		}
	}
}
