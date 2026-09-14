# @summary Installs a plugin file into the Nagios plugin directory.
#
# @param source Puppet URL of the plugin.
# @param ensure State of the plugin file.
define nagios::plugin (
  String[1]                  $source,
  Enum['present', 'absent'] $ensure = 'present',
) {
  $plugin_dir     = lookup('nagios::plugin_dir', Stdlib::Absolutepath)
  $plugin_package = lookup('nagios::plugin_package', String[1])

  stdlib::ensure_packages([$plugin_package])

  file { $name:
    ensure  => $ensure,
    path    => "${plugin_dir}/${name}",
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    tag     => 'nagios_plugin',
    require => Package[$plugin_package],
  }
}
