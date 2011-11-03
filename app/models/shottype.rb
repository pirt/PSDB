# == Schema Information
#
# Table name: shottypes
#
#  id         :integer(38)     not null, primary key
#  name       :string(30)      not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
# This model represents a shot type. It is referenced by a Shot. Currently the following shot types
# are defined:
#   1. experiment shot
#   2. test shot
#   3. snap shot
#   4. other
#
# Note that these shot types are set once in the database using the command <tt>rake db:seed</tt>. The LabVIEW
# interface relies on the id values! It is possible to extend it but one should not mix them up.
# == Validations
# A shot type cannot be deleted if a Shot still refers to it.
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

