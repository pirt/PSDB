require 'spec_helper'

describe Shottype do
  before(:each) do
    @attr = { :name => "experiment shot" }
  end

  it "should create a new instance given valid attributes" do
    Shottype.create!(@attr)
  end
  it "should require a name" do
    no_name_shottype = Shottype.new(@attr.merge(:name => ""))
    no_name_shottype.should_not be_valid
  end
  it "should have a unique (case insensitive) name" do
    Shottype.create!(@attr)
    duplicate_name_shottype = Shottype.new(@attr.merge(:name => "Experiment Shot"))
    duplicate_name_shottype.should_not be_valid
  end
  it "should reject name longer than 30 characters" do
    longname = "a" * 31
    longname_shottype=Shottype.new(@attr.merge(:name => longname))
    longname_shottype.should_not be_valid
  end
  describe "association" do
    before(:each) do
      @shottype = Shottype.create(@attr)
    end
    it "should have a 'shots' attribute" do
      @shottype.should respond_to(:shots)
    end
    it "cannot be deleted if referenced by shots" do
      @shot=Factory(:shot)
      @shotttype=@shot.shottype
      lambda do
         @shottype.destroy
      end.should_not change(Shottype, :count)
    end
  end
end
