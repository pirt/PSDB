# == Schema Information
#
# Table name: instances
#
#  id           :integer(38)     not null, primary key
#  classtype_id :integer(38)     not null
#  subsystem_id :integer(38)     not null
#  name         :string(255)     not null
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

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
  describe "instance method" do
    it "should have 'viewExists?'"
    describe "'interfaceVersionInfo'" do
      it "should return empty array for 'naked' instance" do
        instance=Instance.new(@attr)
        instance.interfaceVersionInfo.length.should eq(0)
      end
      it "should return version info for refering instancevaluesets" do
        instance=Instance.new(@attr)
        experiment=Factory(:experiment)
        shotType=Factory(:shottype)
        shot1=Factory(:shot,{:experiment=>experiment,:shottype=>shotType})
        shot2=Factory(:shot,{:experiment=>experiment,:shottype=>shotType})
        Factory(:instancevalueset,{:instance=>instance, :shot=>shot1, :version=>1})
        Factory(:instancevalueset,{:instance=>instance, :shot=>shot2, :version=>2})
        instance.interfaceVersionInfo.length.should eq(2)
        instance.interfaceVersionInfo[0][:version].should eq(1)
        instance.interfaceVersionInfo[0][:shot_id].should eq(shot1.id)
        instance.interfaceVersionInfo[0][:shotDate].should eq(Shot.find(shot1.id).created_at)
        instance.interfaceVersionInfo[1][:version].should eq(2)
        instance.interfaceVersionInfo[1][:shot_id].should eq(shot2.id)
        instance.interfaceVersionInfo[1][:shotDate].should eq(Shot.find(shot2.id).created_at)
      end
      it "should return only one version item for refering instancevaluesets with same API version" do
        instance=Instance.new(@attr)
        experiment=Factory(:experiment)
        shotType=Factory(:shottype)
        shot1=Factory(:shot,{:experiment=>experiment,:shottype=>shotType})
        shot2=Factory(:shot,{:experiment=>experiment,:shottype=>shotType})
        Factory(:instancevalueset,{:instance=>instance, :shot=>shot1, :version=>4})
        Factory(:instancevalueset,{:instance=>instance, :shot=>shot2, :version=>4})
        instance.interfaceVersionInfo.length.should eq(1)
      end
    end
  end
end

