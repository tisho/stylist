module Stylist
  module Processors
    class YuiCompressorProcessor < Processor
      class MinificationCommandFailed < StandardError; end
        
      class << self
        def configure
          configuration.add_option_group :yui_compressor, { :path_to_jar => nil, :path_to_java => 'java', :charset => 'utf-8', :line_break => nil, :production_only => true }
        end
        
        def process!(collection)
          return if configuration.yui_compressor.production_only and not Rails.env.production?
          
          stylesheets_to_process(collection).each do |stylesheet|
            minify(stylesheet)
          end
          replace_files_in_collection_with_minified_files(collection)
        end
        
        def replace_files_in_collection_with_minified_files(collection)
          collection.each_pair do |media, stylesheets|
            collection[media] = expand_stylesheet_sources(stylesheets).map { |stylesheet| minified_stylesheet_name_for(stylesheet).basename.to_s }
          end
        end
        
        def minify(stylesheet)
          config = configuration.yui_compressor
          command = [config.path_to_java, '-jar', config.path_to_jar, '-o', minified_stylesheet_name_for(stylesheet), *command_options] << stylesheet
          unless system(*command) 
            raise MinificationCommandFailed, "Oops! Minification command failed with error code: #{$?}. The command executed was: #{command.join ' '}"
          end
        end
        
        def command_options
          config = configuration.yui_compressor
          { :type => 'css', :charset => config.charset, :line_break => nil }.inject([]) do |options, (name, argument)|
            options.concat(["--#{name.to_s.gsub '_', '-'}", argument.to_s]) if argument
            options
          end
        end
        
        def minified_stylesheet_name_for(stylesheet)
          dir, filename = stylesheet.split
          dir.join([filename.basename(filename.extname), '.min', filename.extname].join)
        end
        
        def stylesheets_to_process(collection)
          expand_stylesheet_sources(collection.values.flatten).select do |source_file|
            minified_file = minified_stylesheet_name_for(source_file)
            (minified_file.exist? and source_has_been_changed?(source_file)) or (source_file.exist? and not minified_file.exist?)
          end
        end

        def source_has_been_changed?(file)
          minified_path = minified_stylesheet_name_for(file)
          minified_path.exist? && (File.new(file).mtime >= File.new(minified_path).mtime)
        end        
      end
    
    end
  end
end