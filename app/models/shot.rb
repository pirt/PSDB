# This class represents a shot in the database.
#
# *Note:* The *status* field has a project-specific meaning. For PHELIX
# the status field is bitwise interpreted:
#  bit 0:: true if shot was analyzed (defaults to false)
#  bit 1:: true if failed shot because of machine error (pulsed power)
#  bit 2:: true if failed shot because of handling error (e.g. forgotten shutter)
#
# == Schema Information
#
# Table name: shots
#
#  id            :integer(38)     not null, primary key
#  description   :string(255)
#  experiment_id :integer(38)     not null
#  shottype_id   :integer(38)     not null
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  status        :integer(38)
#
# == Validations
# The following validations exist:
# * It cannot be deleted if an Instancevalueset refers to it.
# * The description field must not exceed 255 characters.
# * It must refer to a valid experiment id.
# * It must refer to a valid shot type id.
# *Note:* It is acutally not forseen to delete a shot. However if a shot is deleted all
# file attachments refering to it are also deleted for consistency.
class Shot < ActiveRecord::Base
  attr_accessible :description, :experiment_id, :shottype_id, :status

  belongs_to :experiment
  belongs_to :shottype
  has_many :instancevaluesets
  has_many :instances, :through => :instancevaluesets
  has_many :subsystems, :through => :instances
  has_many :attachments, :as => :attachable, :dependent => :destroy

  validates :description, :length => { :maximum => 255 }

  # check for reference to an existing experiment / shottype
  # this also checks the presence of experiment_id and shottype_id

  validates :experiment, :presence => true
  validates :shottype, :presence => true

  before_destroy :check_if_instancevaluesets_associated

##
# Return list of subsystems whose instances have written instancevaluesets which reference
# this shot. This means a list of subsystems who participated during the measurement.
  def involvedSubsystems
    availableInstanceValueSets=self.instancevaluesets
    availableInstanceValueSets.joins(:instance => :subsystem).select("subsystems.name").group("subsystems.name")
  end
##
# Return list of class types whose instances have written instancevaluesets which reference
# this shot. This means a list of class types who participated during the measurement.
  def involvedClasstypes
    availableInstanceValueSets=self.instancevaluesets
    availableInstanceValueSets.joins(:instance => :classtype).select("classtypes.name").group("classtypes.name")
  end
##
# Return shot status. Check the "Shot passed?" field of the PH_Sequencer instance.
# The functions returns the string "failedshot" if "Shot passed?==false" and an empty string
# otherwise
#
# shot:: the shot object
  def getShotStatus
    shotStatus=""
    if (self.status & 1)== 1
      shotStatus="failedshot"
    else
      instanceId=Instance.find_by_name("PHELIX_Sequencer_1")
      if instanceId
        sequencerValueSet=self.instancevaluesets.find_by_instance_id(instanceId)
        if sequencerValueSet.present?
          shotStatus=sequencerValueSet.getBooleanParameter("Shot passed?")==false ? "failedshot" : ""
        end
      end
    end
    return shotStatus
  end

  def analyzePHELIX(options={})
    if ((options[:nocache]==true) or (self.status.nil?) or ((self.status & 1) == 0))
      machineError=false
      instanceNames=["PPPA_19mm_1_PU","PPPA_19mm_2_PU","PPPA_45mm_MAIN_PU",
                     "PPMA_PU1","PPMA_PU2","PPMA_PU3","PPMA_PU4","PPMA_PU5"]
      instanceValueSets=self.instancevaluesets
      instanceNames.each do |instanceName|
        instanceId=Instance.find_by_name(instanceName)
        if instanceId.present?
          instanceValueSet=instanceValueSets.find_by_instance_id(instanceId)
          if instanceValueSet.present?
            if (instanceValueSet.analyzePulsedPowerStatus==:error)
              machineError=true
            end
          end
        end
      end
      self.status |= 1 # set "analyzed" bit
      if machineError
        self.status |= 2
      else
        self.status &= ~2
      end
      self.save!
    end
    return (self.status & 2) != 0
  end
private
  def check_if_instancevaluesets_associated
    if (!instancevaluesets.empty?)
      errors.add(:base, "cannot be deleted with instancevaluesets associated")
      return false
    else
      return true
    end
  end
end

