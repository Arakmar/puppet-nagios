define nagios::plugin(
    $source,
    $ensure = 'present',
) {
  file { $name:
    path    => "${nagios::params::plugin_dir}/${name}",
    ensure  => $ensure,
    source  => $source,
    tag     => 'nagios_plugin',
    require => Package['nagios-plugins'],
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}
