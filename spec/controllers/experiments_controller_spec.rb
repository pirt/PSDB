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

  describe "GET 'show'" do
    before(:each) do
      @experiment = Factory(:experiment)
    end
    it "should be successful" do
      get :show,:id => @experiment
      response.should be_success
    end
    it "should find the right user" do
      get :show, :id => @experiment
      assigns(:experiment).should == @experiment
    end
    it "should have the right title" do
      get :show, :id => @experiment
      response.should have_selector("title",
        :content => @experiment.name)
    end
    it "should include the experiment's name" do
      get :show, :id => @experiment
      response.should have_selector("h1", :content => @experiment.name)
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

  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :description => "" }
      end
      it "should not create an experiment"
      it "should have the right title"
      it "should render the 'new' page"
    end
    describe "success" do
      before(:each) do
        @attr = { :name => "P0010", :description => "Experiment description" }
      end
      it "should create new experiment"
      it "should redirect to 'index' page" do
        post :create, :experiment => @attr
        response.should redirect_to(experiments_path)
      end
      it "should have a flash message"
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get :edit, :id => @experiment
      response.should be_success
    end
    it "should find the right user" do
      get :edit, :id => @experiment
      assigns(:experiment).should == @experiment
    end
    it "should have the right title" do
      get :edit, :id => @experiment
      response.should have_selector("title", :content => @experiment.name)
    end
  end

  describe "PUT 'update'" do
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :description => "" }
      end
      it "should render the 'edit' page" do
        put :update, :id => @experiment, :experiment => @attr
        response.should render_template('edit')
      end
      it "should have the right title" do
        put :update, :id => @experiment, :experiment => @attr
        response.should have_selector("title", :content => "Edit experiment")
      end
    end
    describe "success" do
      before(:each) do
        @attr = { :name => "P0010", :description => "New description" }
      end
      it "should change the experiment's attributes" do
        put :update, :id => @experiment, :experiment => @attr
        @experiment.reload
        @experiment.name.should  == @attr[:name]
        @experiment.description.should  == @attr[:description]
      end
      it "should redirect to the user show page" do
        put :update, :id => @experiment, :experiment => @attr
        response.should redirect_to(experiments_path)
      end
      it "should have a flash message"
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      get :destroy, :id => @experiment
      response.should be_success
    end
    it "should find the right user"
  end

end
