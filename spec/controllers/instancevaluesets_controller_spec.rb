require 'spec_helper'

describe InstancevaluesetsController do
  # login to http basic auth
  include AuthHelper
  before(:each) do
    http_login
    @instancevalueset=Factory(:instancevalueset)
  end
  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id=>@instancevalueset
      response.should be_success
    end
  end

end
