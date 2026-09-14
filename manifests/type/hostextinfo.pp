# @summary Exports a Nagios hostextinfo object for collection by the server.
#
# @param use Template to inherit from.
# @param host_name Host the extended information applies to.
# @param notes Free text notes.
# @param icon_image Icon shown next to the host.
# @param icon_image_alt Alternative text of the icon.
# @param vrml_image Image used in the 3D status map.
# @param statusmap_image Image used in the status map.
# @param server_names Nagios servers that collect this object; empty means
#   servers declared without a server_name.
define nagios::type::hostextinfo (
  Optional[String[1]] $use             = undef,
  Optional[String[1]] $host_name       = undef,
  Optional[String[1]] $notes           = undef,
  Optional[String[1]] $icon_image      = undef,
  Optional[String[1]] $icon_image_alt  = undef,
  Optional[String[1]] $vrml_image      = undef,
  Optional[String[1]] $statusmap_image = undef,
  Nagios::ServerNames $server_names    = [],
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  @@concat::fragment { "nagios_hostextinfo_${name}_${facts['networking']['fqdn']}":
    target  => "${cfg_dir}/conf.d/nagios_hostextinfo.cfg",
    order   => '30',
    tag     => nagios::tags('hostextinfo', $server_names),
    content => nagios::object('hostextinfo', {
        'host_name'       => $host_name,
        'use'             => $use,
        'notes'           => $notes,
        'icon_image'      => $icon_image,
        'icon_image_alt'  => $icon_image_alt,
        'vrml_image'      => $vrml_image,
        'statusmap_image' => $statusmap_image,
    }),
  }
}
