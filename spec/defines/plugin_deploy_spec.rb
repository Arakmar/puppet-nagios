# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::plugin::deploy' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'check_foo' }

      package = (os_facts[:os]['family'] == 'RedHat') ? 'nagios-plugins' : 'monitoring-plugins'

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package(package) }

      it 'delegates to nagios::plugin with a source inside this module' do
        is_expected.to contain_nagios__plugin('check_foo')
          .with_ensure('present')
          .with_source('puppet:///modules/nagios/plugins/check_foo')
          .that_requires("Package[#{package}]")
      end

      context 'with a custom source and package' do
        let(:params) { { source: 'site/plugins/check_foo', require_package: 'site-plugins', ensure: 'absent' } }

        it { is_expected.to contain_package('site-plugins') }
        it { is_expected.to contain_nagios__plugin('check_foo').with_ensure('absent').with_source('puppet:///modules/site/plugins/check_foo') }
      end
    end
  end
end
