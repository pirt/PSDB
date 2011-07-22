require "gnuplot"

module InstancevaluesetsHelper
  def displayParameter(instanceValueSet,parameterName,options={})
    parameterData=instanceValueSet.instancevalues.find_by_name(parameterName)
    if (parameterData.nil?)
      return "parameter <#{parameterName}> not found"
    else
      render "instancevalues/instancevalue", { :instancevalue => parameterData, :options => options}
    end
  end
  def generateSeriesPlot(xyData, fileId, options={})
    plotOptions={:width=>200, :height=>100, :imagetype=> "png", :xlabel=> "", :ylabel=> ""}
    plotOptions=plotOptions.merge(options)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.terminal "#{plotOptions[:imagetype]} small enhanced size #{plotOptions[:width]},#{plotOptions[:height]}"
        plot.output "public/images/tmp/series"+fileId.to_s+".#{plotOptions[:imagetype]}"
        plot.ylabel plotOptions[:ylabel]
        plot.xlabel plotOptions[:xlabel]
        plot.boxwidth 0.5
        plot.grid ""
        plot.data << Gnuplot::DataSet.new( xyData ) do |ds|
          ds.with = "boxes fill solid 0.5"
          ds.notitle
        end
      end
    end
  end
end
