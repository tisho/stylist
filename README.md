Stylist
=======


	 ____    __             ___                 __         
	/\  _`\ /\ \__         /\_ \    __         /\ \        
	\ \,\L\_\ \ ,_\  __  __\//\ \  /\_\    ____\ \ \___    
	 \/_\__ \\ \ \/ /\ \/\ \ \ \ \ \/\ \  /',__\\ \  _ `\  
	   /\ \L\ \ \ \_\ \ \_\ \ \_\ \_\ \ \/\__, `\\ \ \ \ \ 
	   \ `\____\ \__\\/`____ \/\____\\ \_\/\____/ \ \_\ \_\
	    \/_____/\/__/ `/___/> \/____/ \/_/\/___/   \/_/\/_/
	                     /\___/                            
	                     \/__/


_Stylist_ provides powerful stylesheet management for your Rails app. You can organize your .css files by media, add, remove or prepend stylesheets in the stylesheets stack from your controllers and views, and process them using [Less](http://lesscss.org) or [Sass](http://sass-lang.com/). And as if that wasn't awesome enough, you can even minify them using [YUI Compressor](http://developer.yahoo.com/yui/compressor) and bundle them into completely incomprehensible, but bandwidth-friendly mega-stylesheets.

Install
=======

Rails 2.x
-------

Put this in your `environment.rb` file:

	config.gem 'stylist'
	
That's it. `rake gems:install` and you're done.

Rails 3
-------

Add this to your `Gemfile`:

	gem 'stylist'

That's it. `bundle install` and you're good to go.

How It Works
=======

The inner-workings of Stylist are actually pretty simple. Stylist keeps track of stylesheets you intend to use on a given page by storing them in a `Hash` with media types as keys. When you call `render_stylesheets` in your views, it processes all stylesheets in the hash and passes the resulting file paths to Rails's `stylesheet_link_tag`. It takes advantage of Rails's asset caching features by bundling the stylesheets in files with names like `all-[unique hash of collection].css`.

Usage
=======

In order to use Stylist, you have to add this to the part of your layout file(s) responsible for `<link>` tag generation (where your `stylesheet_link_tag` used to be):

	views/layouts/application.html.haml
	-----------------------------------
	
	%html
		%head
			%title My Awesome App
			- css :base
			= render_stylesheets
		%body	
			= yield

This will make sure that the stylesheets stack always has the `:base` stylesheet expansion group loaded before everything else and will then render the necessary `<link>` tags. The above example is using [Haml](http://haml-lang.com), but fear not if you're using regular ERB templates. Just write `<%= render_stylesheets %>`, instead of `= render_stylesheets` and `<% css :base %>`, instead of `- css :base`.

After you've done that, you can start manipulating the stylesheet stack from whatever view and/or controller you like.

The `css` Helper
-------

The `css` helper is used to manipulate the current stylesheet stack. You can use it in both controllers and views.

Examples
------

These can be written either in your views inside `<% %>` tags, or directly in your controller actions or filters. Every method accepts a `:media => :type` argument to specify what stylesheet stack should be manipulated. When omitted, the default media stack is used.

* `css 'list_view', 'foo_details'`
	Adds `list_view.css` and `foo_details.css` to the stack.
	
* `css.remove('grid').prepend('grid_iphone').append('mobile')` 	
	Removes `grid.css`, prepends `grid_iphone.css` to the front of the stack and then appends `mobile.css` to the end.
		
* `css '-grid', 'grid_iphone+', 'mobile'`
	The short, ninja version of the above example.
		
* `css :print, :media => :print`
	Adds the stylesheets, registered in the `:print` stylesheet expansion group, to the print media stack.

Working with Less/Sass
-------

If you've used the special route/controller approach up til now, you can safely get rid of it. Stylist will automatically find any files in the stack that have `.less` or `.sass` sources, "compile" and cache them. If you decide to update the source files, just reload the page. Stylist will detect if you've made any changes to the original files and re-compile them.

Working with the YUI Compressor
-------

It's important to note that `:yui_compressor` should be _the last processor_ that your files should go through. That's because for every file it minifies, YUI Compressor generates a corresponding `filename-min.css` and then replaces the path in the original collection with the minified one. This is done to make sure you never overwrite your original files with minified ones. It also means that you probably don't want to have anything `-min.css` in your public stylesheets dir.

Configuration
=======

You can provide additional configuration options to _Stylist_ by using its `Stylist.configure` method. Say you want to process your stylesheets with _Less_. Put this in `config/initializers/stylist.rb`:

	Stylist.configure do |config|
		config.process_with :less
	end

Global Configuration Options
------

`process_with`
-----

Accepts an array of processors that each file will pass through before being linked on the page. Currently, _Stylist_ has support for _Less_, _Sass_ and _YUI Compressor_ built in. In order to use them, pass either `:less`, `:sass`, `:yui_compressor` or a combination of them to `process_with`. For example, if you want to have your stylesheets processes with _Sass_, and then minified with _YUI Compressor_, you'd have the following config block:

	Stylist.configure do |config|
		config.process_with :sass, :yui_compressor
	end

Additionally, you can pass your own processor classes to `process_with`. Just make sure they respond to a `process!` method. More on this later.	

`default_media`
-----

This is where your stylesheets will end up when you don't specify which media type they should respond to. Defaults to `:all`

`public_stylesheets_path`
-----

This one is pretty self-explanatory. It's a `Pathname` instance that defaults to `your_app/public/stylesheets`.

Less-Specific Configuration Options
------

`less.source_path`
-----

This is where all your `.lss` or `.less` source files reside. Defaults to `your_app/app/stylesheets`.

`less.compress`
-----

When this options is set to `true`, the _Less_ processor will automatically strip all newlines in the resulting CSS file. On by default.

Sass-Specific Configuration Options
------

`sass.source_path`
-----

This is where all your `.sass` source files reside. Defaults to `your_app/app/stylesheets`.

`sass.compress`
-----

When this options is set to `true`, the _Sass_ processor will automatically strip all newlines in the resulting CSS file. On by default.

YUICompressor-Specific Configuration Options
------

`yui_compressor.path_to_jar`
-----

The path to your `yuicompressor-x.x.x.jar` file. Doesn't default to anything, so make sure you set it if you want to use the compressor.

`yui_compressor.path_to_java`
-----

The path to your `java` executable. Defaults to just `java` and expects to pick it up from your environment, but it's not anywhere in your `$PATH`, make sure you set this option.

`yui_compressor.charset`
-----

The character set used to read the stylesheet files. Defaults to `utf-8`.

`yui_compressor.line_break`
-----

The number of characters after which YUI Compressor will try to put a line break. Equivalent to the `--line-break` option when running YUI Compressor from the command line. `nil` by default (so no line breaks).

`yui_compressor.production_only`
-----

When set to `true` the _YUI Compressor_ processor will only attempt to minify a collection of CSS files when your app is running in a production environment. On by default.

Rolling Your Own Processor
=======

The basics (`lib/stylist/rainbows_and_unicorns_processor.rb`):

	module Stylist
		module Processors
		
			class RainbowsAndUnicornsProcessor < Processor
				class << self
				
					# This method will be called automatically when you add your processor
					# to the config.process_with array. It has access to the Stylist configuration
					# object called 'configuration'.
					
					def configure
						configuration.add_option_group :rainbows_and_unicorns, { :unicorns => true, :rainbows => true }
					end
					
					# Called from 'render_stylesheets'. Passes the collection hash as an argument.
					
					def	process!(collection)
						# TODO: Add unicorns and rainbows in every stylesheet
						# ...
					end
					
				end
			end
			
		end
	end

Then in your `initializers/stylist.rb`:

	Stylist.configure do |config|
		config.process_with :rainbows_and_unicorns
		config.rainbows_and_unicorns.rainbows = false
	end
	
If you choose to not make `RainbowsAndUnicornsProcessor` part of `Stylist::Processors`, make sure you pass it to `config.process_with` as a class, instead of a symbol. Stylist will automatically try to expand symbols and strings to `Stylist::Processors::SomeStringProcessor`.

The base `Stylist::Processors::Processor` class also lets you use an `expand_stylesheet_sources(*sources)` method that you can use to explode stylesheet expansions into a series of filepaths.

If you choose to create your own processor, I strongly advise you to look at one of the built-in ones for reference.

Credits
=======

Stylist was extracted with little modification from the loving embrace of the [TransFS](http://transfs.com) codebase, which to this day helps businesses quickly and easily compare the best credit card processors. For more open-source love from [TFS](htp://transfs.com), please take a look at [AppConfig](http://github.com/tisho/app_config) and [FunnelCake](http://github.com/jkrall/funnel_cake).

License
=======

Copyright (c) 2010 Tisho Georgiev, released under the MIT license
