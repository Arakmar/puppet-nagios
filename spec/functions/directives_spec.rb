# frozen_string_literal: true

require 'spec_helper'

describe 'nagios::directives' do
  it { is_expected.not_to be_nil }

  it 'drops undef values and empty arrays, joins arrays, maps booleans and stringifies the rest' do
    is_expected.to run
      .with_params({ 'a' => nil, 'b' => [], 'c' => ['x', 'y'], 'd' => true, 'e' => false, 'f' => 0, 'g' => 'str', 'h' => 2.5 })
      .and_return({ 'c' => 'x,y', 'd' => '1', 'e' => '0', 'f' => '0', 'g' => 'str', 'h' => '2.5' })
  end

  it 'preserves insertion order' do
    expect(call_function('nagios::directives', { 'z' => 1, 'a' => 2 }).keys).to eq(['z', 'a'])
  end

  it { is_expected.to run.with_params({}).and_return({}) }
  it { is_expected.to run.with_params('nope').and_raise_error(ArgumentError) }
end
