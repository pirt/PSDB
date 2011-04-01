# == Schema Information
# Schema version: 20110216123146
#
# Table name: datatypes
#
#  id         :integer(38)     not null, primary key
#  name       :string(30)      not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Datatype < ActiveRecord::Base
  attr_accessible :name

  has_many :instancedatas

  validates :name, :presence => true,
                   :length => { :maximum => 30 },
                   :uniqueness => { :case_sensitive => false }

  before_destroy :check_if_instancedatas_associated

  def check_if_instancedatas_associated
    if (!instancedatas.empty?)
      errors.add(:base, "cannot be deleted with instancedatas associated")
      return false
    else
      return true
    end
  end
end
