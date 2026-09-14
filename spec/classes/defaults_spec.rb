# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

describe 'nagios::defaults' do
  debian_data = YAML.safe_load(File.read(File.join(__dir__, '..', '..', 'data', 'os', 'Debian.yaml')))
  skipped_on_debian = debian_data.select { |key, _| key.end_with?('::skip') }.values.flatten

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include nagios' }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_nagios__type__hostgroup('all').with_hostgroup_alias('All Servers').with_members(['*']) }
      it { is_expected.to contain_nagios__type__hostgroup('routers') }
      it { is_expected.to contain_nagios__type__timeperiod('24x7').with_sunday('00:00-24:00').with_saturday('00:00-24:00') }
      it { is_expected.to contain_nagios__type__timeperiod('never').without_monday }
      it { is_expected.to contain_nagios__type__contactgroup('admins').with_members(['root']) }
      it { is_expected.to contain_nagios__type__contact('root').with_email('root@localhost').with_host_notification_commands('notify-host-by-email') }
      it { is_expected.to contain_file('nagios_templates').with_source('puppet:///modules/nagios/nagios_templates.cfg') }

      it { is_expected.to contain_nagios__type__command('check_other_ping') }
      it { is_expected.to contain_nagios__type__command('check_https_cert').with_command_line(%r{--ssl --sni -H \$ARG1\$ -C 5$}) }
      it { is_expected.to contain_nagios__type__command('check_smtp_tls') }
      it { is_expected.to contain_nagios__type__command('check_pop3') }
      it { is_expected.not_to contain_nagios__type__command('check_nrpe_timeout') }

      case os_facts[:os]['family']
      when 'Debian'
        it 'skips the commands shipped by the distribution' do
          skipped_on_debian.reject { |name| name.start_with?('check_nrpe') }.each do |name|
            is_expected.not_to contain_nagios__type__command(name)
          end
        end

        it { is_expected.to contain_nagios__type__command('notify-host-by-email').with_command_line(%r{\| /usr/bin/mail -s}) }
      when 'RedHat'
        it { is_expected.to contain_nagios__type__command('notify-host-by-email').with_command_line(%r{\| /bin/mail -s}) }
      end

      unless os_facts[:os]['family'] == 'Debian'
        it 'declares every command that Debian skips, so the skip lists name real commands' do
          skipped_on_debian.reject { |name| name.start_with?('check_nrpe') }.each do |name|
            is_expected.to contain_nagios__type__command(name)
          end
        end
      end

      context 'with the NRPE command classes' do
        let(:pre_condition) { 'include nagios; include nagios::command::nrpe; include nagios::command::nrpe_timeout; include nagios::command::nrpe_host' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nagios__type__command('check_nrpe_timeout_port').with_command_line('$USER1$/check_nrpe -t $ARG1$ -H $HOSTADDRESS$ -c $ARG2$ -p $ARG3$ -a $ARG4$') }
        it { is_expected.to contain_nagios__type__command('check_nrpe_host_timeout_port').with_command_line('$USER1$/check_nrpe -H $ARG1$ -c $ARG2$ -p $ARG3$ -a $ARG4$ -t $ARG5$') }

        if os_facts[:os]['family'] == 'Debian'
          it { is_expected.not_to contain_nagios__type__command('check_nrpe') }
        else
          it { is_expected.to contain_nagios__type__command('check_nrpe') }
        end
      end
    end
  end
end
