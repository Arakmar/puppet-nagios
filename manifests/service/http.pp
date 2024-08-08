# ssl_mode:
#   - false: only check http
#   - true: check http and https
#   - force: http is permanent redirect to https
#   - only: check only https
define nagios::service::http (
  $check_domain    = $name,
  $check_url       = '/',
  $check_string    = '',
  $use             = 'generic-service',
  $ssl_mode        = false,
  $use_auth        = false,
  $check_cert      = true,
  $auth_name       = '',
  $auth_password   = '',
  $redirect_status = 'ok',
  $server_names    = undef
) {

  if $ssl_mode {
    if $use_auth {
      nagios::type::service { "https_${name}_${check_string}":
        host_name           => $facts['networking']['fqdn'],
        use                 => $use,
        service_description => "Check https of ${check_domain}${check_url} with authentification",
        server_names        => $server_names,
        check_command       => "check_https_auth_content!${check_domain}!${check_url}!'${check_string}'!${auth_name}!${auth_password}!${redirect_status}",
      }
    }
    else {
      nagios::type::service { "https_${name}_${check_string}":
        host_name           => $facts['networking']['fqdn'],
        use                 => $use,
        service_description => "Check https of ${check_domain}${check_url}",
        server_names        => $server_names,
        check_command       => "check_https_url_content!${check_domain}!${check_url}!'${check_string}'!${redirect_status}",
      }
    }

    if $check_cert {
      nagios::type::service { "https_${name}_${check_string}_cert":
        host_name           => $facts['networking']['fqdn'],
        use                 => $use,
        service_description => "Check cert of ${check_domain}${check_url}",
        server_names        => $server_names,
        check_command       => "check_https_cert!${check_domain}!${check_url}",
      }
    }
  } else {
    if $use_auth {
      nagios::type::service { "http_${name}_${check_string}":
        host_name           => $facts['networking']['fqdn'],
        use                 => $use,
        service_description => "Check http of ${check_domain}${check_url} with authentification",
        server_names        => $server_names,
        check_command       => "check_http_auth_content!${check_domain}!${check_url}!'${check_string}'!${auth_name}!${auth_password}!${redirect_status}",
      }
    }
    else {
      nagios::type::service { "http_${name}_${check_string}":
        host_name           => $facts['networking']['fqdn'],
        use                 => $use,
        service_description => "Check http of ${check_domain}${check_url}",
        server_names        => $server_names,
        check_command       => "check_http_url_content!${check_domain}!${check_url}!'${check_string}'!${redirect_status}",
      }
    }
  }
}
