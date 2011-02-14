# == Schema Information
# Schema version: 20110214103313
#
# Table name: shottypes
#
#  id   :integer(38)     not null, primary key
#  name :string(30)      not null
#

class Shottype < ActiveRecord::Base
  attr_accessible :name

  has_many :shots

  validates :name, :presence => true,
                   :uniqueness => { :case_sensitive => false },
                   :length => { :maximum => 30 }
end
