# @summary Deploys a plugin shipped by a Puppet module.
#
# A thin wrapper around nagios::plugin that defaults the source to
# puppet:///modules/nagios/plugins/<name> and installs the plugin package
# first.
#
# @param source Module path of the plugin, relative to puppet:///modules/.
# @param ensure State of the plugin file.
# @param require_package Package to install before the plugin, defaults to the
#   monitoring plugins package.
define nagios::plugin::deploy (
  Optional[String[1]]       $source          = undef,
  Enum['present', 'absent'] $ensure          = 'present',
  Optional[String[1]]       $require_package = undef,
) {
  $package = pick($require_package, lookup('nagios::plugin_package', String[1]))
  $path    = pick($source, "nagios/plugins/${name}")

  stdlib::ensure_packages([$package])

  nagios::plugin { $name:
    ensure  => $ensure,
    source  => "puppet:///modules/${path}",
    require => Package[$package],
  }
}
