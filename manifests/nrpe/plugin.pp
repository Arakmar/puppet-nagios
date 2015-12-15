define nagios::nrpe::plugin(
	$plugin=$name,
	$plugindir="${nagios::nrpe::plugindir}",
	$source="puppet:///modules/nrpe/plugins/${plugin}"
) {
	file { "${plugindir}/${plugin}":
		source  => $source,
		owner   => root,
		group   => root,
		mode    => '0755',
		notify  => Service["nagios-nrpe-server"];
	}
}
