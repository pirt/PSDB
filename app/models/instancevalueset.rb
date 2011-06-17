# == Schema Information
# Schema version: 20110405192247
#
# Table name: instancevaluesets
#
#  id          :integer(38)     not null, primary key
#  shot_id     :integer(38)     not null
#  instance_id :integer(38)     not null
#  version     :integer(38)     not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Instancevalueset < ActiveRecord::Base
  attr_accessible :shot_id, :instance_id, :version 
  belongs_to :shot
  belongs_to :instance
  has_many :instancevalues

  validates :version, :presence => true

  validates :shot, :presence => true
  validates :instance, :presence => true

  def getStringParameter(parameterName,options={})
    parameterData=self.instancevalues.find_by_name(parameterName)
    if (parameterData.nil?)
      return ""
    else
      if options[:upcase]==true
        return parameterData.data_string.upcase
      else
        return parameterData.data_string
      end
    end
  end
end
