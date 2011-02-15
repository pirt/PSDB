# == Schema Information
# Schema version: 20110215070042
#
# Table name: datatypes
#
#  id   :integer(38)     not null, primary key
#  name :string(30)      not null
#

class Datatype < ActiveRecord::Base
  attr_accessible :name

  has_many :instancedatas

  validates :name, :presence => true,
                   :length => { :maximum => 30 },
                   :uniqueness => { :case_sensitive => false }
end
