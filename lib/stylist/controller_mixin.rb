module Stylist
  module ControllerMixin
    
    def self.included(base)
      base.class_eval do
        include       InstanceMethods
        before_filter { Stylist.stylesheets.reset! }
    	  helper_method :css
      end
    end
    
    module InstanceMethods
      def css(*args)
        Stylist.stylesheets.manipulate *args
      end
    end
    
  end
end