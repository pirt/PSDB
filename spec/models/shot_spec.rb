require 'spec_helper'

describe Shot do
  before(:each) do
    @experiment=Factory(:experiment)
    @attr=Factory.attributes_for(:shot)
  end
  it "should create instance given valid attributes"

  it "should have a timestamp" do
    a=@experiment.shots.new(@attr)
    a.should respond_to(:created_at)
    a.should respond_to(:updated_at)
  end
  it "should have a comment field" do
    a=@experiment.shots.new(@attr)
    a.should respond_to(:comment)
  end
  it "should reject comments longer than 255 characters" do
    shotWithLongComment=@experiment.shots.new(@attr.merge(:comment => "a"*256))
    shotWithLongComment.should_not be_valid
  end

  it "should have a shottype association" do
    a=@experiment.shots.new(@attr)
    a.should respond_to(:shottype_id)
  end
  it "requires an existing shottype id"
  
  it "should have an experiment reference" do
    a=@experiment.shots.new(@attr)
    a.should respond_to(:experiment_id)
  end
  it "requires an existing experiment id"
end
