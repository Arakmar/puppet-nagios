# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::type::timeperiod' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'workhours' }
      let(:params) { { timeperiod_alias: 'Standard Work Hours', monday: '09:00-17:00', friday: '09:00-17:00' } }

      fqdn = os_facts[:networking]['fqdn']

      it { is_expected.to compile.with_all_deps }

      it 'declares a timeperiod fragment' do
        is_expected.to contain_concat__fragment("nagios_timeperiod_workhours_#{fqdn}")
          .with_target(%r{/conf\.d/nagios_timeperiod\.cfg$})
          .with_tag('nagios_timeperiod')
          .with_content("define timeperiod {\n  timeperiod_name workhours\n  alias Standard Work Hours\n  monday 09:00-17:00\n  friday 09:00-17:00\n}\n")
      end
    end
  end
end
