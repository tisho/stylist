require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'stylist'

class DummyController < ApplicationController; def index; render :inline => "<%= render_stylesheets %>"; end; end

# Make sure we're not caching any assets
ActionController::Base.perform_caching = false

describe Stylist::ViewHelpers do
  describe DummyController, :type => :controller do
    before(:all) do
      silence_warnings do
        ActionView::Helpers::AssetTagHelper.send(
          :const_set,
          :STYLESHEETS_DIR,
          File.dirname(__FILE__) + "/../fixtures/public/stylesheets"
        )

        ActionView::Helpers::AssetTagHelper.send(
          :const_set,
          :ASSETS_DIR,
          File.dirname(__FILE__) + "/../fixtures/public"
        )
        
        ActionView::DEFAULT_CONFIG = {
          :assets_dir => File.dirname(__FILE__) + "/../fixtures/public",
          :javascripts_dir => "#{File.dirname(__FILE__) + "/../fixtures/public"}/javascripts",
          :stylesheets_dir => "#{File.dirname(__FILE__) + "/../fixtures/public"}/stylesheets",
        }
      end
    end
  
    describe '#render_stylesheets' do
      before(:each) do
        @collection = Stylist.stylesheets = Stylist::StylesheetCollection.new
      end
    
      context 'when collection is a list of files' do
        it 'should render the <link> tags for each file' do
          @collection << ['base', 'home']
      
          response = ::ActionView::Base.new.render_stylesheets
          response.should have_xpath('//link[starts-with(@href, "/stylesheets/base.css")]')
          response.should have_xpath('//link[starts-with(@href, "/stylesheets/home.css")]')
        end
      end
    
      context 'when collection is a list of expansions' do
        it 'should render the <link> tags for each file in the expansion' do
          ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion :standard => ['base', 'home']
          @collection << :standard
      
          response = ::ActionView::Base.new.render_stylesheets
          response.should have_xpath('//link[starts-with(@href, "/stylesheets/base.css")]')
          response.should have_xpath('//link[starts-with(@href, "/stylesheets/home.css")]')
        end
      end

      context 'when collection is a mix of expansions and filenames' do
        it 'should render the <link> tags for each file and expansion in the collection' do
          ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion :standard => ['base', 'home']
          @collection << [:standard, 'layout', 'typography']
      
          response = ::ActionView::Base.new.render_stylesheets
          response.should have_xpath('//link[starts-with(@href, "/stylesheets/base.css")]')
          response.should have_xpath('//link[starts-with(@href, "/stylesheets/home.css")]')
          response.should have_xpath('//link[starts-with(@href, "/stylesheets/layout.css")]')
          response.should have_xpath('//link[starts-with(@href, "/stylesheets/typography.css")]')
        end
      end
    end
  end
end