class nagios::nrpe::archlinux {
    package { 
        "nrpe": ensure => present;
        "monitoring-plugins": ensure => present;
    }

    service { "nrpe":
	    ensure    => running,
	    enable    => true,
	    hasstatus  => true,
	    subscribe => File["$cfgfile"],
            require   => Package["nrpe"],
    }
}
