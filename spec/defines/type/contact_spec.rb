# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::type::contact' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'ops' }

      fqdn = os_facts[:networking]['fqdn']

      it { is_expected.to compile.with_all_deps }

      it 'declares a contact with defaults' do
        is_expected.to contain_concat__fragment("nagios_contact_ops_#{fqdn}")
          .with_target(%r{/conf\.d/nagios_contact\.cfg$})
          .with_tag('nagios_contact')
          .with_content("define contact {\n  contact_name ops\n  use generic-contact\n  email root@localhost\n}\n")
      end

      context 'with notification settings' do
        let(:params) do
          {
            contact_alias: 'Operations',
            service_notification_commands: ['notify-service-by-email', 'notify-service-by-sms'],
            host_notification_commands: 'notify-host-by-email',
            host_notification_options: 'd,r',
            email: 'ops@example.org',
            register: '1',
          }
        end

        it 'renders them' do
          is_expected.to contain_concat__fragment("nagios_contact_ops_#{fqdn}")
            .with_content(%r{^  alias Operations$})
            .with_content(%r{^  service_notification_commands notify-service-by-email,notify-service-by-sms$})
            .with_content(%r{^  host_notification_commands notify-host-by-email$})
            .with_content(%r{^  email ops@example\.org$})
            .with_content(%r{^  register 1$})
        end
      end
    end
  end
end
