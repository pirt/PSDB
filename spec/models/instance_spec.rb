require 'spec_helper'

describe Instance do
  before(:each) do
    @classtype=Factory(:classtype)
    @subsystem=Factory(:subsystem)
    @attr={:name => "test instance",
           :classtype_id => @classtype.id,
           :subsystem_id => @subsystem.id}
  end
  it "should create an instance given valid attributes" do
    valid_instance=Instance.create!(@attr)
  end
  it "should require a name" do
    no_name_instance=Instance.new(@attr.merge(:name => ""))
    no_name_instance.should_not be_valid
  end
  it "should reject names longer than 255 characters" do
    longname = "a"*256
    longname_instance=Instance.new(@attr.merge(:name => longname))
    longname_instance.should_not be_valid
  end
  describe "association" do
    it "should belong to a classtype" do
      instance=Instance.new(@attr)
      instance.should respond_to(:classtype)
    end
    it "should reference an existing classtype" do
      nonExistingClasstypeId=@classtype.id + 1
      corrupted_instance=Instance.new(@attr.merge(:classtype_id => nonExistingClasstypeId))
      corrupted_instance.should_not be_valid
    end
    it "should belong to a subsystem" do
      instance=Instance.new(@attr)
      instance.should respond_to(:subsystem)
    end
    it "should reference an existing subsystem" do
      nonExistingSubsystemId=@subsystem.id + 1
      corrupted_instance=Instance.new(@attr.merge(:subsystem_id => nonExistingSubsystemId))
      corrupted_instance.should_not be_valid
    end
    it "should have many instancevaluesets" do
      instance=Instance.new(@attr)
      instance.should respond_to(:instancevaluesets)
    end
  end
end
