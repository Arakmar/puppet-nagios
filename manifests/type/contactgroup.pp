define nagios::type::contactgroup (
	$contactgroup_name = $name,
	$contactgroup_alias = '',
	$members = [],
)
{
	concat::fragment { "nagios_contactgroup_${name}_${::fqdn}":
		target  => '/etc/nagios3/conf.d/nagios_contactgroup.cfg',
		content => template("nagios/nagios_type/contactgroup.erb"),
		tag     => 'nagios_contactgroup',
	}
}
