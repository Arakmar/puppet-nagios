define nagios::collect_type (
  $destdir     = "${nagios::params::cfg_dir}/conf.d",
  $server_name = undef,
  $exported    = true
) {
  include nagios::params
  if ($exported) {
    if ($server_name) {
      Concat::Fragment <<| tag == "nagios_${name}_${server_name}" |>> {
        target => "${destdir}/nagios_${name}.cfg",
        order  => '30'
      }
    } else {
      Concat::Fragment <<| tag == "nagios_${name}" |>> {
        target => "${destdir}/nagios_${name}.cfg",
        order  => '30'
      }
    }
  }

  concat::fragment { "type_header_${name}":
    target  => "${destdir}/nagios_${name}.cfg",
    content => template('nagios/nagios_type/type_header.erb'),
    order   => '05',
  }

  concat { "${destdir}/nagios_${name}.cfg":
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service[$nagios::params::service],
  }
}
