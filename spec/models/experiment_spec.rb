require 'spec_helper'

describe Experiment do

  before(:each) do
    @attr = { :name => "P0038", :description => "Experiment description" }
  end

  it "should require a name" do
    no_name_experiment = Experiment.new(@attr.merge(:name => ""))
    no_name_experiment.should_not be_valid
  end
  it "should have a unique name"
  it "should reject names that are too long"

  it "should require a description" do
    no_description_experiment = Experiment.new(@attr.merge(:description => ""))
    no_description_experiment.should_not be_valid
  end
  it "should reject descriptions that are too long"

  it "cannot be deleted if still referenced by shots"
end
