#
# This class represents a shot in the database.
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
class Shot < ActiveRecord::Base
  attr_accessible :description, :experiment_id, :shottype_id, :status

  belongs_to :experiment
  belongs_to :shottype
  has_many :instancevaluesets
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

