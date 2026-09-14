# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::type::servicedependency' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'db_before_web' }
      let(:params) do
        {
          host_name: 'db.example.org',
          service_description: 'MySQL',
          dependent_host_name: 'web.example.org',
          dependent_service_description: 'HTTP',
          inherits_parent: true,
          execution_failure_criteria: 'w,u,c',
          server_names: ['mon1'],
        }
      end

      fqdn = os_facts[:networking]['fqdn']

      it { is_expected.to compile.with_all_deps }

      it 'exports a servicedependency fragment' do
        expect(exported_resources).to contain_concat__fragment("nagios_servicedependency_db_before_web_#{fqdn}")
          .with_target(%r{/conf\.d/nagios_servicedependency\.cfg$})
          .with_tag(['nagios_servicedependency_mon1'])
          .with_content(<<~NAGIOS)
            define servicedependency {
              host_name db.example.org
              service_description MySQL
              dependent_host_name web.example.org
              dependent_service_description HTTP
              inherits_parent 1
              execution_failure_criteria w,u,c
            }
          NAGIOS
      end
    end
  end
end
