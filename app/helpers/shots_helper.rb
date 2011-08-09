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
        displayValueSetShort(instanceValueSet)
      end
    end
  end
  def displayAttachmentLabel(shot)
    if shot.attachments.count!=0
      image_tag 'paperclip.png'
    end
  end
end
