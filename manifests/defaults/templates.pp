# @summary Installs the generic-host, generic-service and generic-contact templates.
#
# @param source Puppet URL of the templates file, defaults to the one shipped
#   with the module.
class nagios::defaults::templates (
  Optional[String[1]] $source = undef,
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)
  $service = lookup('nagios::service', String[1])

  file { 'nagios_templates':
    ensure => file,
    path   => "${cfg_dir}/conf.d/nagios_templates.cfg",
    source => pick($source, 'puppet:///modules/nagios/nagios_templates.cfg'),
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service[$service],
  }
}
