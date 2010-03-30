module Stylist
  module Processors
    class Processor
      
      class << self
        def configuration; Stylist.configuration; end
        
        def process!(collection)
          # Provide your own implementation
        end
        
        def expand_stylesheet_sources(*sources)
          expansions = defined?(ActionView::Helpers::AssetTagHelper) ? ActionView::Helpers::AssetTagHelper.send(:class_variable_get, :@@stylesheet_expansions) : {}

          sources.flatten.collect do |source|
            case source
            when Symbol
              expansions[source] || raise(ArgumentError, "No expansion found for #{source.inspect}")
            else
              source
            end
          end.flatten.collect do |source|
            source_ext = File.extname(source)[1..-1]
            if (source_ext.blank? || ('css' != source_ext))
              source += ".css"
            end

            Rails.root.join(configuration.public_stylesheets_path, source)
          end
        end
      end
      
    end
  end
end