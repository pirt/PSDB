# == Schema Information
#
# Table name: instancevalues
#
#  id                  :integer(38)     not null, primary key
#  instancevalueset_id :integer(38)     not null
#  datatype_id         :integer(38)     not null
#  name                :string(256)     not null
#  data_numeric        :decimal(, )
#  data_string         :string(255)
#  data_binary         :binary
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

require 'spec_helper'

describe Instancevalue do
  before(:each) do
    @datatype=Factory(:datatype)
    @instancevalueset=Factory(:instancevalueset)
    @attr={:name => "test parameter",
           :instancevalueset_id => @instancevalueset.id,
           :datatype_id => @datatype.id,
           :data_numeric => 1234 }
  end
  it "should create an instance given valid attributes" do
    valid_instancedata=Instancevalue.new(@attr)
    valid_instancedata.should be_valid
  end
  it "should require a name" do
    no_name_instancedata=Instancevalue.new(@attr.merge(:name => ""))
    no_name_instancedata.should have(1).error_on(:name)
  end
  it "should reject names longer than 255 characters" do
    longname = "a"*256
    longname_instancedata=Instancevalue.new(@attr.merge(:name => longname))
    longname_instancedata.should have(1).error_on(:name)
  end
  describe "data field conditions" do
    it "should reject if no data field set" do
      nodata_instancedata=Instancevalue.new(@attr.merge(:data_numeric => nil))
      nodata_instancedata.should_not be_valid
    end
    it "should accept instances with numeric data" do
      numeric_instancedata=Instancevalue.new(@attr.merge(:data_numeric => 1234))
      numeric_instancedata.should be_valid
    end
    it "should accept instances with string data" do
      string_instancedata=Instancevalue.new(@attr.merge(:data_string => "test"))
      string_instancedata.should be_valid
    end
    it "should accept instances with binary data" do
      binary_instancedata=Instancevalue.new(@attr.merge(:data_binary => "binary data"))
      binary_instancedata.should be_valid
    end
  end
  describe "association" do
    it "should belong to an instancevalueset" do
      instancedata=Instancevalue.new(@attr)
      instancedata.should respond_to(:instancevalueset)
    end
    it "should reference an existing instancevalueset" do
      nonExistingValueSetId=@instancevalueset.id + 1
      corrupted_instancedata=Instancevalue.new(@attr.merge(:instancevalueset_id => nonExistingValueSetId))
      corrupted_instancedata.should_not be_valid
    end
    it "should belong to a datatype" do
      instancedata=Instancevalue.new(@attr)
      instancedata.should respond_to(:datatype)
    end
    it "should reference an existing datatype" do
      nonExistingDatatypeId=@datatype.id + 1
      corrupted_instancedata=Instancevalue.new(@attr.merge(:datatype_id => nonExistingDatatypeId))
      corrupted_instancedata.should_not be_valid
    end
  end
  describe "instance method" do
    describe "'export2dData'" do
      before(:each) do
        datatype2D=Factory(:datatype,:name=>"2dData")
        axisDescription="XValue,YValue,m,s"
        data2D="AAAA1.0,2.0\n3.0,4.0"
        @attr2d=@attr.merge({:datatype_id=>datatype2D.id,:name=>"spectrum",:data_numeric=>nil,
                                                        :data_string=>axisDescription, :data_binary=>data2D})
      end
      it "should return return a correct CSV text string" do
        correctValue=Instancevalue.create(@attr2d)
        result=correctValue.export2dData
        result[:content].should eq("XValue [m]\tYValue [s]\n1.0\t2.0\n3.0\t4.0\n")
        result[:type].should eq("text/plain")
        result[:filename].should eq(correctValue.instancevalueset.instance.name+"_"+
                                    correctValue.instancevalueset.shot.id.to_s+".txt")
      end
      it "should return 'nil' if instancevalue has wrong data type" do
        wrongDataType=Factory(:datatype,:name=>"wrongType")
        wrongDataTypeValue=Instancevalue.new(@attr2d.merge({:datatype_id=>wrongDataType.id}))
        wrongDataTypeValue.export2dData.should eq(nil)
      end
      it "should return only axis description if a 2dData instancevalue has no data" do
        emptyValue=Instancevalue.new(@attr2d.merge(:data_binary=>nil))
        emptyValue.export2dData[:content].should eq("XValue [m]\tYValue [s]\n")
      end
      it "should return an empty string if data field has wrong format" do
        emptyValue=Instancevalue.new(@attr2d.merge(:data_binary=>"XXXXabcde,fef,142463\n\n"))
        emptyValue.export2dData[:content].should eq("XValue [m]\tYValue [s]\nabcde\tfef\n\t\n")
      end
      it "should return only value table if no axisDescription is given" do
        noDescValue=Instancevalue.new(@attr2d.merge(:data_string=>nil))
        noDescValue.export2dData[:content].should eq("1.0\t2.0\n3.0\t4.0\n")
      end
    end
    describe "'exportImage'" do
      before(:each) do
        datatypeImage=Factory(:datatype,:name=>"image")
        imagePath=Rails.root.to_s+"/public/images/Rainbow.png"
        @testImage=Magick::Image.read(imagePath)[0].to_blob
        dataImage="AAAA"+@testImage
        @attrImage=@attr.merge({:datatype_id=>datatypeImage.id,:name=>"image",:data_numeric=>nil,
                                                        :data_string=>nil, :data_binary=>dataImage})
      end
      it "should return a string representing the bytestream of the image for an image instancevalue" do
        correctValue=Instancevalue.new(@attrImage)
        result=correctValue.exportImage
        #result[:content].should eq(@testImage)
        result[:format].should eq("image/PNG")
        result[:filename].should eq(correctValue.instancevalueset.instance.name+"_"+
                                    correctValue.instancevalueset.shot.id.to_s+".png")
      end
      it "should return 'nil' if instancevalue has wrong data type" do
        wrongDataType=Factory(:datatype,:name=>"wrongType")
        wrongDataTypeValue=Instancevalue.new(@attrImage.merge({:datatype_id=>wrongDataType.id}))
        wrongDataTypeValue.exportImage.should eq(nil)
      end
      it "should return empty content if data field is empty" do
        emptyImage=Factory(:datatype,:name=>"emptyImage")
        emptyImage=Instancevalue.new(@attrImage.merge({:datatype_binary=>nil}))
        result=emptyImage.exportImage
        result[:content].should eq("")
        result[:format].should eq("image/PNG")
        result[:filename].should eq(emptyImage.instancevalueset.instance.name+"_"+
                                    emptyImage.instancevalueset.shot.id.to_s+".png")
      end
      it "should return empty content if data field has wrong format" do
        illegalImage=Factory(:datatype,:name=>"illegalImage")
        illegalImage=Instancevalue.new(@attrImage.merge({:datatype_binary=>"AAAA12345"}))
        result=illegalImage.exportImage
        result[:content].should eq("")
        result[:format].should eq("image/PNG")
        result[:filename].should eq(illegalImage.instancevalueset.instance.name+"_"+
                                    illegalImage.instancevalueset.shot.id.to_s+".png")
      end
    end
    describe "'generateImage'" do
      it "should generate an Image for an image instancevalue"
    end
    describe "'generate2dPlot'" do
      it "should generate an plot image for a 2dData instancevalue"
    end
    describe "'generatePlotDataSet'" do
    end
    describe "'generatePlotAxisDescriptions'" do
      it "should generate options list with axis labels" do
        plotDescInstValue=Instancevalue.new(@attr.merge(:data_string=>"A,B,C,D"))
        plotOptions=plotDescInstValue.generatePlotAxisDescriptions()
        plotOptions[:xlabel].should == "A [C]"
        plotOptions[:ylabel].should == "B [D]"
      end
      it "should generate correct options list with empty labels id string field is empty" do
        emptyStringInstValue=Instancevalue.new(@attr.merge(:data_string=>""))
        plotOptions=emptyStringInstValue.generatePlotAxisDescriptions()
        plotOptions[:xlabel].should == ""
        plotOptions[:ylabel].should == ""
      end
      it "should generate correct options list with empty labels id string field has empty fields" do
        emptyFieldsInstValue=Instancevalue.new(@attr.merge(:data_string=>",,,,"))
        plotOptions=emptyFieldsInstValue.generatePlotAxisDescriptions()
        plotOptions[:xlabel].should == ""
        plotOptions[:ylabel].should == ""
      end
      it "should generate options list with empty axis labels if instancevalue has no data_string field" do
        noStringInstValue=Instancevalue.new(:@attr)
        plotOptions=noStringInstValue.generatePlotAxisDescriptions()
        plotOptions[:xlabel].should == ""
        plotOptions[:ylabel].should == ""
      end
    end
  end
end

