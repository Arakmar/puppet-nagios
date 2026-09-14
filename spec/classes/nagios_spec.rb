# frozen_string_literal: true

require 'spec_helper'

describe 'nagios' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      family = os_facts[:os]['family']
      cfg_dir = (family == 'Debian') ? '/etc/nagios4' : '/etc/nagios'
      package = (family == 'Debian') ? 'nagios4' : 'nagios'
      plugin_dir = case family
                   when 'Debian' then '/usr/lib/nagios/plugins'
                   when 'Archlinux' then '/usr/lib/monitoring-plugins'
                   else '/usr/lib64/nagios/plugins'
                   end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_package(package) }
      it { is_expected.to contain_service(package).with_ensure('running').with_enable(true) }

      it 'renders nagios.cfg from module data' do
        is_expected.to contain_file('nagios_main_cfg')
          .with_path("#{cfg_dir}/nagios.cfg")
          .with_content(%r{^cfg_dir=#{cfg_dir}/conf\.d$})
          .with_content(%r{^check_external_commands=1$})
          .with_content(%r{^soft_state_dependencies=0$})
          .with_content(%r{^command_check_interval=-1$})
          .with_content(%r{^debug_file=/var/(spool|log)/nagios4?/nagios\.debug$})
          .that_notifies("Service[#{package}]")
      end

      it 'renders resource.cfg with the plugin directory' do
        is_expected.to contain_file('nagios_resource_cfg')
          .with_mode('0640')
          .with_content(%r{^\$USER1\$=#{plugin_dir}$})
      end

      it 'renders cgi.cfg' do
        is_expected.to contain_file('nagios_cgi_cfg')
          .with_path("#{cfg_dir}/cgi.cfg")
          .with_content(%r{^use_authentication=1$})
          .with_content(%r{^authorized_for_all_hosts=nagiosadmin$})
          .with_content(%r{^ack_no_sticky=1$})
      end

      it { is_expected.to contain_file('nagios_confd').with_path("#{cfg_dir}/conf.d").with_purge(true) }
      it { is_expected.to contain_file('nagios_commands_cfg').with_ensure('absent') }

      ['hosts', 'service', 'servicedependency', 'hostextinfo'].each do |type|
        it { is_expected.to contain_nagios__collect_type(type).with_exported(true).with_server_name(nil) }
        it { is_expected.to contain_concat("#{cfg_dir}/conf.d/nagios_#{type}.cfg").that_notifies("Service[#{package}]") }
        it { is_expected.to contain_concat__fragment("type_header_#{type}").with_order('05').with_content(%r{nagios #{type} entries}) }
      end

      ['command', 'contact', 'contactgroup', 'hostgroup', 'timeperiod'].each do |type|
        it { is_expected.to contain_nagios__collect_type(type).with_exported(false) }
      end

      if family == 'Debian'
        it { is_expected.to contain_file('nagios_main_cfg').with_content(%r{^cfg_dir=/etc/nagios-plugins/config$}) }
        it { is_expected.to contain_file('nagios_main_cfg').with_content(%r{^enable_environment_macros=0$}) }
      else
        it { is_expected.to contain_file('nagios_main_cfg').with_content(%r{^enable_environment_macros=1$}) }
      end

      context 'with server_name and custom parameters' do
        let(:params) do
          {
            server_name: 'mon1',
            allow_external_cmd: false,
            soft_state_dependencies: true,
            cgi_authorized_users: ['alice', 'bob'],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nagios__collect_type('hosts').with_server_name('mon1') }
        it { is_expected.to contain_nagios__collect_type('command').without_server_name }
        it { is_expected.to contain_file('nagios_main_cfg').with_content(%r{^check_external_commands=0$}) }
        it { is_expected.to contain_file('nagios_main_cfg').with_content(%r{^soft_state_dependencies=1$}) }
        it { is_expected.to contain_file('nagios_cgi_cfg').with_content(%r{^authorized_for_all_services=alice,bob$}) }
      end
    end
  end
end
