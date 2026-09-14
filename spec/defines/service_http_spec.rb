# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::service::http' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'www' }

      fqdn = os_facts[:networking]['fqdn']

      context 'with defaults (http only)' do
        it { is_expected.to compile.with_all_deps }

        it 'checks http on port 80' do
          is_expected.to contain_nagios__type__service('http_www_')
            .with_host_name(fqdn)
            .with_use('generic-service')
            .with_service_description('Check http of www/')
            .with_check_command("check_http_port_url_content!www!80!/!''!ok")
            .with_server_names([])
        end

        it { is_expected.not_to contain_nagios__type__service('https_www_') }
        it { is_expected.not_to contain_nagios__type__service('https_www__cert') }
        it { is_expected.not_to contain_nagios__type__service('http_www_redirect') }
      end

      context 'with ssl_mode => true' do
        let(:params) { { ssl_mode: true, check_string: 'Welcome', check_domain: 'www.example.org', check_url: '/login', server_names: ['mon1'] } }

        it 'checks http content' do
          is_expected.to contain_nagios__type__service('http_www_Welcome')
            .with_check_command("check_http_port_url_content!www.example.org!80!/login!'Welcome'!ok")
            .with_server_names(['mon1'])
        end

        it { is_expected.to contain_nagios__type__service('https_www_Welcome').with_check_command("check_https_port_url_content!www.example.org!443!/login!'Welcome'!ok") }
        it 'checks the certificate' do
          is_expected.to contain_nagios__type__service('https_www_Welcome_cert')
            .with_check_command('check_https_port_cert!www.example.org!443!/login')
            .with_service_description('Check cert of www.example.org/login')
        end

        it { is_expected.not_to contain_nagios__type__service('http_www_redirect') }
      end

      context 'with ssl_mode => force' do
        let(:params) { { ssl_mode: 'force', port: 8443 } }

        it { is_expected.not_to contain_nagios__type__service('http_www_') }
        it { is_expected.to contain_nagios__type__service('https_www_').with_check_command("check_https_port_url_content!www!8443!/!''!ok") }
        it { is_expected.to contain_nagios__type__service('https_www__cert') }
        it 'checks the redirect' do
          is_expected.to contain_nagios__type__service('http_www_redirect')
            .with_check_command('check_http_port_code!www!8443!/!301')
            .with_service_description('Check http to https redirect of www/')
        end

        context 'with a custom redirect code' do
          let(:params) { super().merge(redirect_code: 308) }

          it { is_expected.to contain_nagios__type__service('http_www_redirect').with_check_command('check_http_port_code!www!8443!/!308') }
        end
      end

      context 'with ssl_mode => only and no certificate check' do
        let(:params) { { ssl_mode: 'only', check_cert: false } }

        it { is_expected.to contain_nagios__type__service('https_www_') }
        it { is_expected.not_to contain_nagios__type__service('https_www__cert') }
        it { is_expected.not_to contain_nagios__type__service('http_www_') }
        it { is_expected.not_to contain_nagios__type__service('http_www_redirect') }
      end

      context 'with basic authentication' do
        let(:params) { { ssl_mode: 'only', use_auth: true, auth_name: 'bob', auth_password: sensitive('s3cret'), redirect_status: 'follow' } }

        it 'unwraps the password into the command' do
          is_expected.to contain_nagios__type__service('https_www_')
            .with_service_description('Check https of www/ with authentification')
            .with_check_command("check_https_port_auth_content!www!443!/!''!bob!s3cret!follow")
        end

        context 'with a plain string password over http' do
          let(:params) { { use_auth: true, auth_name: 'bob', auth_password: 's3cret' } }

          it { is_expected.to contain_nagios__type__service('http_www_').with_check_command("check_http_port_auth_content!www!80!/!''!bob!s3cret!ok") }
        end
      end

      context 'with use_auth but no credentials' do
        let(:params) { { use_auth: true } }

        it { is_expected.to compile.and_raise_error(%r{use_auth requires auth_name and auth_password}) }
      end

      context 'with an invalid ssl_mode' do
        let(:params) { { ssl_mode: 'yes' } }

        it { is_expected.to compile.and_raise_error(%r{Nagios::SslMode}) }
      end
    end
  end
end
