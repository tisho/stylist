puts "Setting up a Rails 2 environment..."

RAILS_ROOT = "#{File.dirname(__FILE__)}" unless defined?(RAILS_ROOT)
require 'initializer'
require 'action_controller'
require 'spec'
require 'spec/rails'
require 'webrat/integrations/rspec-rails'