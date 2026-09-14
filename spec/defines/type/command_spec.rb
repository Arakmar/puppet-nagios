# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::type::command' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'check_foo' }
      let(:params) { { command_line: '$USER1$/check_foo -H $HOSTADDRESS$' } }

      cfg_dir = (os_facts[:os]['family'] == 'Debian') ? '/etc/nagios4' : '/etc/nagios'

      it { is_expected.to compile.with_all_deps }

      it 'declares a local command fragment' do
        is_expected.to contain_concat__fragment('nagios_command_check_foo')
          .with_target("#{cfg_dir}/conf.d/nagios_command.cfg")
          .with_order('30')
          .with_tag('nagios_command')
          .with_content("define command {\n  command_name check_foo\n  command_line $USER1$/check_foo -H $HOSTADDRESS$\n}\n")
      end

      context 'with command_name and use' do
        let(:params) { super().merge(command_name: 'check_bar', use: 'generic-command') }

        it { is_expected.to contain_concat__fragment('nagios_command_check_foo').with_content(%r{^  command_name check_bar$}).with_content(%r{^  use generic-command$}) }
      end
    end
  end
end
