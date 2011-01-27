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
      response.should have_selector("h2", :content => @experiment.name)
    end
    it "should show created_at field" do
      get :show, :id => @experiment
      response.should contain("Created at:")
    end
    it "should show updated_at field" do
      get :show, :id => @experiment
      response.should contain("Updated at:")
    end
    it "should show # of associated shots"
    it "should show first and last date of asscociated shots"
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
      it "should not create an experiment" do
        lambda do
          post :create, :user => @attr
        end.should_not change(Experiment, :count)
      end
      it "should have the right title" do
        post :create, :experiment => @attr
        response.should have_selector("title", :content => "Add new experiment")
      end
      it "should render the 'new' page" do
        post :create, :experiment => @attr
        response.should render_template('new')
      end
    end
    describe "success" do
      before(:each) do
        @attr = { :name => "P0010", :description => "Experiment description" }
      end
      it "should create new experiment" do
        lambda do
          post :create, :experiment => @attr
        end.should change(Experiment, :count).by(1)
      end
      it "should redirect to 'index' page" do
        post :create, :experiment => @attr
        response.should redirect_to(experiments_path)
      end
      it "should have a flash message" do
        post :create, :experiment => @attr
        flash[:success].should =~ /Experiment successfully created/i
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @experiment = Factory(:experiment)
    end

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
    before(:each) do
      @experiment = Factory(:experiment)
    end
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
        response.should have_selector("title", :content => @experiment.name)
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
      it "should redirect to the experiment show page" do
        put :update, :id => @experiment, :experiment => @attr
        response.should redirect_to(experiments_path)
      end
      it "should have a flash message" do
        put :update, :id => @experiment, :experiment => @attr
        flash[:success].should =~ /Experiment successfully updated/i
      end
    end
  end

  describe "DELETE 'destroy'" do
     before(:each) do
      @experiment = Factory(:experiment)
    end
    describe "for experiment with no associated shots" do
      it "should delete the experiment" do
      lambda do
        delete :destroy, :id => @experiment
        end.should change(Experiment, :count).by(-1)
      end
      it "should have a success flash message" do
        flash[:success].should =~ /Experiment successfully deleted/i
      end
    end
    describe "for experiment with associated shots" do
       # TODO: add a shot associated to @experiment
      it "should not delete the experiment"
      it "should have an error flash message" do
        flash[:error].should =~ /Experiment not deleted, because of associated shots/i
      end
    end
    it "should be successful" do
      get :destroy, :id => @experiment
      response.should be_success
    end
    it "should redirect to experiments index"
  end
end
