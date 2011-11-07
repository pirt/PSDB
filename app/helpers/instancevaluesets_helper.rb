require "gnuplot"
# This module provides helper functions for displaying measurment data of an Instance (which is represented by an
# Instancevalueset).
module InstancevaluesetsHelper
# Display a parameter of a given Instancevalueset.
#
# If an Instancevalue with the correct name belonging to the Instancevalueset is found the corresponding partial
# is called. Otherwise an error message (or likewise an error icon) ist displayed.
# instanceValueSet:: Instancevalueset to display from
# parameterName:: name of the Instancevalue to be displayed
# options::
# All options are forwarded the helper function InstancevaluesHelper::displayValue.
# In addtion the options :iconIfNotFound is defined which shows an error icon instead of an error message
# if the Instancevalue with the given name was not found.
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
# Display a short view representation of an Instancevalueset.
#
# This functions calls the corresponding partial depending on the class type of the instance following
# the naming scheme <tt>/app/views/instancevaluesets/<classType>/_short_<versionNumber>.html.erb</tt>
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
# Generate an xy plot from an array of data sets.
#
# In contrast to Instancevalue::generatePlot this function accepts an array of xy data to be plotted as
# a set of lines in one graph.
# xyData:: array of xy data
# options::
# [:width] width the the plot in pixels (default is 200)
# [:height] height of the plot in pixels (default is 100)
# [:imagetype] type of the generated image file (defaults to "png")
# [:xlabel] label of the x axis (defaults to "")
# [:ylabel] lable of the y axis (defaults to "")
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
