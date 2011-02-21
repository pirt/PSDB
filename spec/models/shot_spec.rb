require 'spec_helper'

describe Shot do
  before(:each) do
    @experiment=Factory(:experiment, :name => "other")
    @shottype=Factory(:shottype, :name => "other")
    @attr= {:description => "test comment", :shottype_id => @shottype.id, :experiment_id => @experiment.id}
  end
  it "should create instance given valid attributes" do
    shot=Shot.new(@attr)
    shot.should be_valid
  end
  it "should have a timestamp" do
    shot=Shot.new(@attr)
    shot.should respond_to(:created_at)
    shot.should respond_to(:updated_at)
  end
  it "should have a description field" do
    shot=Shot.new(@attr)
    shot.should respond_to(:description)
  end
  it "should reject descriptions longer than 255 characters" do
    shotWithLongComment=@experiment.shots.new(@attr.merge(:description => "a"*256))
    shotWithLongComment.should_not be_valid
  end
  it "should have an attachment association" do
    shot=Shot.new(@attr)
    shot.should respond_to(:attachments)
  end
  it "should have an instancedata association" do
    shot=Shot.new(@attr)
    shot.should respond_to(:instancedatas)
  end
  it "should have a shottype association" do
    shot=Shot.new(@attr)
    shot.should respond_to(:shottype)
  end
  it "requires an existing shottype id" do
    nonExistingShottypeId=@shottype.id+1
    shot=Shot.new(@attr.merge(:shottype_id => nonExistingShottypeId))
    shot.should_not be_valid
  end
  it "should have an experiment reference" do
    shot=Shot.new(@attr)
    shot.should respond_to(:experiment)
  end
  it "requires an existing experiment id" do
    nonExistingExperimentId=@experiment.id+1
    shot=Shot.new(@attr.merge(:experiment_id => nonExistingExperimentId))
    shot.should_not be_valid
  end
  it "should not be destroyed if instancedatas associated" do
    @instancedata=Factory(:instancedata)
    @shot=@instancedata.shot
    lambda do
       @shot.destroy
    end.should_not change(Shot, :count)
  end
end
