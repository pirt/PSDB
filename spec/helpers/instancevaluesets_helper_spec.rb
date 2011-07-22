require 'spec_helper'

describe InstancevaluesetsHelper do
  describe "'displayParameter'" do
    before(:each) do
      @instanceValue=Factory(:instancevalue, :name=>"valueparam")
      @instanceValueSet=@instanceValue.instancevalueset
    end
    describe "for existing parameter" do
      it "should display an instancevalue of the given name" do
        result=helper.displayParameter(@instanceValueSet,"valueparam")
        result.should == @instanceValue.data_numeric.to_s+"\n\n"
      end
    end
    describe "for non-existing parameter" do
      it "should display an error message" do
        result=helper.displayParameter(@instanceValueSet,"wrongparameter")
        result.should == "parameter <wrongparameter> not found"
      end
    end
  end
  describe "'generateSeriesPlot'" do
    it "should generate a plot of a series of plot data"
  end
end
