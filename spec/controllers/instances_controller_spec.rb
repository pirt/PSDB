require 'spec_helper'

describe InstancesController do

  # login to http basic auth
  include AuthHelper
  before(:each) do
    http_login
    @instance=Factory(:instance)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => @instance
      response.should be_success
    end
  end

end
