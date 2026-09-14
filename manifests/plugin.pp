define nagios::plugin (
  $source,
  $ensure = 'present',
) {
  $plugin_dir = lookup('nagios::plugin_dir', Stdlib::Absolutepath)
  $plugin_package = lookup('nagios::plugin_package', String[1])

  file { $name:
    ensure  => $ensure,
    path    => "${plugin_dir}/${name}",
    source  => $source,
    tag     => 'nagios_plugin',
    require => Package[$plugin_package],
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}
