require 'spec_helper'

describe Instancedata do
  before(:each) do
    @shot=Factory(:shot)
    @datatype=Factory(:datatype)
    @instance=Factory(:instance)
    @attr={:name => "test parameter",
           :shot_id => @shot.id,
           :datatype_id => @datatype.id,
           :instance_id => @instance.id,
           :data_numeric => 1234 }
  end
  it "should create an instance given valid attributes" do
    valid_instancedata=Instancedata.new(@attr)
    valid_instancedata.should be_valid
  end
  it "should require a name" do
    no_name_instancedata=Instancedata.new(@attr.merge(:name => ""))
    no_name_instancedata.should_not be_valid
  end
  it "should reject names longer than 255 characters" do
    longname = "a"*256
    longname_instancedata=Instancedata.new(@attr.merge(:name => longname))
    longname_instancedata.should_not be_valid
  end
  describe "data field conditions" do
    it "should reject if no data field set" do
      nodata_instancedata=Instancedata.new(@attr.merge(:data_numeric => nil))
      nodata_instancedata.should_not be_valid
    end
    it "should accept instances with numeric data" do
      numeric_instancedata=Instancedata.new(@attr.merge(:data_numeric => 1234))
      numeric_instancedata.should be_valid
    end
    it "should accept instances with string data" do
      string_instancedata=Instancedata.new(@attr.merge(:data_string => "test"))
      string_instancedata.should be_valid
    end
    it "should accept instances with binary data" do
      binary_instancedata=Instancedata.new(@attr.merge(:data_binary => "binary data"))
      binary_instancedata.should be_valid
    end
  end
  describe "association" do
    it "should belong to a shot" do
      instancedata=Instancedata.new(@attr)
      instancedata.should respond_to(:shot)
    end
    it "should reference an existing shot" do
      nonExistingShotId=@shot.id + 1
      corrupted_instancedata=Instancedata.new(@attr.merge(:shot_id => nonExistingShotId))
      corrupted_instancedata.should_not be_valid
    end
    it "should belong to a datatype" do
      instancedata=Instancedata.new(@attr)
      instancedata.should respond_to(:datatype)
    end
    it "should reference an existing datatype" do
      nonExistingDatatypeId=@shot.id + 1
      corrupted_instancedata=Instancedata.new(@attr.merge(:datatype_id => nonExistingDatatypeId))
      corrupted_instancedata.should_not be_valid
    end
    it "should belong to an instance" do
      instancedata=Instancedata.new(@attr)
      instancedata.should respond_to(:instance)
    end
    it "should reference an existing instance" do
      nonExistingInstanceId=@instance.id + 1
      corrupted_instancedata=Instancedata.new(@attr.merge(:instance_id => nonExistingInstanceId))
      corrupted_instancedata.should_not be_valid
    end
  end
end
