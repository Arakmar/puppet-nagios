# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::type::hostgroup' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'all' }
      let(:params) { { hostgroup_alias: 'All Servers', members: ['*'] } }

      fqdn = os_facts[:networking]['fqdn']

      it { is_expected.to compile.with_all_deps }

      it 'declares a hostgroup fragment' do
        is_expected.to contain_concat__fragment("nagios_hostgroup_all_#{fqdn}")
          .with_target(%r{/conf\.d/nagios_hostgroup\.cfg$})
          .with_tag('nagios_hostgroup')
          .with_content("define hostgroup {\n  hostgroup_name all\n  alias All Servers\n  members *\n}\n")
      end

      context 'with use and a custom name' do
        let(:params) { { hostgroup_name: 'everything', use: 'generic-hostgroup' } }

        it { is_expected.to contain_concat__fragment("nagios_hostgroup_all_#{fqdn}").with_content("define hostgroup {\n  hostgroup_name everything\n  use generic-hostgroup\n}\n") }
      end
    end
  end
end
