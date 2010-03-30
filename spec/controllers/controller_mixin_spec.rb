require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require 'stylist'
class DummyController < ApplicationController; def index; render :nothing => true; end; end
ActionController::Routing::Routes.draw { |map| map.resources :dummy } if rails2?

describe Stylist::ControllerMixin do
  
  describe DummyController, :type => :controller do
    it 'should be included in controllers' do
      get :index
      included_modules = (class << controller; self; end).send :included_modules
      included_modules.should include(Stylist::ControllerMixin)
    end
  
    it 'should be able to manipulate the stylesheet collection using the "css" method' do
      get :index
      controller.css :home
      Stylist.stylesheets.default.should include(:home)
    end
  end
end