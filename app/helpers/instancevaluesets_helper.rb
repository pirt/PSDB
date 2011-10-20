require "gnuplot"

module InstancevaluesetsHelper
  def displayParameter(instanceValueSet,parameterName,options={})
    parameterData=instanceValueSet.instancevalues.find_by_name(parameterName)
    if (parameterData.nil?)
      if options[:iconIfNotFound]==true
        return image_tag "icon_ERROR.png", {:style=>"vertical-align:middle"}
      else
        return "parameter <#{parameterName}> not found"
      end
    else
      displayValue(parameterData,options)
    end
  end
  def displayValueSetShort(instanceValueSet)
    classType=instanceValueSet.instance.classtype.name
    valueSetVersion=instanceValueSet.version
    partialName="/instancevaluesets/#{classType}/short_#{valueSetVersion}"
    partialFileName=::Rails.root.to_s+"/app/views/instancevaluesets/"+classType+
      "/_short_"+valueSetVersion.to_s+".html.erb"
    if !File.exists?(partialFileName)
      return "no view defined"
    else
      render partialName, :instanceValueSet => instanceValueSet
    end
  end
  def generateSeriesPlot(xyData, options={})
    plotOptions={:width=>200, :height=>100, :imagetype=> "png", :xlabel=> "", :ylabel=> ""}
    plotOptions=plotOptions.merge(options)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.terminal "#{plotOptions[:imagetype]} small enhanced size #{plotOptions[:width]},#{plotOptions[:height]} crop"
        plot.output Rails.root.to_s+"/public/series.png"
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
