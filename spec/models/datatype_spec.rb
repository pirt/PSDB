require 'spec_helper'

describe Datatype do
  before(:each) do
    @attr = { :name => "numeric" }
  end
  it "should create a new instance given valid attributes" do
    Datatype.create!(@attr)
  end
  it "should require a name" do
    no_name_datatype = Datatype.new(@attr.merge(:name => ""))
    no_name_datatype.should_not be_valid
  end
  it "should have a unique (case insensitive) name" do
    Datatype.create!(@attr)
    duplicate_name_datatype = Datatype.new(@attr.merge(:name => "Numeric"))
    duplicate_name_datatype.should_not be_valid
  end
  it "should reject name longer than 30 characters" do
    longname = "a" * 31
    longname_datatype=Datatype.new(@attr.merge(:name => longname))
    longname_datatype.should_not be_valid
  end
  describe "association" do
    before(:each) do
      @datatype = Datatype.create(@attr)
    end
    it "should have a 'instancedatas' attribute" do
      @datatype.should respond_to(:instancedatas)
    end
    it "cannot be deleted if referenced by shots"
  end
end
