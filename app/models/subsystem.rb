# == Schema Information
# Schema version: 20110216123146
#
# Table name: subsystems
#
#  id   :integer(38)     not null, primary key
#  name :string(255)     not null
#

class Subsystem < ActiveRecord::Base
  attr_accessible :name

  has_many :instances

  validates :name, :presence => true,
                   :length => { :maximum => 255 },
                   :uniqueness => { :case_sensitive => false}

  before_destroy :check_if_instances_associated
  
  def check_if_instances_associated
    if (!instances.empty?)
      errors.add(:base, "cannot be deleted with instances associated")
      return false
    else
      return true
    end
  end
end
