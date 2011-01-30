# == Schema Information
# Schema version: 20110127161802
#
# Table name: experiments
#
#  id          :integer(38)     not null, primary key
#  name        :string(30)      not null
#  description :string(255)     not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Experiment < ActiveRecord::Base
  attr_accessible :name, :description

  # paginate results
  cattr_reader :per_page
  @@per_page = 15

  has_many :shots
  has_many :experiment_attachments
  has_many :attachments, :through => :experiment_attachments, :uniq => true 

  validates :name, :presence => true,
                   :length => { :maximum => 30 },
                   :uniqueness => { :case_sensitive => false }

  validates :description, :presence => true,
                          :length => { :maximum => 255 }
end
