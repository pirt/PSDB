require 'spec_helper'

describe DynamicImagesController do

  describe "GET 'showImage'" do
    it "should be successful" do
      get 'showImage'
      response.should be_success
    end
  end

  describe "GET 'showPlot'" do
    it "should be successful" do
      get 'showPlot'
      response.should be_success
    end
  end

end
