# == Schema Information
#
# Table name: experiments
#
#  id          :integer(38)     not null, primary key
#  name        :string(30)      not null
#  active      :boolean(1)      default(TRUE)
#  description :string(255)     not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

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
  it "should have a boolean column named 'active' which is true by default" do
    experiment=Experiment.new(@attr)
    experiment.active.should eq(true)
  end
  describe "associations" do
    before(:each) do
      @experiment = Experiment.create(@attr)
    end

    it "should have a shots attribute" do
      @experiment.should respond_to(:shots)
    end

    it "should have an attachments attribute" do
      @experiment.should respond_to(:attachments)
    end

    it "cannot be deleted if still referenced by shots" do
      @shot=Factory(:shot)
      @experiment=@shot.experiment
      lambda do
         @experiment.destroy
      end.should_not change(Experiment, :count)
    end
  end
  describe "method" do
    describe "'getBeamtimes'" do
      it "should correctly work for experiments with only one shot" do
        shot=Factory(:shot)
        experiment=shot.experiment
        beamtimes=experiment.getBeamtimes
        beamtimes.length.should eq(1)
        beamtimes[0][:firstId].should eq(shot.id)
        beamtimes[0][:lastId].should eq(shot.id)
      end
      it "should correctly work for experiments with two shots within 5 days" do
        shot1=Factory(:shot)
        experiment=shot1.experiment
        shottype=shot1.shottype
        date1=shot1.created_at
        shot2=Factory(:shot,{:experiment_id=>experiment.id, :shottype_id=>shottype.id, :created_at=>date1+4.days})
        beamtimes=experiment.getBeamtimes
        beamtimes.length.should eq(1)
        beamtimes[0][:firstId].should eq(shot1.id)
        beamtimes[0][:lastId].should eq(shot2.id)
      end
      it "should correctly work for experiments with two shots more than 5 days apart" do
        shot1=Factory(:shot)
        experiment=shot1.experiment
        shottype=shot1.shottype
        date1=shot1.created_at
        shot2=Factory(:shot,{:experiment_id=>experiment.id, :shottype_id=>shottype.id, :created_at=>date1+6.days})
        beamtimes=experiment.getBeamtimes
        beamtimes.length.should eq(2)
        beamtimes[0][:firstId].should eq(shot1.id)
        beamtimes[0][:lastId].should eq(shot1.id)
        beamtimes[1][:firstId].should eq(shot2.id)
        beamtimes[1][:lastId].should eq(shot2.id)
      end
      it "should return empty array if no shots are connected to an experiments" do
        experiment=Experiment.create(@attr)
        experiment.getBeamtimes.length.should eq(0)
      end
    end
  end
end

