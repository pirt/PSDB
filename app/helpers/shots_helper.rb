##
# This module contains helper functions that can be used for displaying shot information
# (e.g. for the table of shots#index).
module ShotsHelper
##
# Display a short view of an instancevalueset from an instance of a given
# name out of an array of instancevaluesets and handle possible error cases.
  def displayShotInstance(instanceValueSets,instanceName,options={})
    instanceId=Instance.find_by_name(instanceName)
    if (instanceId.nil?)
      return "unknown"
    else
      instanceValueSet=instanceValueSets.find_by_instance_id(instanceId)
      if (instanceValueSet.nil?)
        return "?"
      else
        displayValueSetShort(instanceValueSet,options)
      end
    end
  end
##
# Display an icon if a shot object has one or more attachments.
#
# shot:: the shot object
  def displayAttachmentLabel(shot)
    if shot.attachments.present?
      image_tag 'paperclip.png'
    end
  end
end
