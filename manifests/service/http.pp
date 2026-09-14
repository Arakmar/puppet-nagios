# @summary Exports http and https content checks for a web site.
#
# Depending on ssl_mode the define exports up to three nagios::type::service
# resources for the current node, all relying on the commands declared by
# nagios::command::http on the server:
#
# | ssl_mode | http content | https content | certificate | http redirect |
# |----------|--------------|---------------|-------------|---------------|
# | `false`  | yes          |               |             |               |
# | `true`   | yes          | yes           | check_cert  |               |
# | `force`  |              | yes           | check_cert  | yes           |
# | `only`   |              | yes           | check_cert  |               |
#
# The credentials given with use_auth end up in clear text in the exported
# fragment, in PuppetDB and in the Nagios configuration file, as Nagios needs
# them. Passing auth_password as Sensitive only keeps it out of the catalog,
# report and logs of the monitored node.
#
# @example Check that a site answers over https and redirects http to it
#   nagios::service::http { 'www.example.org':
#     ssl_mode     => 'force',
#     check_string => 'Welcome',
#     server_names => ['monitoring1'],
#   }
#
# @param check_domain Host header and address checked, defaults to the resource title.
# @param check_url URL path checked.
# @param check_string String expected in the response body.
# @param use Service template to inherit from.
# @param port Port for both http and https, defaults to 80 and 443.
# @param ssl_mode Which of http and https to check, see the table above.
# @param use_auth Send HTTP basic authentication credentials.
# @param check_cert Also check the certificate validity when https is checked.
# @param auth_name Basic authentication user, required with use_auth.
# @param auth_password Basic authentication password, required with use_auth.
# @param redirect_status How check_http follows redirects (its -f option).
# @param redirect_code HTTP status expected from http when ssl_mode is force.
# @param server_names Nagios servers that collect these services; empty means
#   servers declared without a server_name.
define nagios::service::http (
  String[1]                                          $check_domain    = $name,
  String[1]                                          $check_url       = '/',
  Optional[String[1]]                                $check_string    = undef,
  String[1]                                          $use             = 'generic-service',
  Optional[Nagios::Port]                             $port            = undef,
  Nagios::SslMode                                    $ssl_mode        = false,
  Boolean                                            $use_auth        = false,
  Boolean                                            $check_cert      = true,
  Optional[String[1]]                                $auth_name       = undef,
  Optional[Variant[String[1], Sensitive[String[1]]]] $auth_password   = undef,
  Enum['ok', 'warning', 'critical', 'follow', 'sticky', 'stickyport'] $redirect_status = 'ok',
  Integer[300, 399]                                  $redirect_code   = 301,
  Nagios::ServerNames                                $server_names    = [],
) {
  if $use_auth and ($auth_name =~ Undef or $auth_password =~ Undef) {
    fail("nagios::service::http[${name}]: use_auth requires auth_name and auth_password")
  }

  $password = $auth_password ? {
    Sensitive => $auth_password.unwrap,
    default   => $auth_password,
  }

  $fqdn       = $facts['networking']['fqdn']
  $http_port  = pick($port, 80)
  $https_port = pick($port, 443)
  $string     = pick_default($check_string, '')
  $auth_desc  = $use_auth ? {
    true    => ' with authentification',
    default => '',
  }

  $check_http  = $ssl_mode in [false, true]
  $check_https = $ssl_mode != false

  if $check_https {
    $https_command = $use_auth ? {
      true    => "check_https_port_auth_content!${check_domain}!${https_port}!${check_url}!'${string}'!${auth_name}!${password}!${redirect_status}",
      default => "check_https_port_url_content!${check_domain}!${https_port}!${check_url}!'${string}'!${redirect_status}",
    }

    nagios::type::service { "https_${name}_${string}":
      host_name           => $fqdn,
      use                 => $use,
      service_description => "Check https of ${check_domain}${check_url}${auth_desc}",
      check_command       => $https_command,
      server_names        => $server_names,
    }

    if $check_cert {
      nagios::type::service { "https_${name}_${string}_cert":
        host_name           => $fqdn,
        use                 => $use,
        service_description => "Check cert of ${check_domain}${check_url}",
        check_command       => "check_https_port_cert!${check_domain}!${https_port}!${check_url}",
        server_names        => $server_names,
      }
    }
  }

  if $check_http {
    $http_command = $use_auth ? {
      true    => "check_http_port_auth_content!${check_domain}!${http_port}!${check_url}!'${string}'!${auth_name}!${password}!${redirect_status}",
      default => "check_http_port_url_content!${check_domain}!${http_port}!${check_url}!'${string}'!${redirect_status}",
    }

    nagios::type::service { "http_${name}_${string}":
      host_name           => $fqdn,
      use                 => $use,
      service_description => "Check http of ${check_domain}${check_url}${auth_desc}",
      check_command       => $http_command,
      server_names        => $server_names,
    }
  }

  if $ssl_mode == 'force' {
    nagios::type::service { "http_${name}_redirect":
      host_name           => $fqdn,
      use                 => $use,
      service_description => "Check http to https redirect of ${check_domain}${check_url}",
      check_command       => "check_http_port_code!${check_domain}!${http_port}!${check_url}!${redirect_code}",
      server_names        => $server_names,
    }
  }
}
