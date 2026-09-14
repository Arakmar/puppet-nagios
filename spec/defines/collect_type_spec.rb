# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::collect_type' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include nagios' }
      let(:title) { 'custom' }

      cfg_dir = (os_facts[:os]['family'] == 'Debian') ? '/etc/nagios4' : '/etc/nagios'
      service = (os_facts[:os]['family'] == 'Debian') ? 'nagios4' : 'nagios'

      it { is_expected.to compile.with_all_deps }

      it 'assembles the file under conf.d by default' do
        is_expected.to contain_concat("#{cfg_dir}/conf.d/nagios_custom.cfg")
          .with_owner('root').with_mode('0644')
          .that_notifies("Service[#{service}]")
      end

      it 'writes a header fragment' do
        is_expected.to contain_concat__fragment('type_header_custom')
          .with_target("#{cfg_dir}/conf.d/nagios_custom.cfg")
          .with_order('05')
          .with_content(%r{^# Definitions of all nagios custom entries$})
      end

      context 'with a custom destdir and no export' do
        let(:params) { { destdir: '/srv/nagios', exported: false } }

        it { is_expected.to contain_concat('/srv/nagios/nagios_custom.cfg') }
        it { is_expected.to contain_concat__fragment('type_header_custom').with_target('/srv/nagios/nagios_custom.cfg') }
      end

      context 'with a server_name' do
        let(:params) { { server_name: 'mon1' } }

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
