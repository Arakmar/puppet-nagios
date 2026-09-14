# frozen_string_literal: true

require 'spec_helper'

describe 'Nagios::Port' do
  it { is_expected.to allow_values(1, 80, 5666, 65_535, '5666', '80') }
  it { is_expected.not_to allow_values(-1, 65_536, 'http', '', nil, 80.5) }
end
