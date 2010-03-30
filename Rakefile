require 'rubygems'
require 'rake'
require File.dirname(__FILE__) + "/lib/stylist/version.rb"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "stylist"
    gem.version = Stylist::VERSION::STRING
    gem.summary = %Q{Powerful stylesheet management for your Rails app.}
    gem.description = %Q{Stylist provides powerful stylesheet management for your Rails app. You can organize your CSS files by media, add, remove or prepend stylesheets in the stylesheets stack from your controllers and views, and process them using Less or Sass. And as if that wasn't awesome enough, you can even minify them using YUI Compressor and bundle them into completely incomprehensible, but bandwidth-friendly mega-stylesheets.}
    gem.email = "tihomir.georgiev@gmail.com"
    gem.homepage = "http://github.com/tisho/stylist"
    gem.authors = ["Tisho Georgiev"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "rails", ">= 2.3"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

namespace :spec do
  desc 'Run RSpec code examples within a Rails 2 environment.'
  task :rails2 do
    RakeFileUtils.verbose(verbose) do
      spec_files = FileList['spec/**/*_spec.rb'].to_a
      lib_path = ['lib', 'spec']
      spec_script = Gem.bin_path('rspec', 'spec', '~> 1.2')
      
      unless spec_files.empty?
        cmd_parts = ['RAILS_VERSION=2', RUBY]
        cmd_parts << '-Ilib'
        cmd_parts << '-Ispec'
        cmd_parts << %["#{spec_script}"]
        cmd_parts += spec_files.collect { |fn| %["#{fn}"] }
        cmd = cmd_parts.join(" ")
        puts cmd if verbose
        unless system(cmd)
          raise("Command #{cmd} failed")
        end
      end    
    end
  end
  
  desc 'Run RSpec code examples within a Rails 3 environment.'
  task :rails3 do
    RAILS_VERSION = 3
    RakeFileUtils.verbose(verbose) do
      spec_files = FileList['spec/**/*_spec.rb'].to_a
      lib_path = ['lib', 'spec']
      
      unless spec_files.empty?
        cmd_parts = ['RAILS_VERSION=3', RUBY]
        cmd_parts << '-Ilib'
        cmd_parts << '-Ispec'
        cmd_parts += spec_files.collect { |fn| %["#{fn}"] }
        cmd = cmd_parts.join(" ")
        puts cmd if verbose
        unless system(cmd)
          raise("Command #{cmd} failed")
        end
      end    
    end
  end
end

desc "Run RSpec code examples first in Rails 2, then in a Rails 3 environment."
task :spec => [:check_dependencies, 'spec:rails2', 'spec:rails3']

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "stylist #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
