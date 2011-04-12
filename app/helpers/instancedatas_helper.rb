require "gnuplot"
require "RMagick"


module InstancedatasHelper
  def trimBlob(blob)
    trimmedBlob=blob[4..-1]
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

  def generatePlot(xyData, fileId, options={})
    plotOptions={:width=>200, :height=>100, :imagetype=> "png", :xlabel=> "", :ylabel=> ""}
    plotOptions=plotOptions.merge(options)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.terminal "#{plotOptions[:imagetype]} tiny size #{plotOptions[:width]},#{plotOptions[:height]}"
        plot.output "public/images/tmp/test"+fileId.to_s+".#{plotOptions[:imagetype]}"
        plot.ylabel plotOptions[:ylabel]
        plot.xlabel plotOptions[:xlabel]
        plot.data << Gnuplot::DataSet.new( xyData ) do |ds|
          ds.with = "lines"
          ds.notitle
        end
      end
    end
  end

  def generate2dPlot(instancedata, options = {})
    xyData=convert2D(instancedata.data_binary)
    plotOptions={:xlabel=> "", :ylabel=> ""}
    axisDescription=instancedata.data_string
    if (axisDescription)
      descriptionParts=axisDescription.split(",")
      if (descriptionParts[0]) 
        plotOptions[:xlabel]+=descriptionParts[0] 
      end
        if (descriptionParts[1]) 
        plotOptions[:ylabel]+=descriptionParts[1] 
      end
      if (descriptionParts[2]) 
        plotOptions[:xlabel]+=" ["+descriptionParts[2]+"]" 
      end
      if (descriptionParts[3]) 
        plotOptions[:ylabel]+=" ["+descriptionParts[3]+"]"
      end
    end
    plotOptions=plotOptions.merge(options)
    generatePlot(xyData, instancedata.id,plotOptions)
  end

  def displayImage(instancedata, options = {} )
    imageOptions={:width => 320, :height =>200}
    imageOptions=imageOptions.merge(options)
    imageData=trimBlob(instancedata.data_binary)
    myImage=Magick::Image.from_blob(imageData)
    myImage=myImage[0]
    paletteImg=Magick::Image.read("public/images/Rainbow.png")
    myImage=myImage.clut_channel(paletteImg[0])
    myImage=myImage.resize_to_fit(imageOptions[:width],imageOptions[:height])
    myImage.write "public/images/tmp/image"+instancedata.id.to_s+".png"
  end
end
