require 'spec_helper'

describe ExperimentsController do
  render_views

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
    it "should have the right title" do
      get :index
      response.should have_selector("title",
        :content => "Experiments")
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should have the right title" do
      get :new
      response.should have_selector("title",
        :content => "Add new experiment")
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get :show,:id => 1
      response.should be_success
    end
    it "should find the right user"
    it "should have the right title" do
      get :show, :id => 1
      response.should have_selector("title",
        :content => "Experiment 1")
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get :edit, :id => 1
      response.should be_success
    end
    it "should find the right user"
    it "should have the right title" do
      get :edit, :id => 1
      response.should have_selector("title",
        :content => "Edit experiment 1")
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      get :destroy, :id => 1
      response.should be_success
    end
    it "should find the right user"
  end

end
