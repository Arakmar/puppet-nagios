# Changelog

All notable changes to this project will be documented in this file.

## Release 1.0.2

**Bugfixes**

* Every `check_http` command now passes `--sni`. The plain http checks
  follow the redirection to https and, without SNI, land on the default
  vhost of the server: Apache answers `421 Misdirected Request` as soon
  as the target vhost uses another certificate.

## Release 1.0.0

First versioned release. The module previously lived on an unversioned
master branch; this release modernises it for Puppet 7 and 8 with the PDK.

**Breaking changes**

* Puppet >= 7.0.0, puppetlabs/stdlib 9.x and puppetlabs/concat 9.x are
  required and declared in metadata.json.
* Nagios 3 support (Debian <= 8, Ubuntu <= 18.04) is dropped. Debian and
  Ubuntu use the `nagios4` packages unconditionally. Supported releases are
  EL 8, 9 and 10 (CentOS Stream, Rocky, AlmaLinux), Debian 12 and 13,
  Ubuntu 22.04 and 24.04 and Arch Linux; Debian 11 and Ubuntu 20.04 are
  end of life and not listed.
* `nagios::params` is removed. Package names, paths and the service name are
  module Hiera data (`nagios::*` keys) that the defines resolve with
  `lookup()`; override them in Hiera.
* `nagios::defaults::host_templates`, `nagios::defaults::service_templates`
  and `nagios::plugin::scriptpaths` are removed. The `config` parameter of
  `nagios::plugin::deploy` is removed, its `source` parameter defaults to
  undef instead of an empty string and `ensure` only accepts `present` or
  `absent`.
* `nagios::service::http` implements the documented `ssl_mode` values:
  `true` now exports the http check in addition to the https ones (it used
  to behave like `only`), and `force` adds an http check expecting a
  redirect (`redirect_code`, 301 by default). `check_string`, `auth_name`
  and `auth_password` default to undef; `redirect_status` is restricted to
  the values check_http accepts. Generated service titles are unchanged.
* All parameters are typed. Numeric strings such as `'5666'` remain accepted
  where the previous defaults were strings.
* Generated object files use a two space indentation and omit directives
  whose value is undef instead of rendering them blank.
* `nagios::defaults::templates` no longer looks for a per operating system
  templates file; the shipped file moved to `files/nagios_templates.cfg`.
* The NRPE command classes call `$USER1$/check_nrpe` instead of
  `/usr/lib/nagios/plugins/check_nrpe`.
* `resource.cfg` is rendered from a template using `nagios::plugin_dir`
  instead of static per distribution files.

**Features**

* Class `nagios` exposes every `nagios.cfg` and `cgi.cfg` setting as a typed
  parameter; `allow_external_cmd` now drives `check_external_commands` and
  `cgi_authorized_users` accepts an array.
* Default contacts, contact groups, host groups and timeperiods are Hiera
  hashes; command classes take a `skip` list, filled in for Debian and
  Ubuntu from module data.
* `nagios::service::http` accepts a `Sensitive` password and fails at compile
  time when `use_auth` is set without credentials.
* `nagios::type::service` renders `hostgroup_name` and refuses `use_nrpe`
  without a `check_command`; contact notification commands accept arrays.
* Type aliases `Nagios::Flag`, `Nagios::Interval`, `Nagios::Port`,
  `Nagios::ServerNames` and `Nagios::SslMode`; functions
  `nagios::directives`, `nagios::object` and `nagios::tags`.
* puppet-strings documentation (REFERENCE.md), rspec-puppet tests for every
  class, define, function and type alias, PDK tooling.

**Bugfixes**

* `nagios::type::service` picked the wrong check_nrpe command when both
  `nrpe_args` and `nrpe_host` were involved.
* `nagios::defaults` included the deleted `nagios::defaults::plugins` class
  and failed to compile.
* `nagios::plugin::deploy` called `nagios::plugin` without its mandatory
  `source` and declared a duplicate file resource.
* `nagios::service::http` passed undef to the `Array` typed `server_names`
  of `nagios::type::service`.
* `debug_file` lacked its leading slash on RedHat and Arch Linux.
* `resource.cfg` was missing on Arch Linux and the Arch plugin directory
  had a trailing slash.
* `check_nrpe` was called from the wrong directory on RedHat x86_64.
