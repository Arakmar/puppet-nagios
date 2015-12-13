class nagios::nrpe::archlinux {
    package { 
        "nrpe": ensure => present;
        "monitoring-plugins": ensure => present;
    }

    service { "nrpe":
	    ensure    => running,
	    enable    => true,
	    hasstatus  => true,
	    subscribe => File["${nagios::nrpe::cfgfile}"],
            require   => Package["nrpe"],
    }
}
