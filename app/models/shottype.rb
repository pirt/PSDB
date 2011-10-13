# == Schema Information
#
# Table name: shottypes
#
#  id         :integer(38)     not null, primary key
#  name       :string(30)      not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Shottype < ActiveRecord::Base
  attr_accessible :name

  has_many :shots

  validates :name, :presence => true,
                   :uniqueness => { :case_sensitive => false },
                   :length => { :maximum => 30 }

  before_destroy :check_if_shots_associated

  def to_s
    return self.name
  end

private
  def check_if_shots_associated
    if (!shots.empty?)
      errors.add(:base, "cannot be deleted with shots associated")
      return false
    else
      return true
    end
  end
end

