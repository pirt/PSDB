require 'spec_helper'

describe ShotsController do

  render_views

  include AuthHelper
  before(:each) do
    # login to http basic auth
    http_login
    @shot=Factory(:shot)
  end
  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
    it "should have the right title" do
      get :index
      response.should have_selector("title",
        :content => "Shot list")
    end
  end

  describe "GET 'show'" do
    describe "for existing shot" do
      it "should be successful" do
        get :show, :id => @shot
        response.should be_success
      end
      it "should find the right shot" do
        get :show, :id => @shot
        assigns(:shot).should == @shot
      end
      it "should have the right title" do
        get :show, :id => @shot
        response.should have_selector("title",
          :content => "Shot #{@shot.id}")
      end
      it "should show timestamp field" do
        get :show, :id => @shot
        response.should contain("Timestamp:")
      end
      it "should show shottype field" do
        get :show, :id => @shot
        response.should contain("Shot type:")
      end
      it "should show comment field" do
        get :show, :id => @shot
        response.should contain("Comment:")
      end
    end
    describe "for non-existing shot" do
      before(:each) do
        @nonExistingIndex=Shot.last.id+1
      end
      it "should have a flash error message" do
        get :show, :id => @nonExistingIndex
        flash[:error].should =~ /Shot not found/i
      end
      it "should redirect to the experiments index" do
        get :show, :id => @nonExistingIndex
        response.should redirect_to(shots_path)
      end
    end
  end

  describe "GET 'edit'" do
    describe "for existing shot" do
      it "should be successful" do
        get :edit, :id => @shot
        response.should be_success
      end
      it "should find the right shot" do
        get :edit, :id => @shot
        assigns(:shot).should == @shot
      end
      it "should have the right title" do
        get :edit, :id => @shot
        response.should have_selector("title", :content => "Edit shot #{@shot.id}")
      end
    end
    describe "for non-existing shot" do
      before(:each) do
        @nonExistingIndex=Shot.last.id+1
      end
      it "should have a flash error message" do
        get :edit, :id => @nonExistingIndex
        flash[:error].should =~ /Shot not found/i
      end
      it "should redirect to the experiments index" do
        get :edit, :id => @nonExistingIndex
        response.should redirect_to(shots_path)
      end
    end
  end

  describe "PUT 'update'" do
    describe "for existing shot" do
      describe "cancel" do
        it "should not update shot" do
          lambda do
            put :update, :id => @shot, :cancel => "1"
          end.should_not change(Shot, :all)
        end
        it "should redirect to shots index" do
          put :update, :id => @shot, :cancel => "1"
          response.should redirect_to shot_path(@shot)
        end
        it "should have a flash message" do
          put :update, :id => @shot, :cancel => "1"
          flash[:info].should =~ /Shot update canceled/i
        end
      end
      describe "failure" do
        before(:each) do
          @attr = { :shottype_id => "", :experiment_id=>"", :description => "" }
        end
        it "should render edit page" do
          put :update, :id => @shot, :shot => @attr
          response.should render_template('edit')
        end
        it "should have the right page title" do
          put :update, :id => @shot, :shot => @attr
          response.should have_selector("title", :content =>"Edit shot #{@shot.id}")
        end
      end
      describe "success" do
        before(:each) do
          @attr = {:description => "New description" }
        end
        it "should update shot"
        it "should redirect to the shots#show" do
          put :update, :id => @shot, :experiment => @attr
          response.should redirect_to(shot_path(@shot))
        end
        it "should have a flash message" do
          put :update, :id => @shot, :experiment => @attr
          flash[:success].should =~ /Shot successfully updated/i
        end
      end
    end
    describe "for non-existing shot" do
      before(:each) do
        @nonExistingIndex=Shot.last.id+1
      end
      it "should redirect to shots index" do
        put :update, :id => @nonExistingIndex
        response.should redirect_to(shots_path)
      end
      it "should have a flash message" do
        put :update, :id => @nonExistingIndex
        flash[:error].should =~ /Shot not found/i
      end
    end
  end

end
