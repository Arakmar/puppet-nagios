# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::type::contactgroup' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'admins' }
      let(:params) { { contactgroup_alias: 'Nagios Administrators', members: ['root', 'ops'] } }

      fqdn = os_facts[:networking]['fqdn']

      it { is_expected.to compile.with_all_deps }

      it 'declares a contactgroup fragment' do
        is_expected.to contain_concat__fragment("nagios_contactgroup_admins_#{fqdn}")
          .with_target(%r{/conf\.d/nagios_contactgroup\.cfg$})
          .with_tag('nagios_contactgroup')
          .with_content("define contactgroup {\n  contactgroup_name admins\n  alias Nagios Administrators\n  members root,ops\n}\n")
      end

      context 'without members' do
        let(:params) { {} }

        it { is_expected.to contain_concat__fragment("nagios_contactgroup_admins_#{fqdn}").with_content("define contactgroup {\n  contactgroup_name admins\n}\n") }
      end
    end
  end
end
