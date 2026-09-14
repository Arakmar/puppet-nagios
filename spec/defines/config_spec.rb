# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include nagios' }
      let(:title) { 'extra' }

      cfg_dir = (os_facts[:os]['family'] == 'Debian') ? '/etc/nagios4' : '/etc/nagios'

      context 'with content' do
        let(:params) { { content: "define host {\n}\n" } }

        it { is_expected.to compile.with_all_deps }

        it 'installs the file under conf.d' do
          is_expected.to contain_file('nagios_extra')
            .with_ensure('present')
            .with_path("#{cfg_dir}/conf.d/custom_extra")
            .with_content("define host {\n}\n")
            .with_mode('0644')
        end
      end

      context 'with source and ensure absent' do
        let(:params) { { source: 'puppet:///modules/site/extra.cfg', ensure: 'absent' } }

        it { is_expected.to contain_file('nagios_extra').with_ensure('absent').with_source('puppet:///modules/site/extra.cfg') }
      end

      context 'with neither content nor source' do
        it { is_expected.to compile.and_raise_error(%r{needs either of content or source}) }
      end

      context 'with both content and source' do
        let(:params) { { content: 'x', source: 'puppet:///modules/site/extra.cfg' } }

        it { is_expected.to compile.and_raise_error(%r{cannot have both content and source}) }
      end
    end
  end
end
