require 'gnuplot'
require 'tempfile'
# This model represents a set of measurement data (represented by Instancevalue)
# of a particular Instance for a certain Shot. In addition this model contains a
# version number which is used to identify a certain API version of the underlying
# Instancevalues. It is set by the LabVIEW interface. The web applicataion uses this
# number to correctly display / interpret the measurement data in the class-specific
# views (e.g. found in <tt>views/instancevaluesets/<classtype>/_short_<version number>.html.erb</tt>).
#
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
# == Validations
# The following validations exist:
# * It must refer to a valid shot id.
# * It must refer to a valid instance id.

class Instancevalueset < ActiveRecord::Base
  attr_accessible :shot_id, :instance_id, :version
  belongs_to :shot
  belongs_to :instance
  has_many :instancevalues

  validates :version, :presence => true

  validates :shot, :presence => true
  validates :instance, :presence => true
# Return a string value from an Instancevalue of a given name which is associated to
# the Instancevalueset. If the name is not found or the Instancevalue of with this name is
# not a string value, nil is returned.
# parameterName:: name of the parameter (= name field of the Instancevalue) to be returned
# options:: 
# [:strip=>true] remove leading and trailing whitespaces of the string.
# [:upcase=>true] return the upcase version of the string.
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
# Return a boolean value from an Instancevalue of a given name which is associated to
# the Instancevalueset. If the name is not found or the Instancevalue of with this name is
# not a boolean value, nil is returned.
# parameterName:: name of the parameter (= name field of the Instancevalue) to be returned
# options:: currently none
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
# Return a numeric value from an Instancevalue of a given name which is associated to
# the Instancevalueset. If the name is not found or the Instancevalue of with this name is
# not a numeric value, nil is returned.
# parameterName:: name of the parameter (= name field of the Instancevalue) to be returned
# options:: currently none
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
# Helper function for handling instances of the class type PH_Sixpack.
#
# The parameter names of of a Sixpack have a syntax such as <tt>Axis 0:Position</tt>.
# This function looks for all parameter names and returns a list of found axes such as
# <tt>["Axis 1","Axis 3","Axis4"]</tt>.
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
# Helper function fo handling instances of the class type PH_VacuumControl.
#
# The parameter names of of a VacuumControl have a syntax such as <tt>Channel 0:<Name>:<Parameter></tt>.
# This function looks for all parameter names and returns a list of found channels such as
# <tt>["Channel 1:Telescope 1","Channel 4:PA Exit"]</tt>.
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
  def analyzePulsedPowerStatus
    currentState=:unknown
    voltage=getNumericParameter("Voltage")
    timeout=getStringParameter("Timeout",:upcase=>true)
    machineState=getStringParameter("Machine State",:upcase=>true)
    if voltage==-1.0 and timeout=="NONE" and machineState=="STAND BY"
      currentState=:off
    elsif voltage!=-1.0 and timeout=="NONE" and machineState=="WAIT FOR SHOT CMD"
      currentState=:on
    elsif voltage!=-1.0 and timeout=="NONE" and machineState=="STAND BY"
      currentState=:error
    elsif voltage!=-1.0 and timeout!="NONE" and machineState=="STAND BY"
      currentState=:error
    elsif voltage!=-1.0 and machineState!="STAND BY"
      currentState=:error
    end
    return currentState
  end
  def generateMultiPlot(plotParameterNames,options={})
    tempFile=Tempfile.new(['multiplotImage','.png'])
    plotOptions={:width=>200, :height=>100, :imagetype=> "png"}
    plotOptions=plotOptions.merge(options)
    dataAvailable=false
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.terminal "#{plotOptions[:imagetype]} small size #{plotOptions[:width]},#{plotOptions[:height]}"
        plot.output tempFile.path
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
    tempFile.rewind
    if dataAvailable
      returnImage=Magick::Image.read(tempFile.path)[0]
      tempFile.close
      tempFile.unlink
      return returnImage
    else
      tempFile.close
      tempFile.unlink
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
