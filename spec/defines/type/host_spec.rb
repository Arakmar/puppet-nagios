# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::type::host' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'web' }

      fqdn = os_facts[:networking]['fqdn']
      cfg_dir = (os_facts[:os]['family'] == 'Debian') ? '/etc/nagios4' : '/etc/nagios'

      it { is_expected.to compile.with_all_deps }
      it { is_expected.not_to contain_concat__fragment("nagios_host_web_#{fqdn}") }

      it 'exports a fragment for servers without a server_name' do
        expect(exported_resources).to contain_concat__fragment("nagios_host_web_#{fqdn}")
          .with_target("#{cfg_dir}/conf.d/nagios_hosts.cfg")
          .with_order('30')
          .with_tag(['nagios_hosts'])
          .with_content("define host {\n  use generic-host\n  host_name #{fqdn}\n  address #{fqdn}\n}\n")
      end

      context 'with every kind of directive' do
        let(:params) do
          {
            host_name: 'web.example.org',
            address: '10.0.0.1',
            host_alias: 'Web',
            hostgroups: ['http-servers', 'all'],
            parents: ['router01'],
            contact_groups: [],
            notifications_enabled: false,
            flap_detection_enabled: 0,
            process_perf_data: '1',
            check_command: 'check-host-alive',
            max_check_attempts: 10,
            notification_interval: '30',
            notification_options: 'd,u,r',
            register: 1,
            server_names: ['mon1', 'mon2'],
          }
        end

        it 'renders them in Nagios syntax' do
          expect(exported_resources).to contain_concat__fragment("nagios_host_web_#{fqdn}")
            .with_tag(['nagios_hosts_mon1', 'nagios_hosts_mon2'])
            .with_content(<<~NAGIOS)
              define host {
                use generic-host
                host_name web.example.org
                address 10.0.0.1
                hostgroups http-servers,all
                alias Web
                parents router01
                notifications_enabled 0
                flap_detection_enabled 0
                process_perf_data 1
                check_command check-host-alive
                max_check_attempts 10
                notification_interval 30
                notification_options d,u,r
                register 1
              }
            NAGIOS
        end
      end

      context 'as a template' do
        let(:params) { { template_name: 'linux-host', register: 0 } }

        it { expect(exported_resources).to contain_concat__fragment("nagios_host_web_#{fqdn}").with_content(%r{^  name linux-host$}).with_content(%r{^  register 0$}) }
      end

      context 'with an invalid flag' do
        let(:params) { { notifications_enabled: 2 } }

        it { is_expected.to compile.and_raise_error(%r{Nagios::Flag}) }
      end
    end
  end
end
