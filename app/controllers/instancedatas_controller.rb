class InstancedatasController < ApplicationController
  def exportImage
    imageBlob=Instancedata.find_by_id(params[:instanceDataId]).data_binary
    myImage=Magick::Image.from_blob(imageBlob[4..-1])
    myImage=myImage[0]
    sendImage=myImage.to_blob { self.format='GIF' }
    send_data sendImage, :type => 'image/gif'
  end
end
