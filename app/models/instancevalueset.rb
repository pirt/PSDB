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
      if (stringData.nil?)
        return nil
      end
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
    foundAxes=Set.new
    parameters=self.instancevalues.select(:name)
    parameters.each do |parameter|
      axisName=parameter.name.split(":")[0]
      if (!axisName.empty?)
        foundAxes.add(axisName)
      end
    end
    return foundAxes
  end
  def getVacuumChannels
    foundChannels=Set.new
    parameters=self.instancevalues.select(:name)
    parameters.each do |parameter|
      parameterList=parameter.name.split(":")
      channelNumber=parameterList[0]
      channelName=parameterList[1]
      channel=""
      if channelNumber.present?
        channel += channelNumber+":"
      end
      if channelName.present?
        channel += channelName
      end
      if channel.present?
        foundChannels.add(channel)
      end
    end
    return foundChannels
  end
  def generateMultiPlot(plotParameterNames,options={})
    plotOptions={:width=>200, :height=>100, :imagetype=> "png"}
    plotOptions=plotOptions.merge(options)
    fileName=Rails.root.to_s+"/public/tempSeriesPlot.png"
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
      returnImage=Magick::Image.read(Rails.root.to_s+"/public/tempSeriesPlot.png")[0]
      return returnImage
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
