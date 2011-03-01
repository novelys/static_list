require "spec_helper"

class HairColor
  include StaticList::Model
  include StaticList::Validate
  @@hair_color_list = [[:white, 1], [:blond, 2], [:red, 3], [:light_brown, 4], [:brown, 5], [:black, 6], [:colored, 7], [:bald, 8]]
  cattr_accessor :hair_color_list
  
  static_list @@hair_color_list
end

include StaticList::Helpers

describe HairColor do
  describe ".static_list" do
    it "should return the static list array" do
      HairColor.static_list_codes.should == HairColor.hair_color_list
    end
  end
  
  describe ".code_to_sym" do
    it "should return the code from the symbol" do
      HairColor.code_to_sym(3).should == :red
    end
  end
  
  describe ".sym_to_code" do
    it "should return the symbol from the code" do
      HairColor.sym_to_code(:black).should == 6
    end
  end
  
  describe ".all" do
    it "should return all the list" do
      HairColor.all.should have(8).elements
    end
  end
  
  describe ".static_codes" do
    it "should return all the codes" do
      HairColor.static_codes.should == [:white, :blond, :red, :light_brown, :brown, :black, :colored, :bald]
    end
  end
  
  describe ".static_keys" do
    it "should return all the keys" do
      HairColor.static_keys.should == [1, 2, 3, 4, 5, 6, 7, 8]
    end
  end
  
  describe ".t_symbol" do
    it "should return the correct translation key" do
      HairColor.t_key_from_code(3).should == "hair_color.red"
    end
  end
end

describe "StaticList::Helpers" do
  describe ".t_static_list" do
    it "should return the translation" do
      StaticList::Helpers.should_receive(:t).with("hair_color.white")
      
      StaticList::Helpers.t_static_list(1, HairColor)
    end
  end
  
  describe ".static_list_select_options" do
    it "should return a list for a select" do
      StaticList::Helpers.should_receive(:t_static_list).exactly(8).times.and_return("ok")
      
      StaticList::Helpers.static_list_select_options(HairColor).should be_an(Array)
    end
  end
end

describe "StaticList::Validate" do
  describe ".validates_static_list_value" do
    it "should validate inclusion" do
      HairColor.should_receive(:validates_inclusion_of).with(:hair_color_code, { :in => [1, 2, 3, 4, 5, 6, 7, 8] })
      
      HairColor.validates_static_list_value(:hair_color_code, HairColor)
    end
  end
end

