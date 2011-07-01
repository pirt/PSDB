require 'spec_helper'

describe PagesController do
  render_views

  # login to http basic auth
  include AuthHelper
  before(:each) do
    http_login
  end

  describe "GET 'start'" do
    it "should be successful" do
      get 'start'
      response.should be_success
    end
  end
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    it "should have the right title" do
      get 'about'
      response.should have_selector("title", :content => "About")
    end
  end
  describe "GET 'changelog'" do
    it "should be successful" do
      get 'changelog'
      response.should be_success
    end
    it "should have the right title" do
      get 'changelog'
      response.should have_selector("title", :content => "Changelog")
    end
  end
end
