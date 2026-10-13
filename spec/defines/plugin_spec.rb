# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::plugin' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'check_foo' }
      let(:params) { { source: 'puppet:///modules/site/check_foo' } }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package(plugins_package) }

      it 'installs the plugin into the plugin directory' do
        is_expected.to contain_file('check_foo')
          .with_ensure('present')
          .with_path("#{plugin_dir}/check_foo")
          .with_source('puppet:///modules/site/check_foo')
          .with_mode('0755')
          .that_requires("Package[#{plugins_package}]")
      end

      context 'with ensure absent' do
        let(:params) { super().merge(ensure: 'absent') }

        it { is_expected.to contain_file('check_foo').with_ensure('absent') }
      end

      context 'when the server class already manages the package' do
        let(:pre_condition) { 'include nagios' }

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
