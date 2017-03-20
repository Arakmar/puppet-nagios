define nagios::type::hostextinfo (
  $use             = undef,
  $host_name       = undef,
  $notes           = undef,
  $icon_image      = undef,
  $icon_image_alt  = undef,
  $vrml_image      = undef,
  $statusmap_image = undef,
  $server_names    = []
) {
  validate_array($server_names)

  if (empty($server_names)) {
    $tag_array = ['nagios_hostextinfo']
  } else {
    $tag_array = prefix($server_names, 'nagios_hostextinfo_')
  }

  @@concat::fragment { "nagios_hostextinfo_${name}_${::fqdn}":
    target  => "${nagios::params::cfg_dir}/conf.d/nagios_hostextinfo.cfg",
    content => template('nagios/nagios_type/hostextinfo.erb'),
    tag     => $tag_array,
  }
}
