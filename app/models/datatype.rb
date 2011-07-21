# == Schema Information
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

  has_many :instancevalues

  validates :name, :presence => true,
                   :length => { :maximum => 30 },
                   :uniqueness => { :case_sensitive => false }

  before_destroy :check_if_instancevalues_associated

  def check_if_instancevalues_associated
    if (!instancevalues.empty?)
      errors.add(:base, "cannot be deleted with instancevalues associated")
      return false
    else
      return true
    end
  end
  def to_s
    return self.name
  end
end

