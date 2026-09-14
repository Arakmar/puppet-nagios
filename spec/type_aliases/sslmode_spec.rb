# frozen_string_literal: true

require 'spec_helper'

describe 'Nagios::SslMode' do
  it { is_expected.to allow_values(true, false, 'force', 'only') }
  it { is_expected.not_to allow_values('true', 'yes', 'http', 1, nil, ['only']) }
end
