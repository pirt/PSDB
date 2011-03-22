module InstancesHelper
  def displayParameter(instancedatas,parameterName,options={})
    parameterData=instancedatas.find_by_name(parameterName)
    if (parameterData.nil?)
      return "parameter <#{parameterName}> not found"
    else
      render :partial => "instancedatas/instancedata", 
                 :locals => { :instancedata => parameterData, :options => options}
    end
  end
end
