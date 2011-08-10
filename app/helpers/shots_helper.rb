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
    if shot.attachments.present?
      image_tag 'paperclip.png'
    end
  end
  def displayShotLine(shot)
    shotId=shot.id
    partialFileName=::Rails.root.to_s+"/public/cache/shotline"+shotId.to_s+".html"
    if !File.exists?(partialFileName)
      renderString=render shot
      File.open(partialFileName, 'w') {|f| f.write(renderString) }
    end
    render :file => partialFileName
  end
  
end
