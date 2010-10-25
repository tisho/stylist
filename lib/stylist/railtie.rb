module Stylist
  class Railtie < Rails::Railtie
    initializer :configure_stylist_defaults, :before => :load_application_initializers do |app|
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
  end
end