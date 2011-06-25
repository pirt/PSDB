require 'spec_helper'

describe Instancevalue do
  before(:each) do
    @datatype=Factory(:datatype)
    @instancevalueset=Factory(:instancevalueset)
    @attr={:name => "test parameter",
           :instancevalueset_id => @instancevalueset.id,
           :datatype_id => @datatype.id,
           :data_numeric => 1234 }
  end
  it "should create an instance given valid attributes" do
    valid_instancedata=Instancevalue.new(@attr)
    valid_instancedata.should be_valid
  end
  it "should require a name" do
    no_name_instancedata=Instancevalue.new(@attr.merge(:name => ""))
    no_name_instancedata.should_not be_valid
  end
  it "should reject names longer than 255 characters" do
    longname = "a"*256
    longname_instancedata=Instancevalue.new(@attr.merge(:name => longname))
    longname_instancedata.should_not be_valid
  end
  describe "data field conditions" do
    it "should reject if no data field set" do
      nodata_instancedata=Instancevalue.new(@attr.merge(:data_numeric => nil))
      nodata_instancedata.should_not be_valid
    end
    it "should accept instances with numeric data" do
      numeric_instancedata=Instancevalue.new(@attr.merge(:data_numeric => 1234))
      numeric_instancedata.should be_valid
    end
    it "should accept instances with string data" do
      string_instancedata=Instancevalue.new(@attr.merge(:data_string => "test"))
      string_instancedata.should be_valid
    end
    it "should accept instances with binary data" do
      binary_instancedata=Instancevalue.new(@attr.merge(:data_binary => "binary data"))
      binary_instancedata.should be_valid
    end
  end
  describe "association" do
    it "should belong to an instancevalueset" do
      instancedata=Instancevalue.new(@attr)
      instancedata.should respond_to(:instancevalueset)
    end
    it "should reference an existing instancevalueset" do
      nonExistingValueSetId=@instancevalueset.id + 1
      corrupted_instancedata=Instancevalue.new(@attr.merge(:instancevalueset_id => nonExistingValueSetId))
      corrupted_instancedata.should_not be_valid
    end
    it "should belong to a datatype" do
      instancedata=Instancevalue.new(@attr)
      instancedata.should respond_to(:datatype)
    end
    it "should reference an existing datatype" do
      nonExistingDatatypeId=@datatype.id + 1
      corrupted_instancedata=Instancevalue.new(@attr.merge(:datatype_id => nonExistingDatatypeId))
      corrupted_instancedata.should_not be_valid
    end
  end
end
