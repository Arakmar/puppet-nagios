# ssl_mode:
#   - false: only check http
#   - true: check http and https
#   - force: http is permanent redirect to https
#   - only: check only https
define nagios::service::http(
    $ensure = present,
    $check_domain = "$name",
    $check_url = '/',
    $check_string = '',
    $use = 'generic-service',
    $ssl_mode = false,
    $use_auth = false,
    $auth_name = "",
    $auth_password = "",
    $redirect_status = 'ok',
    $server_name = "default"
){

        if $ssl_mode {
                        if $use_auth {
                                nagios::type::service{"https_${name}_${check_string}":
                                        host_name => $::fqdn,
                                        ensure => $ensure,
                                        use => $use,
                                        service_description => "Check https of ${check_domain}${check_url} with authentification",
                                        server_name => $server_name,
                                        check_command => "check_https_auth_string!${check_domain}!${check_url}!'${check_string}'!${auth_name}!${auth_password}!${redirect_status}",
                                }
                        }
                        else {
                                nagios::type::service{"https_${name}_${check_string}":
                                        host_name => $::fqdn,
                                        ensure => $ensure,
                                        use => $use,
                                        service_description => "Check https of ${check_domain}${check_url}",
                                        server_name => $server_name,
                                        check_command => "check_https_string!${check_domain}!${check_url}!'${check_string}'!${redirect_status}",
                                }
                        }
                        nagios::type::service{"https_${name}_${check_string}_cert":
                                        host_name => $::fqdn,
                                        ensure => $ensure,
                                        use => $use,
                                        service_description => "Check cert of ${check_domain}${check_url}",
                                        server_name => $server_name,
                                        check_command => "check_https_cert!${check_domain}!${check_url}",
                        }
        } else {
                        if $use_auth {
                                nagios::type::service{"http_${name}_${check_string}":
                                        host_name => $::fqdn,
                                        ensure => $ensure,
                                        use => $use,
                                        service_description => "Check http of ${check_domain}${check_url} with authentification",
                                        server_name => $server_name,
                                        check_command => "check_http_auth_string!${check_domain}!${check_url}!'${check_string}'!${auth_name}!${auth_password}!${redirect_status}",
                                }
                        }
                        else {
                                nagios::type::service{"http_${name}_${check_string}":
                                        host_name => $::fqdn,
                                        ensure => $ensure,
                                        use => $use,
                                        service_description => "Check http of ${check_domain}${check_url}",
                                        server_name => $server_name,
                                        check_command => "check_http_string!${check_domain}!${check_url}!'${check_string}'!${redirect_status}",
                                }
                        }
        }
}
