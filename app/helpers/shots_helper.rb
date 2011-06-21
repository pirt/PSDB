module ShotsHelper
  def displayShotInstance(instanceValueSets,instanceName,options={})
    instanceId=Instance.find_by_name(instanceName)
    if (instanceId.nil?)
      return "unknown"
    else
      instanceValueSet=instanceValueSets.find_by_instance_id(instanceId)
      if (instanceValueSet.nil?)
        return "?"
      else
        render "instancevaluesets/instancevalueset_short", :instanceValueSet => instanceValueSet
      end
    end
  end
end
