# == Schema Information
#
# Table name: instancevaluesets
#
#  id          :integer(38)     not null, primary key
#  shot_id     :integer(38)     not null
#  instance_id :integer(38)     not null
#  version     :integer(38)     not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Instancevalueset do
  before(:each) do
    @shot=Factory(:shot)
    @instance=Factory(:instance)
    @attr={:shot_id => @shot.id,
           :instance_id => @instance.id,
           :version => 1 }
  end
  it "should create instance given valid attributes" do
    valid_valueset=Instancevalueset.new(@attr)
    valid_valueset.should be_valid
  end
  it "should require a version" do
    no_version_valueset=Instancevalueset.new(@attr.merge(:version => nil))
    no_version_valueset.should_not be_valid
  end
  describe "association" do
    it "should belong to a shot" do
      valueset=Instancevalueset.new(@attr)
      valueset.should respond_to(:shot)
    end
    it "should reference an existing shot" do
      nonExistingShotId=@shot.id + 1
      corrupted_valueset=Instancevalueset.new(@attr.merge(:shot_id => nonExistingShotId))
      corrupted_valueset.should_not be_valid
    end
    it "should belong to an instance" do
      valueset=Instancevalueset.new(@attr)
      valueset.should respond_to(:instance)
    end
    it "should reference an existing instance" do
      nonExistingInstanceId=@instance.id + 1
      corrupted_valueset=Instancevalueset.new(@attr.merge(:instance_id => nonExistingInstanceId))
      corrupted_valueset.should_not be_valid
    end
    it "should have instancevalues" do
      valueset=Instancevalueset.new(@attr)
      valueset.should respond_to(:instancevalues)
    end
  end
  describe "method" do
    describe "'generateStringParameter'" do
      it "should return a string parameter of a given instancevalue name"
      it "should return nil if parameter was not found in instancevalues" do
        valueset=Instancevalueset.new(@attr)
        valueset.getStringParameter("testparameter").should eq(nil)
      end
      it "should return nil if parameter was not a string instancevalue" do
        valueset=Instancevalueset.new(@attr)
        instancevalue=Factory(:instancevalue, {:instancevalueset=>valueset})
        valueset.getStringParameter("Test parameter").should eq(nil)
      end
    end
    describe "'generatePlot'" do
      it "should generate a plot"
    end
    describe "'generatePlotSet'" do
      it "should return a set of plot data"
    end
  end
end

