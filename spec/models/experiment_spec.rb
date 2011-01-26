require 'spec_helper'

describe Experiment do

  before(:each) do
    @attr = { :name => "P0038", :description => "Experiment description" }
  end
  
  it "should create a new instance given valid attributes" do
    Experiment.create!(@attr)
  end

  it "should require a name" do
    no_name_experiment = Experiment.new(@attr.merge(:name => ""))
    no_name_experiment.should_not be_valid
  end

  it "should have a unique index on name column"
 
  it "should have a unique (case insensitive) name" do
    Experiment.create!(@attr)
    experiment_with_duplicate_name = Experiment.new(@attr.merge(:name => "p0038", :description => "Another description"))
    experiment_with_duplicate_name.should_not be_valid
  end

  it "should reject names that are longer than 30 characters" do
    long_name = "a" * 31
    long_name_experiment = Experiment.new(@attr.merge(:name => long_name))
    long_name_experiment.should_not be_valid
  end

  it "should require a description" do
    no_description_experiment = Experiment.new(@attr.merge(:description => ""))
    no_description_experiment.should_not be_valid
  end

  it "should reject descriptions that are longer than 255 characters" do
   long_description = "a" * 256
   long_description_experiment = Experiment.new(@attr.merge(:name => long_description))
   long_description_experiment.should_not be_valid
  end

  describe "shot associations" do

    before(:each) do
      @experiment = Experiment.create(@attr)
    end

    it "should have a shots attribute" do
      @experiments.should respond_to(:shots)
    end

    it "should have a experiment_attachments attribute" do
      @experiments.should respond_to(:experiment_attachments)
    end

    it "cannot be deleted if still referenced by shots"
  end
end
