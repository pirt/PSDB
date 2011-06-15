class InstancevaluesController < ApplicationController
  def exportImage
    imageBlob=Instancevalue.find_by_id(params[:instanceValueId]).data_binary
    myImage=Magick::Image.from_blob(imageBlob[4..-1])
    myImage=myImage[0]
    if !params[:selectedExportFormat].blank?
      case params[:selectedExportFormat]
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
    else
      exportFormat='TIF'
    end
    if !params[:withColorPalette].nil?
      paletteImg=Magick::Image.read("public/images/Rainbow.png")
      myImage=myImage.clut_channel(paletteImg[0])
    end
    sendImage=myImage.to_blob { self.format=exportFormat }
    instanceName=Instancevalue.find_by_id(params[:instanceValueId]).instancevalueset.instance.name
    shotNr=Instancevalue.find_by_id(params[:instanceValueId]).instancevalueset.shot_id
    fileName=instanceName+'_'+shotNr.to_s+'.'+exportFormat.downcase
    send_data sendImage, :type => 'image/'+exportFormat, :filename => fileName
  end
  def exportPlot
  end
end
