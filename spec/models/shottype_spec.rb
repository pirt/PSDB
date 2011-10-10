# == Schema Information
#
# Table name: shottypes
#
#  id         :integer(38)     not null, primary key
#  name       :string(30)      not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Shottype do
  before(:each) do
    @attr = { :name => "test shot" }
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
    duplicate_name_shottype = Shottype.new(@attr.merge(:name => "Test Shot"))
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
      @shottype=@shot.shottype
      lambda do
         @shottype.destroy
      end.should_not change(Shottype, :count)
    end
  end
  describe "instance method" do
    describe "'to_s'" do
      it "should return the name of the shot type" do
        shottype=Shottype.create!(@attr)
        shottype.to_s.should == "test shot"
      end
    end
  end
end

