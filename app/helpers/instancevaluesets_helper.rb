require "gnuplot"

module InstancevaluesetsHelper
  def displayParameter(instancevalues,parameterName,options={})
    parameterData=instancevalues.find_by_name(parameterName)
    if (parameterData.nil?)
      return "parameter <#{parameterName}> not found"
    else
      render :partial => "instancevalues/instancevalue", 
                 :locals => { :instancevalue => parameterData, :options => options}
    end
  end
  def getStringParameter(instancevalues,parameterName,options={})
    parameterData=instancevalues.find_by_name(parameterName)
    if (parameterData.nil?)
      return ""
    else
      if options[:upcase]==true
        return parameterData.data_string.upcase
      else
        return parameterData.data_string
      end
    end
  end
  def generatePlot(xyData, fileId, options={})
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
