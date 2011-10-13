# == Schema Information
#
# Table name: classtypes
#
#  id         :integer(38)     not null, primary key
#  name       :string(256)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Classtype < ActiveRecord::Base
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

