class Shottype < ActiveRecord::Base
  attr_accessible :name

  has_many :shots

  validates :name, :presence => true,
                   :uniqueness => { :case_sensitive => false },
                   :length => { :maximum => 30 }
end
