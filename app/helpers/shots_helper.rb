module ShotsHelper
  def displayShotInstance(instanceDataSets,instanceName,options={})
    # instanceDataSets=shot.instancedatasets
    instanceId=Instance.find_by_name(instanceName)
    if (instanceId.nil?)
      return "unknown"
    else
      instanceDataSet=instanceDataSets.find_by_instance_id(instanceId)
      if (instanceDataSet.nil?)
        return "?"
      else
        render :partial => "instancedatasets/instancedataset_short", 
                            :locals => { :instanceDataSet => instanceDataSet}
      end
    end
  end
end
