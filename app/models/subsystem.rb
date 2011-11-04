# This model represents a subsystem of the laser such as +PreAmplifier+ or
# +MainAmplifier+. An Instance refers to it. Subsystems are normally used as
# filter criteria for an Instance. New entries are automatically added by the
# LabVIEW interface if a new subsystem is found by the control system.
#
# == Schema Information
#
# Table name: subsystems
#
#  id         :integer(38)     not null, primary key
#  name       :string(255)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
# == Validations
# The following validations exist:
# * A subsystem cannot be deleted if an Instance still refers to it.
# * The subsystem name must be unique.
# * The maximum length of the name must be 255 characters.
class Subsystem < ActiveRecord::Base
  attr_accessible :name

  has_many :instances

  validates :name, :presence => true,
                   :length => { :maximum => 255 },
                   :uniqueness => { :case_sensitive => false}

  before_destroy :check_if_instances_associated
# Return the name of the subsystem. This function was added to simplify views.
  def to_s
    return self.name
  end

private
  def check_if_instances_associated
    if (!instances.empty?)
      errors.add(:base, "cannot be deleted with instances associated")
      return false
    else
      return true
    end
  end
end

