require 'spec_helper'
require 'stylist'

describe Stylist::Configuration do
  before(:each) do
    @configuration = ::Stylist::Configuration.new
  end
  
  context '#add_configuration_options_for' do
    it 'should create a new group in the configuration with options passed as a hash' do
      @configuration.add_option_group :some_group, { :test_option => 'test', :second_option => 'second' }
      @configuration.some_group.test_option.should == 'test'
      @configuration.some_group.second_option.should == 'second'
    end
  end
end