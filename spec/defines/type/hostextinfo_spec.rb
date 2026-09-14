# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::type::hostextinfo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'web' }
      let(:params) { { host_name: 'web.example.org', icon_image: 'linux.png', notes: 'Web frontend' } }

      fqdn = os_facts[:networking]['fqdn']

      it { is_expected.to compile.with_all_deps }

      it 'exports a hostextinfo fragment' do
        expect(exported_resources).to contain_concat__fragment("nagios_hostextinfo_web_#{fqdn}")
          .with_target(%r{/conf\.d/nagios_hostextinfo\.cfg$})
          .with_order('30')
          .with_tag(['nagios_hostextinfo'])
          .with_content("define hostextinfo {\n  host_name web.example.org\n  notes Web frontend\n  icon_image linux.png\n}\n")
      end
    end
  end
end
