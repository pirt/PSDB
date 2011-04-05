# == Schema Information
# Schema version: 20110216123146
#
# Table name: instances
#
#  id           :integer(38)     not null, primary key
#  classtype_id :integer(38)     not null
#  subsystem_id :integer(38)     not null
#  name         :string(255)     not null
#  version      :integer(38)     not null
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class Instance < ActiveRecord::Base
  attr_accessible :name, :classtype_id, :subsystem_id, :version

  belongs_to :classtype
  belongs_to :subsystem

  has_many :instancedatas

  validates :name, :presence => true,
                   :length => { :maximum => 255 },
                   :uniqueness => { :case_sensitive => false, :scope => [:version]}

  validates :version, :presence => true

  validates :classtype, :presence => true
  validates :subsystem, :presence => true
end
