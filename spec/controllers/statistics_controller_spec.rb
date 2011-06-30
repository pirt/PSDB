require 'spec_helper'

describe StatisticsController do

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
  end

  describe "GET 'calendar'" do
    it "should be successful" do
      get 'calendar'
      response.should be_success
    end
  end

end
