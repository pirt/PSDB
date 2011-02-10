require 'spec_helper'

describe Shot do
  before(:each) do
    @experiment=Factory(:experiment)
    @attr=Factory.attributes_for(:shot)
  end
  it "should create instance given valid attributes" do
    s=@experiment.shots.new(@attr)
    s.should be_valid
  end
  it "should have a timestamp" do
    s=Shot.new(@attr)
    s.should respond_to(:created_at)
    s.should respond_to(:updated_at)
  end
  it "should have a comment field" do
    a=Shot.new(@attr)
    a.should respond_to(:comment)
  end
  it "should reject comments longer than 255 characters" do
    shotWithLongComment=@experiment.shots.new(@attr.merge(:comment => "a"*256))
    shotWithLongComment.should_not be_valid
  end

  it "should have a shottype association" do
    a=Shot.new(@attr)
    a.should respond_to(:shottype_id)
  end
  it "requires an existing shottype id"
  
  it "should have an experiment reference" do
    a=Shot.new(@attr)
    a.should respond_to(:experiment_id)
  end
  it "requires an existing experiment id" do
    nonExistingExperimentId=@experiment.id+1
    s=Shot.new(@attr.merge(:experiment_id => nonExistingExperimentId))
    s.should_not be_valid
  end
end
