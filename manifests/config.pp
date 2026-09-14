# @summary Installs a custom configuration file into the Nagios conf.d directory.
#
# The file is written as conf.d/custom_<name>. Exactly one of source or
# content must be given.
#
# @param ensure State of the file.
# @param source Puppet URL of the file.
# @param content Content of the file.
define nagios::config (
  Enum['present', 'absent', 'file'] $ensure  = 'present',
  Optional[String[1]]               $source  = undef,
  Optional[String]                  $content = undef,
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)
  $service = lookup('nagios::service', String[1])

  if $content =~ NotUndef and $source =~ NotUndef {
    fail('nagios::config cannot have both content and source')
  }

  if $content =~ Undef and $source =~ Undef {
    fail('nagios::config needs either of content or source')
  }

  file { "nagios_${name}":
    ensure  => $ensure,
    path    => "${cfg_dir}/conf.d/custom_${name}",
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service[$service],
  }
}
