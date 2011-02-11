# == Schema Information
# Schema version: 20110209132953
#
# Table name: shots
#
#  id            :integer(38)     not null, primary key
#  comment       :string(255)
#  experiment_id :integer(38)     not null
#  shottype_id   :integer(38)     not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Shot < ActiveRecord::Base
  attr_accessible :comment, :experiment_id, :shottype_id

  belongs_to :experiment
  belongs_to :shottype
  has_many :instancedatas
  has_many :attachments, :as => :attachable, :dependent => :destroy 

  validates :comment, :length => { :maximum => 255 }
 
  # check for reference to an existing experiment / shottype
  # this also checks the presence of experiment_id and shottype_id

  validates :experiment, :presence => true
  # validates :shottype, :presence => true
end
