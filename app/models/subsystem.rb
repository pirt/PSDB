# == Schema Information
#
# Table name: subsystems
#
#  id         :integer(38)     not null, primary key
#  name       :string(255)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
# This model represents a subsystem of the laser such as <tt>PreAmplifier</tt> or
# <tt>MainAmplifier</tt>. An Instance refers to it. Subsystems are normally used as
# filter creteria for an Instance.
# == Validations
# A subsystem cannot be deleted if an Instance still refers to it.
class Subsystem < ActiveRecord::Base
  attr_accessible :name

  has_many :instances

  validates :name, :presence => true,
                   :length => { :maximum => 255 },
                   :uniqueness => { :case_sensitive => false}

  before_destroy :check_if_instances_associated

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

