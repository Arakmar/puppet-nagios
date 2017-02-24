define nagios::type::contactgroup (
	$contactgroup_name = $name,
	$contactgroup_alias = undef,
	$members = [],
)
{
	concat::fragment { "nagios_contactgroup_${name}_${::fqdn}":
		target  => "${nagios::defaults::vars::int_cfgdir}/conf.d/nagios_contactgroup.cfg",
		content => template("nagios/nagios_type/contactgroup.erb"),
		tag     => 'nagios_contactgroup',
		order  => '30'
	}
}
