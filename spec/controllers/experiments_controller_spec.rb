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
    describe "for existing shot" do
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
    describe "for non-existing shot" do
      before(:each) do
        @nonExistingIndex=Experiment.last.id+1
      end
      it "should have a flash error message" do
        get :show, :id => @nonExistingIndex
        flash[:error].should =~ /Experiment not found/i
      end
      it "should redirect to the experiments index" do
        get :show, :id => @nonExistingIndex
        response.should redirect_to(experiments_path)
      end
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
    describe "cancel" do
      it "should not create an experiment" do
        lambda do
          post :create, :cancel => "1"
        end.should_not change(Experiment, :count)
      end
      it "should redirect to the experiments index" do
        post :create, :cancel => "1"
        response.should redirect_to(experiments_path)
      end
      it "should have a flash message" do
        post :create, :cancel => "1"
        flash[:info].should =~ /Experiment creation canceled/i
      end
    end
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :description => "" }
      end
      it "should not create an experiment" do
        lambda do
          post :create, :experiment => @attr
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
    describe "for existing experiment" do
      it "should be successful" do
        get :edit, :id => @experiment
        response.should be_success
      end
      it "should find the right experiment" do
        get :edit, :id => @experiment
        assigns(:experiment).should == @experiment
      end
      it "should have the right title" do
        get :edit, :id => @experiment
        response.should have_selector("title", :content => @experiment.name)
      end
    end
    describe "for non-existing experiment" do
      before(:each) do
        @nonExistingIndex=Experiment.last.id+1
      end
      it "should have a flash error message" do
        get :edit, :id => @nonExistingIndex
        flash[:error].should =~ /Experiment not found/i
      end
      it "should redirect to the experiments index" do
        get :edit, :id => @nonExistingIndex
        response.should redirect_to(experiments_path)
      end
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @experiment = Factory(:experiment)
    end
    describe "for existing experiment" do
      describe "cancel" do
        it "should not change the experiment" do
          lambda do
            put :update, :id => @experiment, :cancel => "1"
          end.should_not change(Experiment, :all)
        end
        it "should redirect to the experiments index" do
          put :update, :id => @experiment, :cancel => "1"
          response.should redirect_to(experiments_path)
        end
        it "should have a flash message" do
          put :update, :id => @experiment, :cancel => "1"
          flash[:info].should =~ /Experiment update canceled/i
        end
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
    describe "for non-existing experiment" do
      before(:each) do
        @nonExistingIndex=Experiment.last.id+1
      end
      it "should have a flash error message" do
        put :update, :id => @nonExistingIndex
        flash[:error].should =~ /Experiment not found/i
      end
      it "should redirect to the experiments index" do
        put :update, :id => @nonExistingIndex
        response.should redirect_to(experiments_path)
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @experiment = Factory(:experiment)
    end
    describe "for existing experiment" do
      describe "with associated attachments" do
        it "should not delete the experiment"
      end
      describe "with no associated shots" do
        it "should delete the experiment" do
        lambda do
          delete :destroy, :id => @experiment
          end.should change(Experiment, :count).by(-1)
        end
        it "should have a success flash message" do
          delete :destroy, :id => @experiment
          flash[:success].should =~ /Experiment successfully deleted/i
        end
      end
      describe "with associated shots" do
        # TODO: add a shot associated to @experiment
        it "should not delete the experiment"
        it "should have an error flash message"
      end
    end
    describe "for non-existing experiment" do
      before(:each) do
        @nonExistingIndex=(Experiment.last).id+1
      end
      it "should have an error flash message" do
        delete :destroy, :id => @nonExistingIndex
        flash[:error].should =~ /Experiment not found/i
      end
      it "should redirect to experiments index" do
        delete :destroy, :id => @nonExistingIndex
        response.should redirect_to(experiments_path)
      end
    end
  end
end
