# frozen_string_literal: true

require 'spec_helper'

describe 'Nagios::Interval' do
  it { is_expected.to allow_values(0, 5, 60, 2.5, '5', '0', '2.5') }
  it { is_expected.not_to allow_values('-1', '5s', 'five', '', nil, [5]) }
end
