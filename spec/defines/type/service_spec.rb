# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::type::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'load' }
      let(:params) { { host_name: 'web.example.org', check_command: 'check_load!5!10', service_description: 'Load' } }

      fqdn = os_facts[:networking]['fqdn']
      cfg_dir = (os_facts[:os]['family'] == 'Debian') ? '/etc/nagios4' : '/etc/nagios'

      it { is_expected.to compile.with_all_deps }

      it 'exports a service fragment' do
        expect(exported_resources).to contain_concat__fragment("nagios_service_load_#{fqdn}")
          .with_target("#{cfg_dir}/conf.d/nagios_service.cfg")
          .with_order('30')
          .with_tag(['nagios_service'])
          .with_content("define service {\n  use generic-service\n  service_description Load\n  host_name web.example.org\n  check_command check_load!5!10\n}\n")
      end

      context 'with groups, contacts and flags' do
        let(:params) do
          super().merge(
            hostgroup_name: ['http-servers'],
            contacts: ['root', 'ops'],
            contact_groups: ['admins'],
            check_interval: 5,
            retry_check_interval: '1',
            active_checks_enabled: true,
            passive_checks_enabled: false,
            is_volatile: 0,
            event_handler: 'restart-httpd',
            server_names: ['mon1'],
          )
        end

        it 'renders them' do
          expect(exported_resources).to contain_concat__fragment("nagios_service_load_#{fqdn}")
            .with_tag(['nagios_service_mon1'])
            .with_content(%r{^  hostgroup_name http-servers$})
            .with_content(%r{^  contacts root,ops$})
            .with_content(%r{^  contact_groups admins$})
            .with_content(%r{^  check_interval 5$})
            .with_content(%r{^  retry_check_interval 1$})
            .with_content(%r{^  active_checks_enabled 1$})
            .with_content(%r{^  passive_checks_enabled 0$})
            .with_content(%r{^  is_volatile 0$})
            .with_content(%r{^  event_handler restart-httpd$})
        end
      end

      context 'with use_nrpe' do
        let(:params) { { host_name: 'web.example.org', check_command: 'check_load', use_nrpe: true } }

        it 'uses check_nrpe_1arg_timeout_port' do
          expect(exported_resources).to contain_concat__fragment("nagios_service_load_#{fqdn}")
            .with_content(%r{^  check_command check_nrpe_1arg_timeout_port!60!check_load!5666$})
        end

        context 'with nrpe_args' do
          let(:params) { super().merge(nrpe_args: '-w 5 -c 10', nrpe_port: '5667', nrpe_timeout: 30) }

          it 'uses check_nrpe_timeout_port' do
            expect(exported_resources).to contain_concat__fragment("nagios_service_load_#{fqdn}")
              .with_content(%r{^  check_command check_nrpe_timeout_port!30!check_load!5667!"-w 5 -c 10"$})
          end
        end

        context 'with nrpe_host' do
          let(:params) { super().merge(nrpe_host: '10.0.0.2') }

          it 'uses check_nrpe_1arg_host_timeout_port' do
            expect(exported_resources).to contain_concat__fragment("nagios_service_load_#{fqdn}")
              .with_content(%r{^  check_command check_nrpe_1arg_host_timeout_port!10\.0\.0\.2!check_load!5666!60$})
          end
        end

        context 'with nrpe_host and nrpe_args' do
          let(:params) { super().merge(nrpe_host: '10.0.0.2', nrpe_args: '-w 5') }

          it 'uses check_nrpe_host_timeout_port' do
            expect(exported_resources).to contain_concat__fragment("nagios_service_load_#{fqdn}")
              .with_content(%r{^  check_command check_nrpe_host_timeout_port!10\.0\.0\.2!check_load!5666!"-w 5"!60$})
          end
        end

        context 'without check_command' do
          let(:params) { { host_name: 'web.example.org', use_nrpe: true } }

          it { is_expected.to compile.and_raise_error(%r{check_command is required when use_nrpe is true}) }
        end
      end
    end
  end
end
