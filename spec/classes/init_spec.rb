require 'spec_helper'
describe 'jruby' do
  context 'with default values for all parameters' do
    it { should contain_class('jruby') }
  end
end
