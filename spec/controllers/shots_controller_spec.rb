require 'spec_helper'

describe ShotsController do
  before(:each) do
    @experiment=Factory(:experiment)
    @shot=@experiment.shots.create!(Factory.attributes_for(:shot))
  end
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
    it "should have the right title"
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => @shot
      response.should be_success
    end
    it "should have the right title"
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => @shot
      response.should be_success
    end
    it "should have the right title"
  end

  describe "PUT 'update'" do
    it "should update shot"
  end

end
