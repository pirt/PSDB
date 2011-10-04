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
      it "should return a PNG image file" do
        imageData=@instValImage.exportImage
        controller.stub!(:send_data)
        controller.stub!(:render)
        controller.should_receive(:send_data).
          with(imageData[:content],:type => "image/PNG", :filename => imageData[:filename])
        get :exportImage, :instanceValueId=>@instValImage.id
      end
      it "should return a JPEG image file if selectedImageFormat=3" do
        imageData=@instValImage.exportImage(:exportFormat=>"3")
        controller.stub!(:send_data)
        controller.stub!(:render)
        controller.should_receive(:send_data).
          with(imageData[:content],:type => "image/JPG", :filename => imageData[:filename])
        get :exportImage, :instanceValueId=>@instValImage.id, :selectedExportFormat=>"3"
      end
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
        @instVal2D=Factory(:instancevalue_twod)
      end
      it "should be successful" do
        get :exportPlot, :instanceValueId=>@instVal2D.id
        response.should be_successful
      end
      it "should return a CSV file" do
        txtData=@instVal2D.export2dData
        controller.stub!(:send_data)
        controller.stub!(:render)
        controller.should_receive(:send_data).
          with(txtData[:content],:type => txtData[:type], :filename => txtData[:filename])
        get :exportPlot, :instanceValueId=>@instVal2D.id
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

