# == Schema Information
#
# Table name: subsystems
#
#  id         :integer(38)     not null, primary key
#  name       :string(255)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Subsystem do
  before(:each) do
    @attr = { :name => "test system" }
  end
  it "should create a new instance given valid attributes" do
    Subsystem.create!(@attr)
  end
  it "should require a name" do
    no_name_subsystem = Subsystem.new(@attr.merge(:name => ""))
    no_name_subsystem.should_not be_valid
  end
  it "should have a unique (case insensitive) name" do
    Subsystem.create!(@attr)
    duplicate_name_subsystem = Subsystem.new(@attr.merge(:name => "Test System"))
    duplicate_name_subsystem.should_not be_valid
  end
  it "should reject name longer than 255 characters" do
    longname = "a" * 256
    longname_subsystem=Subsystem.new(@attr.merge(:name => longname))
    longname_subsystem.should_not be_valid
  end
  describe "association" do
    before(:each) do
      @subsystem = Subsystem.create(@attr)
    end
    it "should have a 'instances' attribute" do
      @subsystem.should respond_to(:instances)
    end
    it "cannot be deleted if referenced by instance" do
      @instance=Factory(:instance)
      @subsystem=@instance.subsystem
      lambda do
         @subsystem.destroy
      end.should_not change(Subsystem, :count)
    end
  end
  describe "instance method" do
    describe "'to_s'" do
      it "should return the name of the subsystem" do
        subsystem=Subsystem.create!(@attr)
        subsystem.to_s.should == "test system"
      end
    end
  end
end

