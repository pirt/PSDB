require 'spec_helper'

describe StatisticsController do
  render_views

  # login to http basic auth
  include AuthHelper
  before(:each) do
    http_login
  end

  describe "GET 'overview'" do
    it "should be successful" do
      get 'overview'
      response.should be_success
    end
    it "should have the right title" do
      get 'overview'
      response.should have_selector("title", :content => "Overview")
    end
  end

  describe "GET 'calendar'" do
    it "should be successful" do
      get 'calendar'
      response.should be_success
    end
   it "should have the right title" do
      get 'calendar'
      response.should have_selector("title", :content => "Shot calendar")
    end
  end

end
