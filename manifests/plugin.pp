define nagios::plugin(
    $source = 'absent',
    $ensure = present
){
  file{$name:
    path => "/usr/lib/nagios/plugins/${name}",
    ensure => $ensure,
    source => $source ? {
      'absent' => "puppet:///modules/nagios/plugins/${name}",
      default => "puppet:///modules/${source}"
    },
    tag => 'nagios_plugin',
    require => Package['nagios-plugins'],
    owner => root, group => 0, mode => '0755';
  }
}
