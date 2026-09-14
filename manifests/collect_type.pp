# @summary Assembles the fragments of one Nagios object type into a conf.d file.
#
# Declared by class nagios for every object type. With exported set, the
# concat::fragment resources exported by nagios::type::* on other nodes and
# tagged for this server are collected into the file.
#
# @param destdir Directory receiving nagios_<name>.cfg, defaults to conf.d
#   under the configured cfg_dir.
# @param server_name Collect fragments tagged for this server instead of the
#   fragments exported without a server name.
# @param exported Whether to collect exported fragments at all.
define nagios::collect_type (
  Optional[Stdlib::Absolutepath] $destdir     = undef,
  Optional[String[1]]            $server_name = undef,
  Boolean                        $exported    = true,
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)
  $service = lookup('nagios::service', String[1])
  $target  = "${pick($destdir, "${cfg_dir}/conf.d")}/nagios_${name}.cfg"

  concat { $target:
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service[$service],
  }

  concat::fragment { "type_header_${name}":
    target  => $target,
    order   => '05',
    content => epp('nagios/type_header.epp', { 'type' => $name }),
  }

  if $exported {
    $collect_tag = $server_name ? {
      undef   => "nagios_${name}",
      default => "nagios_${name}_${server_name}",
    }

    Concat::Fragment <<| tag == $collect_tag |>> {
      target => $target,
      order  => '30',
    }
  }
}
