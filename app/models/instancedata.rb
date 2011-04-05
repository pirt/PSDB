# == Schema Information
# Schema version: 20110405192247
#
# Table name: instancedatas
#
#  id                 :integer(38)     not null, primary key
#  instancedataset_id :integer(38)     not null
#  datatype_id        :integer(38)     not null
#  name               :string(256)     not null
#  data_numeric       :decimal(, )
#  data_string        :string(255)
#  data_binary        :binary
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

class Instancedata < ActiveRecord::Base
  attr_accessible :instancedataset_id, :name, :data_numeric, :data_binary, :data_string, :data_binary, 
                  :datatype_id

  belongs_to :instancedataset
  belongs_to :datatype 
  
  validates :name, :presence => true,
                   :length => { :maximum => 255 }

  #validates_presence_of_at_least_one_field :data_numeric, :data_string, :data_binary

  validates :datatype, :presence => true
end
