# == Schema Information
# Schema version: 20110405192247
#
# Table name: instancevalues
#
#  id                 :integer(38)     not null, primary key
#  instancevalueset_id :integer(38)     not null
#  datatype_id        :integer(38)     not null
#  name               :string(256)     not null
#  data_numeric       :decimal(, )
#  data_string        :string(255)
#  data_binary        :binary
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

require 'faster_csv'

class Instancevalue < ActiveRecord::Base
  attr_accessible :instancevalueset_id, :name, :data_numeric, :data_binary, :data_string, :data_binary,
                  :datatype_id

  belongs_to :instancevalueset
  belongs_to :datatype

  validates :name, :presence => true,
                   :length => { :maximum => 255 }

  #validates_presence_of_at_least_one_field :data_numeric, :data_string, :data_binary

  validates :datatype, :presence => true

  def export2dData
    axisDescription=self.data_string
    txtData=""
    if (axisDescription)
      descriptionParts=axisDescription.split(",")
      if (descriptionParts[0])
        txtData+=descriptionParts[0]
      end
        if (descriptionParts[2])
        txtData+=" ["+descriptionParts[2]+"]"
      end
      txtData+="\t"
      if (descriptionParts[1])
        txtData+=descriptionParts[1]
      end
      if (descriptionParts[3])
        txtData+=" ["+descriptionParts[3]+"]"
      end
      txtData+="\n"
    end

    plotBlob=trimBlob(self.data_binary)
    #splitData=plotBlob.split(",")
    splitData=FCSV(plotBlob).read[0]
    nrOfData=splitData.length
    (0..nrOfData-1).step(2) do |dataIndex|
      txtData+=splitData[dataIndex]
      txtData+="\t"
      txtData+=splitData[dataIndex+1]
      txtData+="\n"
    end
    instanceName=self.instancevalueset.instance.name
    shotNr=self.instancevalueset.shot_id
    fileName=instanceName+'_'+shotNr.to_s+'.txt'
    return {:content=>txtData, :type=>"txt", :filename=>fileName}
  end

  def exportImage(options={})
    localOptions={:exportFormat=>"2",:withColorPalette=>false}
    localOptions=localOptions.merge(options)
    imageBlob=trimBlob(self.data_binary)
    myImage=Magick::Image.from_blob(imageBlob)
    myImage=myImage[0]
    case localOptions[:exportFormat]
      when '1'
        exportFormat='BMP'
     when '2'
        exportFormat='TIF'
      when '3'
        exportFormat='JPG'
      when '4'
        exportFormat='PNG'
      when '5'
        exportFormat='GIF'
      when '6'
        exportFormat='TXT'
      else
        exportFormat='PNG'
    end
    if localOptions[:withColorPalette]
      paletteImg=Magick::Image.read("public/images/Rainbow.png")
      myImage=myImage.clut_channel(paletteImg[0])
    end
    sendImage=myImage.to_blob { self.format=exportFormat }
    instanceName=self.instancevalueset.instance.name
    shotNr=self.instancevalueset.shot_id
    fileName=instanceName+'_'+shotNr.to_s+'.'+exportFormat.downcase
    return {:content=>sendImage, :format=>'image/'+exportFormat, :filename=>fileName}
  end

  def generateImage(options = {})
    imageOptions={:width => 320, :height =>200}
    imageOptions=imageOptions.merge(options)
    fileName="public/images/tmp/image"+self.id.to_s+"_"+
        imageOptions[:width].to_s+"_"+imageOptions[:height].to_s+".png"
    if !File.exists?(fileName)
      imageData=trimBlob(self.data_binary)
      myImage=Magick::Image.from_blob(imageData)
      myImage=myImage[0]
      paletteImg=Magick::Image.read("public/images/Rainbow.png")
      myImage=myImage.clut_channel(paletteImg[0])
      myImage=myImage.resize_to_fit(imageOptions[:width],imageOptions[:height])
      myImage.write fileName
    end
    return fileName.sub("public/images/","")
  end

# -------------------------------------------------------------------------------------------------
private
  def trimBlob(blob)
    blob[4..-1]
  end
  def convert2D(data)
    splitData=trimBlob(data).split(",")
    nrOfData=splitData.length
    xValues=[]
    yValues=[]
    (0..nrOfData-1).step(2) do |dataIndex|
      xValues << splitData[dataIndex].to_f
      yValues << splitData[dataIndex+1].to_f
    end
    [xValues,yValues]
  end
end
