define nagios::plugin (
  $source,
  $ensure = 'present',
) {
  include nagios::params

  file { $name:
    ensure  => $ensure,
    path    => "${nagios::params::plugin_dir}/${name}",
    source  => $source,
    tag     => 'nagios_plugin',
    require => Package["${nagios::params::plugin_package}"],
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}
