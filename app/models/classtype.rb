# == Schema Information
# Schema version: 20110216123146
#
# Table name: classtypes
#
#  id         :integer(38)     not null, primary key
#  name       :string(256)     not null
#  version    :integer(38)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Classtype < ActiveRecord::Base
  attr_accessible :name, :version

  has_many :instances

  validates :name, :presence => true,
                   :length => { :maximum => 255 },
                   :uniqueness => { :case_sensitive => false, :scope => [:version]}

  validates :version, :presence => true

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
