require 'spec_helper'

describe ShotsController do
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
    it "should have the right title"
  end

  describe "GET 'show'" do
    it "should be successful" do
      get :show, :id => @shot
      response.should be_success
    end
    it "should have the right title"
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get :edit, :id => @shot
      response.should be_success
    end
    it "should have the right title"
  end

  describe "PUT 'update'" do
    describe "for existing shot" do
      describe "cancel" do
        it "should not update shot"
        it "should redirect to shots index"
        it "should have a flash message"
      end
      describe "failure" do
        it "should render edit page"
        it "should have the right page title"
      end
      describe "success" do
        it "should update shot"
        it "should redirect to the shots#show"
        it "should have a flash message"
      end
    end
    describe "for non-existing shot" do
      it "should redirect to shots index"
      it "should have a flash message"
    end
  end

end
