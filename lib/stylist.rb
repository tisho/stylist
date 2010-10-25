require 'stylist/version'
require 'stylist/configuration'
require 'stylist/processor'
require 'stylist/stylesheet_collection'
require 'stylist/controller_mixin'
require 'stylist/view_helpers'
require 'stylist/railtie' if defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3

module Stylist
  class << self
    attr_accessor :stylesheets
    
    def setup!
      self.configuration = Configuration.new
      self.stylesheets = StylesheetCollection.new
    end
  end
end


if defined? ::ActionController && defined? ::ActionView
  ::ActionController::Base.send :include, ::Stylist::ControllerMixin
  ::ActionView::Base.send :include, ::Stylist::ViewHelpers
end

if defined?(::Rails) && ::Rails::VERSION::MAJOR == 2
  ::Stylist.setup!
  
  if defined? ::Haml
    require 'stylist/processors/sass_processor'
    ::Stylist.configure { |config| config.process_with :sass }
  end

  if defined? ::Less
    require 'stylist/processors/less_processor'
    ::Stylist.configure { |config| config.process_with :less }
  end
end