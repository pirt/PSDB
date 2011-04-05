# == Schema Information
# Schema version: 20110405192247
#
# Table name: instancedatasets
#
#  id          :integer(38)     not null, primary key
#  shot_id     :integer(38)     not null
#  instance_id :integer(38)     not null
#  version     :integer(38)     not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Instancedataset < ActiveRecord::Base
  attr_accessible :shot_id, :instance_id, :version 
  belongs_to :shot
  belongs_to :instance
  has_many :instancedatas

  validates :version, :presence => true

  validates :shot, :presence => true
  validates :instance, :presence => true
end
