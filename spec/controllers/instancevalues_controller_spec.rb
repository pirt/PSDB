require 'spec_helper'

describe InstancevaluesController do
  # login to http basic auth
  include AuthHelper
  before(:each) do
    http_login
  end

  describe "GET exportImage" do
    it "should be successful"
  end
  describe "GET exportPlot" do
    it "should be successful"
  end
end
