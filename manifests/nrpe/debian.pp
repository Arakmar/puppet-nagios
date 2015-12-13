class nagios::nrpe::debian {
    package { 
        "nagios-nrpe-server": ensure => present;
        "nagios-plugins-basic": ensure => present;
        "libwww-perl": ensure => present;   # for check_apache
    }
    
    package {
        "nagios-plugins-standard": ensure => present;
    }

    # Special-case lenny. the package doesn't exist
    if $lsbdistcodename != 'lenny' {
        package { "libnagios-plugin-perl": ensure => present; }
    }
    
    service { "nagios-nrpe-server":
	    ensure    => running,
	    enable    => true,
	    hasstatus  => true,
	    subscribe => File["$cfgfile"],
            require   => Package["nagios-nrpe-server"],
    }
}
