require 'rubygems'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'support'))

RAILS_VERSION = (ENV['RAILS_VERSION'] || 2).to_s unless defined? RAILS_VERSION
if RAILS_VERSION =~ /^3/
  require 'boot_rails3'
else
  require 'boot_rails2'
end

def rails3?; RAILS_VERSION =~ /^3/ end
def rails2?; !rails3?; end

# plugin_root = File.join(File.dirname(__FILE__), '..')
# version = ENV['RAILS_VERSION']
# version = nil if version and version == ""
#  
# # first look for a symlink to a copy of the framework
# if !version and framework_root = ["#{plugin_root}/rails", "#{plugin_root}/../../rails"].find { |p| File.directory? p }
#   puts "found framework root: #{framework_root}"
#   # this allows for a plugin to be tested outside of an app and without Rails gems
#   # $:.unshift "#{framework_root}"
#   $:.unshift "#{framework_root}/activesupport/lib", "#{framework_root}/actionpack/lib", "#{framework_root}/railties/lib"
#   $:.unshift "#{framework_root}/active_support/lib", "#{framework_root}/action_pack/lib", "#{framework_root}/railties/lib"
# else
#   # simply use installed gems if available
#   puts "using Rails#{version ? ' ' + version : nil} gems"
#   require 'rubygems'
#   
#   if version
#     gem 'rails', version
#   else
#     gem 'actionpack'
#   end
# end
