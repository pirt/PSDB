require 'spec_helper'

describe Classtype do
  before(:each) do
    @attr = { :name => "test class"}
  end
  it "should create a new instance given valid attributes" do
    Classtype.create!(@attr)
  end
  it "should require a name" do
    no_name_classtype = Classtype.new(@attr.merge(:name => ""))
    no_name_classtype.should_not be_valid
  end
  it "should reject name longer than 255 characters" do
    longname = "a" * 256
    longname_classtype=Classtype.new(@attr.merge(:name => longname))
    longname_classtype.should_not be_valid
  end
  describe "association" do
    before(:each) do
      @classtype = Classtype.create(@attr)
    end
    it "should have a 'instances' attribute" do
      @classtype.should respond_to(:instances)
    end
    it "cannot be deleted if referenced by instance" do
      @instance=Factory(:instance)
      @classtype=@instance.classtype
      lambda do
         @classtype.destroy
      end.should_not change(Classtype, :count)
    end
  end
end
