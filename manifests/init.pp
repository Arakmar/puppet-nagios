#
# nagios module
# nagios.pp - everything nagios related
#
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# Copyright 2008, admin(at)immerda.ch
# Copyright 2008, Puzzle ITC GmbH
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute
# it and/or modify it under the terms of the GNU
# General Public License version 3 as published by
# the Free Software Foundation.
#

# manage nagios
class nagios (
  $allow_external_cmd = $nagios::params::check_external_commands,
  $cgi_authorized_users = $nagios::params::default_user_name,
  $server_name        = undef
) inherits nagios::params {
  validate_string($server_name)

  ensure_packages([$nagios::params::package, $nagios::params::nrpe_package])

  file { 'nagios_cfgdir':
    ensure  => directory,
    path    => $nagios::params::cfg_dir,
    recurse => true,
    purge   => true,
    notify  => Service[$nagios::params::service],
    require => Package[$nagios::params::package],
    mode    => '0755',
    owner   => 'root',
    group   => 'root';
  }

  file { 'nagios_main_cfg':
    path    => "${nagios::params::cfg_dir}/nagios.cfg",
    content => template('nagios/nagios.cfg.erb'),
    notify  => Service[$nagios::params::service],
    require => Package[$nagios::params::package],
    mode    => '0644',
    owner   => 'root',
    group   => 'root';
  }

  file { 'nagios_cgi_cfg':
    path    => "${nagios::params::cfg_dir}/cgi.cfg",
    content => template('nagios/cgi.cfg.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package[$nagios::params::package],
  }

  file { 'nagios_resource_cfg':
    path    => $nagios::params::resource_file,
    source  => [
      "puppet:///modules/nagios/configs/${::osfamily}/private/resource.cfg.${::architecture}",
      "puppet:///modules/nagios/configs/${::osfamily}/private/resource.cfg.default"
    ],
    notify  => Service[$nagios::params::service],
    require => Package[$nagios::params::package],
    owner   => 'root',
    group   => $nagios::params::group,
    mode    => '0640';
  }

  file { 'nagios_confd':
    ensure  => directory,
    path    => "${nagios::params::cfg_dir}/conf.d/",
    purge   => true,
    recurse => true,
    notify  => Service[$nagios::params::service],
    require => Package[$nagios::params::package],
    mode    => '0750',
    owner   => 'root',
    group   => $nagios::params::group;
  }

  file { 'nagios_commands_cfg':
    ensure => absent,
    path   => "${nagios::params::cfg_dir}/commands.cfg",
    notify => Service[$nagios::params::service],
  }

  file { "${nagios::params::cfg_dir}/stylesheets":
    ensure  => directory,
    purge   => false,
    recurse => true,
  }

  service { $nagios::params::service:
    ensure  => running,
    enable  => true,
    require => Package[$nagios::params::package],
  }

  nagios::collect_type {
    'command':
      destdir  => "${nagios::params::cfg_dir}/conf.d",
      exported => false;
    'contact':
      destdir  => "${nagios::params::cfg_dir}/conf.d",
      exported => false;
    'contactgroup':
      destdir  => "${nagios::params::cfg_dir}/conf.d",
      exported => false;
    'hosts':
      destdir     => "${nagios::params::cfg_dir}/conf.d",
      server_name => $nagios::server_name;
    'service':
      destdir     => "${nagios::params::cfg_dir}/conf.d",
      server_name => $nagios::server_name;
    'hostgroup':
      destdir  => "${nagios::params::cfg_dir}/conf.d",
      exported => false;
    'hostextinfo':
      destdir     => "${nagios::params::cfg_dir}/conf.d",
      server_name => $nagios::server_name;
    'timeperiod':
      destdir  => "${nagios::params::cfg_dir}/conf.d",
      exported => false;
  }
}
