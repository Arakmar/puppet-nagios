# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::object' do
  it { is_expected.not_to be_nil }

  it 'renders a Nagios define block' do
    is_expected.to run
      .with_params('command', { 'command_name' => 'x', 'command_line' => 'y z', 'use' => nil })
      .and_return("define command {\n  command_name x\n  command_line y z\n}\n")
  end

  it { is_expected.to run.with_params('host', {}).and_return("define host {\n}\n") }
  it { is_expected.to run.with_params('', {}).and_raise_error(ArgumentError) }
end
