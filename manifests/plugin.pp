define nagios::plugin (
  $source,
  $ensure = 'present',
) {
  file { $name:
    ensure  => $ensure,
    path    => "${nagios::params::plugin_dir}/${name}",
    source  => $source,
    tag     => 'nagios_plugin',
    require => Package['nagios-plugins'],
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}
