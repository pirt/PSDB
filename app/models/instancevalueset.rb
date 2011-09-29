# == Schema Information
#
# Table name: instancevaluesets
#
#  id          :integer(38)     not null, primary key
#  shot_id     :integer(38)     not null
#  instance_id :integer(38)     not null
#  version     :integer(38)     not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'gnuplot'

class Instancevalueset < ActiveRecord::Base
  attr_accessible :shot_id, :instance_id, :version
  belongs_to :shot
  belongs_to :instance
  has_many :instancevalues

  validates :version, :presence => true

  validates :shot, :presence => true
  validates :instance, :presence => true

  def getStringParameter(parameterName,options={})
    
    parameterData=self.instancevalues.find_by_name(parameterName)
    if (parameterData.nil?)
      return nil
    else
      if parameterData.datatype.name!="string"
        return nil
      end
      stringData=parameterData.data_string
      if options[:strip]==true
        stringData.strip!
      end
      if options[:upcase]==true
        stringData.upcase!
      end
      return stringData
    end
  end
  def getBooleanParameter(parameterName,options={})
    
    parameterData=self.instancevalues.find_by_name(parameterName)
    if (parameterData.nil?)
      return nil
    else
      if parameterData.datatype.name!="boolean"
        return nil
      end
      result=parameterData.data_numeric>0 ? true : false
      return result
    end
  end
  def getNumericParameter(parameterName,options={})
    
    parameterData=self.instancevalues.find_by_name(parameterName)
    if (parameterData.nil?)
      return nil
    else
      if parameterData.datatype.name!="numeric"
        return nil
      end
      return parameterData.data_numeric
    end
  end
  def getAxesNumbers
    searchPattern=/^Axis[ ]*([0-5]):*/
    foundAxes=Set.new
    parameters=self.instancevalues.select(:name)
    parameters.each do |parameter|
      axisName=parameter.name
      searchResult=searchPattern.match(axisName)
      if (!searchResult.nil?)
        axisNr=searchResult[1].to_i
        foundAxes.add(axisNr)
      end
    end
    return foundAxes
  end
  def generatePlot(plotParameterNames,plotNr,options={})
    plotOptions={:width=>200, :height=>100, :imagetype=> "png"}
    plotOptions=plotOptions.merge(options)
    fileName="public/images/tmp/plotseries"+self.id.to_s+"_"+plotNr.to_s+".#{plotOptions[:imagetype]}"
    dataAvailable=false
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.terminal "#{plotOptions[:imagetype]} small size #{plotOptions[:width]},#{plotOptions[:height]}"
        plot.output fileName
        if (plotParameterNames.length!=0)
          instanceValue=self.instancevalues.find_by_name(plotParameterNames[0])
          if instanceValue
            axisDescriptions=instanceValue.generatePlotAxisDescriptions()
            plot.xlabel axisDescriptions[:xlabel]
            plot.ylabel axisDescriptions[:ylabel]
          end
        end
        plotParameterNames.each do |plotParameterName|
          plotData=getPlotDataSet(plotParameterName)
          if !plotData.nil?
            plot.data << plotData
            dataAvailable=true
          end
        end
      end
    end
    if dataAvailable
      return fileName.sub("public/images/","")
    else
      return ""
    end
  end

  def getPlotDataSet(parameterName,options={})
    instanceValue=self.instancevalues.find_by_name(parameterName)
    if (instanceValue.nil?)
      return nil
    else
      plotDataSet=instanceValue.generatePlotDataSet()
      return plotDataSet
    end
  end
end
