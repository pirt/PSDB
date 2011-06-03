class InstancevaluesController < ApplicationController
  def exportImage
    imageBlob=Instancevalue.find_by_id(params[:instanceValueId]).data_binary
    myImage=Magick::Image.from_blob(imageBlob[4..-1])
    myImage=myImage[0]
    sendImage=myImage.to_blob { self.format='GIF' }
    send_data sendImage, :type => 'image/gif'
  end
end
