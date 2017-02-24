 define nagios::type::hostextinfo (
	$use = undef,
	$host_name = undef,
	$hostgroup_name = undef,
	$notes = undef,
	$icon_image = undef,
	$icon_image_alt = undef,
	$vrml_image = undef,
	$statusmap_image = undef,
	$server_names = []
)
{
	validate_array($server_names)

	if (empty($server_names)) {
		$tagArray = ['nagios_hostextinfo']
	} else {
		$tagArray = prefix("nagios_hostextinfo_", $server_names)
	}

	@@concat::fragment { "nagios_hostextinfo_${name}_${::fqdn}":
		target  => "${nagios::cfgdir}/conf.d/nagios_hostextinfo.cfg",
		content => template("nagios/nagios_type/hostextinfo.erb"),
		tag     => $tagArray
	}
}
