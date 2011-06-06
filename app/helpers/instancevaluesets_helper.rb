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
end
