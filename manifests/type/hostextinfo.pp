 define nagios::type::hostextinfo (
	$use = '',
	$host_name = '',
	$hostgroup_name = '',
	$notes = '',
	$icon_image = '',
	$icon_image_alt = '',
	$vrml_image = '',
	$statusmap_image = '',
	$server_name = undef
)
{
	if ! ($server_name) {
		@@concat::fragment{ "nagios_hostextinfo_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_hostextinfo.cfg',
			content => template("nagios/nagios_type/hostextinfo.erb"),
			tag => 'nagios_hostextinfo',
		}
	} else {
		$tagArray = prefix("nagios_hostextinfo_", $server_name)
		@@concat::fragment{ "nagios_hostextinfo_${name}_${::fqdn}":
			target => '/etc/nagios3/conf.d/nagios_hostextinfo.cfg',
			content => template("nagios/nagios_type/hostextinfo.erb"),
			tag => $tagArray,
		}
	}
}
