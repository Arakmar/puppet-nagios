define nagios::config (
    $ensure = present,
    $source = undef,
    $content = undef,
) {
    if $content and $source {
        fail('nagios::config cannot have both content and source')
    }

    if !$content and !$source {
        fail('nagios::config needs either of content or source')
    }
    
    file { "nagios_${name}":
      ensure  => $ensure,
      path    => "${nagios::params::cfg_dir}/conf.d/custom_${name}",
      content => $content,
      source  => $source,
      notify  => Service[$nagios::params::service],
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
}
