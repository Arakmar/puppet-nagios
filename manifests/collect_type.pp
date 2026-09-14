define nagios::collect_type (
  $destdir     = undef,
  $server_name = undef,
  $exported    = true
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)
  $service = lookup('nagios::service', String[1])
  $_destdir = pick($destdir, "${cfg_dir}/conf.d")
  if ($exported) {
    if ($server_name) {
      Concat::Fragment <<| tag == "nagios_${name}_${server_name}" |>> {
        target => "${_destdir}/nagios_${name}.cfg",
        order  => '30'
      }
    } else {
      Concat::Fragment <<| tag == "nagios_${name}" |>> {
        target => "${_destdir}/nagios_${name}.cfg",
        order  => '30'
      }
    }
  }

  concat::fragment { "type_header_${name}":
    target  => "${_destdir}/nagios_${name}.cfg",
    content => epp('nagios/type_header.epp', { 'type' => $name }),
    order   => '05',
  }

  concat { "${_destdir}/nagios_${name}.cfg":
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service[$service],
  }
}
