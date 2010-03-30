module Stylist
  class StylesheetCollection
    attr_reader :collection

    def configuration; ::Stylist.configuration; end
    
    def initialize
      reset!
    end

    def reset!
      @collection = ::ActiveSupport::OrderedHash.new { |h, k| h[k] = [] }
    end
    
    def default
      @collection[configuration.default_media]
    end
  
    def append(*args)
      options = args.extract_options!.symbolize_keys!
      media = options.delete(:media) || configuration.default_media
    
      @collection[media] |= args.flatten.compact
      self
    end

    alias_method :<<, :append
    alias_method :push, :append
  
    def prepend(*args)
      options = args.extract_options!.symbolize_keys!
      media = options.delete(:media) || configuration.default_media
    
      @collection[media] = args.flatten.compact | @collection[media]
      self
    end
  
    def remove(*args)
      options = args.extract_options!.symbolize_keys!
      media = options.delete(:media) || configuration.default_media
    
      @collection[media] -= args
      self
    end
  
    def manipulate(*args)
      return self if args.empty?
      
      options = args.extract_options!.symbolize_keys!
      media = options.delete(:media) || configuration.default_media
    
      args.flatten.compact.each do |stylesheet|
        name_as_string = stylesheet.to_s.clone
        stylesheet = filtered_stylesheet_name(stylesheet)
      
        case
          when name_as_string.starts_with?('+')
            append(stylesheet, :media => media)
          when name_as_string.ends_with?('+')
            prepend(stylesheet, :media => media)
          when name_as_string.starts_with?('-')
            remove(stylesheet, :media => media)
          else
            append(stylesheet, :media => media)
        end
      end
    
      self
    end
  
    def filtered_stylesheet_name(stylesheet)
      name = stylesheet.to_s
      name.gsub!(/^[+-]*/, '').gsub!(/[+-]*$/, '')
    
      return stylesheet.is_a?(Symbol) ? name.to_sym : name
    end
  
    def process!
      configuration.processors.each { |processor| processor.process!(@collection) }
    end
  
    # by default, route missing methods to the collection hash
    # otherwise hit the :all array
    def method_missing(name, *args, &block)
      if @collection.respond_to? name
        @collection.send(name, *args, &block)
      else
        @collection[:all].send(name, *args, &block)
      end
    end
  end
end