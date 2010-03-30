module Stylist
  class << self
    attr_accessor :configuration
  end
  
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
  
  class Configuration
    attr_reader :processors
    attr_accessor :public_stylesheets_path, :default_media

    def initialize
      @default_media = :all
      @processors = []
      @public_stylesheets_path = "#{defined?(Rails.public_path) ? Rails.public_path : 'public'}/stylesheets"
    end
    
    def metaclass
      class << self; self; end
    end
    
    def add_option_group(group_name, options={})
      group = instance_variable_set "@#{group_name}", Configuration.new
      metaclass.class_eval <<-EOC
        attr_reader :#{group_name}
      EOC
      
      options.each_pair { |key, value| group.add_option(key, value) }
    end
    
    def add_option(key, default_value=nil)
      metaclass.class_eval <<-EOC
        attr_accessor :#{key}
      EOC
      
      instance_variable_set "@#{key}", default_value
    end
    
    def process_with(*processors)
      @processors = processors.collect do |processor|
        if processor.is_a? Class
          processor_class = processor
        else
          class_name = processor.to_s.strip.camelize.sub(/(Processor)?$/, 'Processor')
          processor_class = class_name.constantize rescue "::Stylist::Processors::#{class_name}".constantize
        end
      end.compact
      
      @processors.each { |processor| processor.configure if processor.respond_to?(:configure) }
    end
    
  end
end