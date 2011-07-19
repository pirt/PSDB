require 'spec_helper'

describe InstancevaluesController do
  # login to http basic auth
  include AuthHelper
  before(:each) do
    http_login
  end

  describe "GET exportImage" do
    describe "for non-existing instancevalue" do
      it "should redirect to shots index" do
        get :exportImage, :instanceValueId=>0
        response.should redirect_to(shots_path)
      end
      it "should show an error flash" do
        get :exportImage, :instanceValueId=>0
        flash[:error].should =~ /Image not found/i
      end
    end
    describe "for existing instancevalue of datatype 'image'" do
      before(:each) do
        @instValImage=Factory(:instancevalue_image)
      end
      it "should be successful" do
        get :exportImage, :instanceValueId=>@instValImage.id
        response.should be_successful
      end
      it "should return an image file"
    end
    describe "for existing instancevalue of wrong datatype" do
      before(:each) do
        @wrongInstVal=Factory(:instancevalue)
      end
      it "should redirect to shots index" do
        get :exportImage, :instanceValueId=>@wrongInstVal.id
        response.should redirect_to(shots_path)
      end
      it "should show an error flash" do
        get :exportImage, :instanceValueId=>@wrongInstVal.id
        flash[:error].should =~ /Error exporting image/i
      end
    end
  end
  describe "GET exportPlot" do
    describe "for non-existing instancevalue" do
      it "should redirect to shots index" do
        get :exportPlot, :instanceValueId=>0
        response.should redirect_to(shots_path)
      end
      it "should show an error flash" do
        get :exportPlot, :instanceValueId=>0
        flash[:error].should =~ /Plot data not found/i
      end
    end
    describe "for existing instancevalue of datatype '2dData'" do
      before(:each) do
        @instVal2D=Factory(:instancevalue_2dData)
      end
      it "should be successful" do
        get :exportPlot, :instanceValueId=>@instVal2D.id
        response.should be_successful
      end
      it "should return a CSV file" do
        get :exportPlot, :instanceValueId=>@instVal2D.id
	response.headers["Content-Type"].should eq('text/csv')
      end
    end
    describe "for existing instancevalue of wrong datatype" do
      before(:each) do
        @wrongInstVal=Factory(:instancevalue)
      end
      it "should redirect to shots index" do
        get :exportPlot, :instanceValueId=>@wrongInstVal.id
        response.should redirect_to(shots_path)
      end
      it "should show an error flash" do
        get :exportPlot, :instanceValueId=>@wrongInstVal.id
        flash[:error].should =~ /Error exporting 2dData/i
      end
    end
  end
end

