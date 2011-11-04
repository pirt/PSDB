# This model represents a data type such as numeric, image or 2dData.
# The data type is referenced by an Instancevalue and is used to determine
# the right partial to be used to display the data (e.g. display a string or
# generate an image and show it...).
#
# == Schema Information
#
# Table name: datatypes
#
#  id         :integer(38)     not null, primary key
#  name       :string(30)      not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
# == Validations
# A data type cannot be deleted if an Instancevalue refers to it.
class Datatype < ActiveRecord::Base
  attr_accessible :name

  has_many :instancevalues

  validates :name, :presence => true,
                   :length => { :maximum => 30 },
                   :uniqueness => { :case_sensitive => false }

  before_destroy :check_if_instancevalues_associated

# Return the name of the data type. This is defined in order to simplify views.
  def to_s
    return self.name
  end

private
  def check_if_instancevalues_associated
    if (!instancevalues.empty?)
      errors.add(:base, "cannot be deleted with instancevalues associated")
      return false
    else
      return true
    end
  end
end
