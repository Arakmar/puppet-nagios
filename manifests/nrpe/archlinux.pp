class nagios::nrpe::debian {
    package { 
        "nrpe": ensure => present;
        "monitoring-plugins": ensure => present;
    }

    service { "nrpe":
	    ensure    => running,
	    enable    => true,
	    hasstatus  => true,
	    subscribe => File["$cfgfile"],
            require   => Package["nagios-nrpe-server"],
    }
}
