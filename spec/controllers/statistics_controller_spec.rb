require 'spec_helper'

describe StatisticsController do

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
