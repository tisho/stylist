require 'spec_helper'
require 'stylist/stylesheet_collection'

describe Stylist::StylesheetCollection do
  before(:each) do
    @collection = Stylist::StylesheetCollection.new
  end

  it 'should be able to store stylesheet names' do
    @collection << :standard
    @collection.default.should include(:standard)
  end
  
  it 'should automatically flatten arrays if any are passed as an argument' do
    @collection << [[:standard, [:nested]]]
    @collection.default.should == [:standard, :nested]
  end
  
  it 'should not add nil values if any are passed as an argument' do
    @collection << nil
    @collection.default.should_not include(nil)
  end
  
  it 'should not allow duplicates in stylesheet arrays' do
    @collection << :standard
    @collection << :standard
    @collection.default.should have(1).stylesheet
  end
  
  it 'should be able to chain calls' do
    @collection.append(:standard, :base).prepend(:home).remove(:standard)
    @collection.default.should == [:home, :base]
  end
  
  describe '#append' do
    it 'should add a stylesheet to the end of the array' do
      @collection.push :home, :base
      @collection.append :standard
      @collection.default.last.should == :standard
    end
    
    it 'should add a stylesheet to the specified media array when passed as an argument' do
      @collection.push :home, :base
      @collection.append :standard, :media => :print
      @collection[:print].should == [:standard]
    end
  end
  
  describe '#prepend' do
    it 'should add a stylesheet to the beginning of the array' do
      @collection.push :home, :base
      @collection.prepend :standard
      @collection.default.first.should == :standard
    end
    
    it 'should add a stylesheet to the beginning of the specified media array when passed as an argument' do
      @collection.push :home, :base, :media => :print
      @collection.prepend :standard, :media => :print
      @collection[:print].should == [:standard, :home, :base]
    end
  end
  
  describe '#remove' do 
    it 'should remove a stylesheet from the default collection when invoked without :media argument' do
      @collection.append :home, :base
      @collection.remove :home
      
      @collection.default.should == [:base]
    end
    
    it 'should remove a stylesheet only from the specified media array when passed as an argument' do 
      @collection.append :home, :base, :standard
      @collection.append :standard, :media => :print

      @collection.remove :standard, :media => :print
      @collection.default.should == [:home, :base, :standard]
      @collection[:print].should be_empty
    end
  end
  
  describe '#manipulate' do
    it 'should append stylesheets by default' do
      @collection.manipulate :standard, :home
      @collection.default.should == [:standard, :home]
    end
    
    it 'should append stylesheets if name is a string that starts with a + sign' do
      @collection.manipulate '+standard'
      @collection.default.should == ['standard']
    end

    it 'should append stylesheets if name is a symbol that starts with a + sign' do
      @collection.manipulate :'+standard'
      @collection.default.should == [:standard]
    end
    
    it 'should prepend stylesheets if name is a string that ends with a + sign' do
      @collection.append :base, :home
      @collection.manipulate 'standard+'
      @collection.default.first.should == 'standard'
    end
    
    it 'should prepend stylesheets if name is a symbol that ends with a + sign' do
      @collection.append :base, :home
      @collection.manipulate :'standard+'
      @collection.default.first.should == :standard
    end
    
    it 'should remove stylesheet if name is a string that starts with a - sign' do
      @collection.append 'base', :home
      
      @collection.manipulate '-base'
      @collection.default.should == [:home]
    end
    
    it 'should remove stylesheet if name is a symbol that starts with a - sign' do
      @collection.append :base, :home
      
      @collection.manipulate :'-base'
      @collection.default.should == [:home]
    end
  end
end