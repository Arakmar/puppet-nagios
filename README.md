# nagios

[![CI](https://github.com/Arakmar/puppet-nagios/actions/workflows/ci.yml/badge.svg)](https://github.com/Arakmar/puppet-nagios/actions/workflows/ci.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/arakmar/nagios.svg)](https://forge.puppet.com/modules/arakmar/nagios)

## Table of contents

1. [Description](#description)
1. [Setup](#setup)
1. [Usage](#usage)
    * [The monitoring server](#the-monitoring-server)
    * [Monitored nodes](#monitored-nodes)
    * [Web site checks](#web-site-checks)
    * [NRPE checks](#nrpe-checks)
    * [Custom configuration and plugins](#custom-configuration-and-plugins)
    * [Hiera keys](#hiera-keys)
1. [Limitations](#limitations)
1. [Development](#development)

## Description

This module manages a Nagios 4 server and builds its object configuration
from resources declared across the Puppet infrastructure. Monitored nodes
export `nagios::type::host`, `nagios::type::service`,
`nagios::type::servicedependency` and `nagios::type::hostextinfo` resources;
the server collects them into `conf.d/nagios_<type>.cfg` files through
`puppetlabs/concat`. Commands, contacts, contact groups, host groups and
timeperiods are declared on the server itself.

Several servers can coexist: each one is declared with a `server_name` and
only collects the objects whose `server_names` include it.

## Setup

### Requirements

* Puppet 7 or 8 with PuppetDB, since the module relies on exported resources.
* [puppetlabs/stdlib](https://forge.puppet.com/modules/puppetlabs/stdlib) 9.x
  and [puppetlabs/concat](https://forge.puppet.com/modules/puppetlabs/concat)
  9.x.
* A supported operating system: RHEL family 8 and 9, Debian 11 and 12,
  Ubuntu 20.04 and 22.04, or Arch Linux. Debian and Ubuntu use the `nagios4`
  packages; Nagios 3 is not supported.

## Usage

### The monitoring server

```puppet
class { 'nagios':
  server_name => 'monitoring1',
}
include nagios::defaults
```

`nagios::defaults` declares a usable base configuration: the check and
notification commands, a `root` contact and `admins` contact group, a set of
host groups, the `24x7`, `workhours`, `nonworkhours` and `never` timeperiods,
and the `generic-host`, `generic-service` and `generic-contact` templates.
Every default object set is a Hiera hash that can be extended or replaced,
for example:

```yaml
nagios::defaults::contacts::contacts:
  root:
    contact_alias: Root
    email: ops@example.org
    service_notification_commands: notify-service-by-email
    host_notification_commands: notify-host-by-email
```

Objects the server itself needs are declared with the `nagios::type::*`
defines directly on it:

```puppet
nagios::type::hostgroup { 'web-servers':
  hostgroup_alias => 'Web servers',
}

nagios::type::command { 'check_dns_example':
  command_line => '$USER1$/check_dns -H example.org -s $HOSTADDRESS$',
}
```

`$USER1$` is set to the plugin directory of the distribution in
`resource.cfg`.

### Monitored nodes

Monitored nodes export their objects; the server collects them on its next
run.

```puppet
nagios::type::host { $facts['networking']['fqdn']:
  parents      => ['router01'],
  hostgroups   => ['web-servers'],
  server_names => ['monitoring1'],
}

nagios::type::service { 'ssh':
  host_name           => $facts['networking']['fqdn'],
  service_description => 'SSH',
  check_command       => 'check_ssh',
  server_names        => ['monitoring1'],
}
```

Leave `server_names` empty to target the servers declared without a
`server_name`. Directives accept the value Nagios expects; flags such as
`notifications_enabled` also accept booleans, and list directives such as
`hostgroups`, `parents`, `contacts` or `contact_groups` take arrays.

### Web site checks

`nagios::service::http` exports content, certificate and redirect checks for
a web site, using the commands declared by `nagios::command::http` (included
by `nagios::defaults`).

```puppet
nagios::service::http { 'www.example.org':
  check_url    => '/health',
  check_string => 'OK',
  ssl_mode     => 'force',
  server_names => ['monitoring1'],
}
```

| `ssl_mode` | http content | https content | certificate (`check_cert`) | http redirect (`redirect_code`) |
|------------|:------------:|:-------------:|:--------------------------:|:-------------------------------:|
| `false`    | yes          |               |                            |                                 |
| `true`     | yes          | yes           | yes                        |                                 |
| `force`    |              | yes           | yes                        | yes                             |
| `only`     |              | yes           | yes                        |                                 |

With `use_auth`, `auth_name` and `auth_password` are sent as HTTP basic
authentication. `auth_password` may be a `Sensitive` value, which keeps it
out of the catalog and reports of the monitored node. It still ends up in
clear text in the exported fragment, in PuppetDB and in the Nagios
configuration, as Nagios needs it.

### NRPE checks

`nagios::type::service` wraps the check into `check_nrpe` when `use_nrpe` is
set. The server must declare the matching commands:

```puppet
# on the server
include nagios::command::nrpe_timeout   # checks against the monitored host
include nagios::command::nrpe_host      # checks with an explicit nrpe_host
```

```puppet
# on the monitored node
nagios::type::service { 'load':
  host_name     => $facts['networking']['fqdn'],
  use_nrpe      => true,
  check_command => 'check_load',
  nrpe_args     => '-w 5,4,3 -c 10,8,6',
  nrpe_timeout  => 30,
  server_names  => ['monitoring1'],
}
```

| `nrpe_args` | `nrpe_host` | command                             |
|-------------|-------------|-------------------------------------|
| no          | no          | `check_nrpe_1arg_timeout_port`      |
| yes         | no          | `check_nrpe_timeout_port`           |
| no          | yes         | `check_nrpe_1arg_host_timeout_port` |
| yes         | yes         | `check_nrpe_host_timeout_port`      |

### Custom configuration and plugins

```puppet
# an arbitrary file in conf.d
nagios::config { 'servicegroups':
  source => 'puppet:///modules/site/nagios/servicegroups.cfg',
}

# a plugin from any module
nagios::plugin { 'check_foo':
  source => 'puppet:///modules/site/nagios/check_foo',
}

# a plugin shipped as files/plugins/<name> in this module
nagios::plugin::deploy { 'check_bar': }
```

### Hiera keys

Package names, paths and the service name are module data, resolved from
`data/os/<family>/<architecture>.yaml`, `data/os/<family>.yaml` and
`data/common.yaml`. The `nagios::type::*`, `nagios::config` and
`nagios::plugin` defines look these keys up too so that monitored nodes
agree with the server without declaring the server class. Override them in
Hiera, not with a resource-like declaration of `class { 'nagios': }`.

| Key | Purpose |
|-----|---------|
| `nagios::package`, `nagios::nrpe_package`, `nagios::plugin_package` | Packages installed |
| `nagios::service` | Service notified on configuration changes |
| `nagios::cfg_dir` | Configuration directory holding `nagios.cfg` and `conf.d` |
| `nagios::plugin_dir` | Plugin directory, exported as `$USER1$` |
| `nagios::subcfg_dirs` | `cfg_dir` entries of `nagios.cfg` |
| `nagios::*_file`, `nagios::*_path` | Paths written to `nagios.cfg` and `cgi.cfg` |
| `nagios::allow_external_cmd`, `nagios::soft_state_dependencies`, `nagios::command_check_interval`, `nagios::enable_environment_macros` | Behaviour settings of `nagios.cfg` |
| `nagios::use_authentication`, `nagios::default_user_name`, `nagios::cgi_authorized_users`, `nagios::ack_no_sticky`, `nagios::ack_no_send` | `cgi.cfg` settings |
| `nagios::defaults::*::*` | Default objects declared by `nagios::defaults` |
| `nagios::command::*::skip`, `nagios::defaults::commands::skip` | Commands not declared because the distribution ships them |

See [REFERENCE.md](REFERENCE.md) for every class, define, function, type
alias and parameter.

## Limitations

* Objects removed from the manifests disappear from the server on its next
  run only once PuppetDB has expired the exporting node's resources, or when
  the exporting node runs again without them.
* Nagios templates cannot be exported; `nagios::defaults::templates` installs
  them from a static file (`source` parameter to replace it).
* The `nagios::type::*` defines write the fragment target path with the
  paths of the exporting node; `nagios::collect_type` rewrites it on the
  server, so mixed distributions work, but the keys above must not be
  overridden differently per node.

## Development

```
pdk validate
pdk test unit
pdk test unit --puppet-version 7
pdk bundle exec rake strings:generate:reference
```

GitHub Actions run the same checks on every pull request and push to
`master`: static validations, RuboCop, a REFERENCE.md freshness check and the
unit tests for every Puppet version listed in `metadata.json`
(`.github/workflows/ci.yml`, modelled on the
[Vox Pupuli](https://github.com/voxpupuli/gha-puppet) workflows).

Pushing a `v<version>` tag publishes the module to the Puppet Forge and
creates a GitHub release through the Vox Pupuli reusable release workflow
(`.github/workflows/release.yml`). The repository needs a `release`
environment and the `PUPPET_FORGE_USERNAME` and `PUPPET_FORGE_API_KEY`
secrets; bump `metadata.json` to the tagged version first.

This module is licensed under the GPL-3.0-only license, see
[LICENSE](LICENSE). It descends from the work of David Schmitt, the immerda
project, Puzzle ITC and Riseup Networks.
