# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::command::http' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_nagios__type__command('check_http_port_code').with_command_line('$USER1$/check_http -k \'Accept: */*\' --sni -H $ARG1$ -p $ARG2$ -u $ARG3$ -e $ARG4$') }
      it { is_expected.to contain_nagios__type__command('check_https_port_cert').with_command_line('$USER1$/check_http -k \'Accept: */*\' --ssl --sni -H $ARG1$ -p $ARG2$ -C 5') }
      # Plain http checks may follow a redirection to https: SNI is sent everywhere
      it do
        is_expected.to contain_nagios__type__command('check_http_port_url_content')
          .with_command_line('$USER1$/check_http -k \'Accept: */*\' --sni -H $ARG1$ -p $ARG2$ -u $ARG3$ -s $ARG4$ -f $ARG5$')
      end

      context 'with ssl_warning_delay => 30 and skip' do
        let(:params) { { ssl_warning_delay: 30, skip: ['http_port'] } }

        it { is_expected.to contain_nagios__type__command('check_https_cert').with_command_line(%r{ -C 30$}) }
        it { is_expected.not_to contain_nagios__type__command('http_port') }
      end

      context 'with a numeric string delay' do
        let(:params) { { ssl_warning_delay: '10' } }

        it { is_expected.to contain_nagios__type__command('check_https_cert').with_command_line(%r{ -C 10$}) }
      end
    end
  end
end
