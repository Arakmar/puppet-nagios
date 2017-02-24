define nagios::type::hostgroup (
	$hostgroup_alias = "",
	$hostgroup_name = $name,
	$use = '',
	$members = []
)
{
	concat::fragment { "nagios_hostgroup_${name}_${::fqdn}":
		target  => '/etc/nagios3/conf.d/nagios_hostgroup.cfg',
		content => template("nagios/nagios_type/hostgroup.erb"),
		tag     => 'nagios_hostgroup',
	}
}
