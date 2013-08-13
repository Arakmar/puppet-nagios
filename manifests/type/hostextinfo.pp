 define nagios::type::hostextinfo (
	$ensure = "present",
	$use = '',
	$host_name = '',
	$hostgroup_name = '',
	$notes = '',
	$icon_image = '',
	$icon_image_alt = '',
	$vrml_image = '',
	$statusmap_image = '',
	$server_name = ""
)
{
	if ($server_name == "") {
		@@concat::fragment{ "nagios_hostextinfo_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_hostextinfo.cfg',
			content => template("nagios/nagios_type/hostextinfo.erb"),
			tag => 'nagios_hostextinfo',
			ensure => $ensure,
		}
	}
	else {
		$tableau = prepend_array("nagios_hostextinfo_", $server_name)
		@@concat::fragment{ "nagios_hostextinfo_${name}_${server_name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_hostextinfo.cfg',
			content => template("nagios/nagios_type/hostextinfo.erb"),
			tag => $tableau,
			ensure => $ensure,
		}
	}
}
