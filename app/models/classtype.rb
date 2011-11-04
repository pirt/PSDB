# This model represents a class type (= device type of an Instance) such as
# +PH_gentecPowermeter+ or +PH_Sixpack+. The class type determines which view
# will be used to display measurement data. Furthermore the class type is used
# as filter criteria for listing instances.
#
# == Schema Information
#
# Table name: classtypes
#
#  id         :integer(38)     not null, primary key
#  name       :string(256)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
# == Validations
# The following validations exist:
# * It must have a unique name.
# * The name must not exceed 255 characters.
# * It cannot be deleted if an Instance refers to it.
#
class Classtype < ActiveRecord::Base
  attr_accessible :name

  has_many :instances

  validates :name, :presence => true,
                   :length => { :maximum => 255 },
                   :uniqueness => { :case_sensitive => false}

  before_destroy :check_if_instances_associated
# Return name of class type. This function was added to simplify views.
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
