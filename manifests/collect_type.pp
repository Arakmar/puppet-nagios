define nagios::collect_type (
	$destdir = '/etc/nagios3/conf.d',
	$server_name = ''
)
{
	Concat::Fragment <<| tag == "nagios_${name}" |>> {
		target => "${destdir}/nagios_${name}.cfg"
	}
	if ($server_name != "") {
		Concat::Fragment <<| tag == "nagios_${name}_${server_name}" |>> {
			target => "${destdir}/nagios_${name}.cfg"
		}
	}
	
	concat::fragment {"type_header_${name}":
		target => "${destdir}/nagios_${name}.cfg",
		content => template("nagios/nagios_type/type_header.erb"),
		order => 05,
	}
  
	concat{ "${destdir}/nagios_${name}.cfg":
		owner => root, 
		group => root, 
		mode => 0644,
		notify => Service["nagios"]
	}
}
