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
    plotOptions={:width=>200, :height=>100, :imagetype=> "png"}
    plotOptions=plotOptions.merge(options)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.terminal "#{plotOptions[:imagetype]} tiny size #{plotOptions[:width]},#{plotOptions[:height]}"
        plot.output "public/images/tmp/test"+fileId.to_s+".#{plotOptions[:imagetype]}"
        plot.data << Gnuplot::DataSet.new( xyData ) do |ds|
          ds.with = "lines"
          ds.notitle
        end
      end
    end
  end

  def generate2dPlot(instancedata, options = {})
    xyData=convert2D(instancedata.data_binary)
    generatePlot(xyData, instancedata.id,options)
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
