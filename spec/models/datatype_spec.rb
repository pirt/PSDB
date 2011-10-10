# == Schema Information
#
# Table name: datatypes
#
#  id         :integer(38)     not null, primary key
#  name       :string(30)      not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

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
    it "should have a 'instancevalues' attribute" do
      @datatype = Datatype.create(@attr)
      @datatype.should respond_to(:instancevalues)
    end
    it "cannot be deleted if referenced by instancevalues" do
      @instancevalue=Factory(:instancevalue)
      @datatype=@instancevalue.datatype
      lambda do
         @datatype.destroy
      end.should_not change(Datatype, :count)
    end
  end
  describe "instance method" do
    describe "'to_s'" do
      it "should return the name of the data type" do
        datatype=Datatype.create!(@attr)
        datatype.to_s.should == "numeric"
      end
    end
  end
end

