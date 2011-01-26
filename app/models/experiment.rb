# == Schema Information
# Schema version: 20110121104008
#
# Table name: experiments
#
#  id          :integer(4)      not null, primary key
#  name        :string(30)      not null
#  description :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Experiment < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :shots
  has_many :experiment_attachments

  validates :name, :presence => true,
                   :length => { :maximum => 30 },
                   :uniqueness => { :case_sensitive => false }

  validates :description, :presence => true,
                          :length => { :maximum => 255 }
end
