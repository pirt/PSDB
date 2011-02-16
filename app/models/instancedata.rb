# == Schema Information
# Schema version: 20110214103313
#
# Table name: instancedatas
#
#  id           :integer(38)     not null, primary key
#  shot_id      :integer(38)     not null
#  instance_id  :integer(38)     not null
#  datatype_id  :integer(38)     not null
#  name         :string(255)     not null
#  data_numeric :decimal(, )
#  data_string  :string(255)
#  data_binary  :binary
#  created_at   :datetime
#  updated_at   :datetime
#

class Instancedata < ActiveRecord::Base
  attr_accessible :name, :data_numeric, :data_binary, :data_string, :data_binary, 
                  :shot_id, :datatype_id, :instance_id

  belongs_to :shot
  belongs_to :instance
  belongs_to :datatype 
  
  validates :name, :presence => true,
                   :length => { :maximum => 255 }

  #validates_presence_of_at_least_one_field :data_numeric, :data_string, :data_binary

  validates :shot, :presence => true
  #validates :instance, :presence => true
  validates :datatype, :presence => true
end
