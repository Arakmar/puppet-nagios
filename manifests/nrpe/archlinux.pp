class nagios::nrpe::archlinux {
    package { 
        "nagios-nrpe-server":
            name => "nrpe",
            ensure => present;
        "monitoring-plugins": ensure => present;
    }

    service { "nagios-nrpe-server":
            name      => "nrpe",
	    ensure    => running,
	    enable    => true,
	    hasstatus  => true,
	    subscribe => File["${nagios::nrpe::cfgfile}"],
            require   => Package["nagios-nrpe-server"],
    }
}
