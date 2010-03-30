require 'less' unless defined?(::Less)

module Stylist
  module Processors
    class LessProcessor < Processor
      class << self
        def configure
          configuration.add_option_group :less, { :source_path => ::Rails.root.join('app/stylesheets'), :compress => true }
        end
        
        def process!(collection)
          stylesheets_to_process(collection).each do |stylesheet|
            source_path = source_path_for(stylesheet)
            
            if source_path && source_path.exist?
              engine = File.open(source_path) {|f| ::Less::Engine.new(f) }
              css = engine.to_css
              css.delete!("\n") if configuration.less.compress
              File.open(stylesheet, "w") { |f| f.puts css }
            end
          end
        end
        
        def source_path_for(file)
          Pathname.glob(File.join(configuration.less.source_path, File.basename(file, '.css')+'.{css,less,lss}'))[0]
        end

        def stylesheets_to_process(collection)
          expand_stylesheet_sources(collection.values.flatten).select do |file|
            (File.exists?(file) and source_has_been_changed?(file)) or not File.exists?(file)
          end
        end

        def source_has_been_changed?(file)
          source_path = source_path_for(file)
          source_path && (File.new(source_path).mtime >= File.new(file).mtime)
        end
      end
      
    end
  end
end