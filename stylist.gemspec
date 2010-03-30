# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stylist}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tisho Georgiev"]
  s.date = %q{2010-03-30}
  s.description = %q{Stylist provides powerful stylesheet management for your Rails app. You can organize your CSS files by media, add, remove or prepend stylesheets in the stylesheets stack from your controllers and views, and process them using Less or Sass. And as if that wasn't awesome enough, you can even minify them using YUI Compressor and bundle them into completely incomprehensible, but bandwidth-friendly mega-stylesheets.}
  s.email = %q{tihomir.georgiev@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.homepage = %q{http://github.com/tisho/stylist}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Powerful stylesheet management for your Rails app.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<rails>, [">= 2.3"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<rails>, [">= 2.3"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<rails>, [">= 2.3"])
  end
end
