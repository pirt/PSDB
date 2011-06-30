require 'spec_helper'

describe InstancevaluesController do

  # login to http basic auth
  include AuthHelper
  before(:each) do
    http_login
  end
end
