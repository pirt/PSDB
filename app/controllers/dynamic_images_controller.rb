class DynamicImagesController < ApplicationController

  def showImage
    imageblob = read_fragment("image"+Hash[params.sort].to_s)
    if (not imageblob)
      instanceValue=Instancevalue.find(params[:id])
      options={}
      if params[:width].present?
        options.merge!(:width=>params[:width])
      end
      if params[:height].present?
        options.merge!(:height=>params[:height])
      end
      image=instanceValue.generateImage(options)
      imageblob=image.to_blob
      write_fragment("image"+Hash[params.sort].to_s,imageblob)
    end
    send_data imageblob, :type => 'image/png',
                         :disposition => 'inline'
  end

  def showPlot
    imageblob = read_fragment("plot"+Hash[params.sort].to_s)
    if (not imageblob)
      instanceValue=Instancevalue.find(params[:id])
      options={}
      if params[:width].present?
        options.merge!(:width=>params[:width])
      end
      if params[:height].present?
        options.merge!(:height=>params[:height])
      end
      image=instanceValue.generate2dPlot2(options)
      imageblob=image.to_blob
      write_fragment("plot"+Hash[params.sort].to_s,imageblob)
    end
    send_data imageblob, :type => 'image/png',
                         :disposition => 'inline'
  end

  def showMultiPlot
    instanceValueSet=Instancevalueset.find(params[:id])
    parameterNames=params[:parameterNames].split(",")
    options={}
    if params[:width].present?
        options.merge!(:width=>params[:width])
    end
    if params[:height].present?
      options.merge!(:height=>params[:height])
    end
    image=instanceValueSet.generateMultiPlot(parameterNames,options)
    imageblob=image.to_blob
    send_data imageblob, :type => 'image/png',
                         :disposition => 'inline'
  end

  def showSeriesPlot
    image=Magick::Image.read(Rails.root.to_s+"/public/series.png")[0]
    imageblob=image.to_blob
    send_data imageblob, :type => 'image/png',
                         :disposition => 'inline'
  end
end
