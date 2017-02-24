define nagios::type::hostgroup (
	$hostgroup_alias = "",
	$hostgroup_name = $name,
	$use = '',
	$members = [],
	$server_name = undef
)
{
	if ! ($server_name) {
		@@concat::fragment{ "nagios_hostgroup_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_hostgroup.cfg',
			content => template("nagios/nagios_type/hostgroup.erb"),
			tag => 'nagios_hostgroup',
		}
	} else {
		$tagArray = prefix("nagios_hostgroup_", $server_name)
		@@concat::fragment{ "nagios_hostgroup_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_hostgroup.cfg',
			content => template("nagios/nagios_type/hostgroup.erb"),
			tag => $tagArray,
		}
	}
}
