# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::tags' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params('hosts', []).and_return(['nagios_hosts']) }
  it { is_expected.to run.with_params('service', ['mon1']).and_return(['nagios_service_mon1']) }
  it { is_expected.to run.with_params('hosts', ['a', 'b']).and_return(['nagios_hosts_a', 'nagios_hosts_b']) }
  it { is_expected.to run.with_params('hosts', ['']).and_raise_error(ArgumentError) }
end
