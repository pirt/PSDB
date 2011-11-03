require 'spec_helper'

describe DynamicImagesController do

  describe "GET 'showImage'" do
    it "should be successful" do
      get 'showImage'
      response.should be_success
    end
    it "should return an image"
  end

  describe "GET 'showPlot'" do
    it "should be successful" do
      get 'showPlot'
      response.should be_success
    end
    it "should return an image"
  end

  describe "GET 'showMultiPlot'" do
    it "should be successful" do
      get 'showMultiPlot'
      response.should be_success
    end
    it "should return an image"
  end

  describe "GET 'showSeriesPlot'" do
    it "should be successful" do
      get 'showMultiPlot'
      response.should be_success
    end
    it "should return an image"
  end
end
