define nagios::config (
  $ensure  = present,
  $source  = undef,
  $content = undef,
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)
  $service = lookup('nagios::service', String[1])

  if $content and $source {
    fail('nagios::config cannot have both content and source')
  }

  if !$content and !$source {
    fail('nagios::config needs either of content or source')
  }

  file { "nagios_${name}":
    ensure  => $ensure,
    path    => "${cfg_dir}/conf.d/custom_${name}",
    content => $content,
    source  => $source,
    notify  => Service[$service],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
