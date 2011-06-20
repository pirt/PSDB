# == Schema Information
# Schema version: 20110405192247
#
# Table name: instancevalues
#
#  id                 :integer(38)     not null, primary key
#  instancevalueset_id :integer(38)     not null
#  datatype_id        :integer(38)     not null
#  name               :string(256)     not null
#  data_numeric       :decimal(, )
#  data_string        :string(255)
#  data_binary        :binary
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

class Instancevalue < ActiveRecord::Base
  attr_accessible :instancevalueset_id, :name, :data_numeric, :data_binary, :data_string, :data_binary,
                  :datatype_id

  belongs_to :instancevalueset
  belongs_to :datatype

  validates :name, :presence => true,
                   :length => { :maximum => 255 }

  #validates_presence_of_at_least_one_field :data_numeric, :data_string, :data_binary

  validates :datatype, :presence => true

  def export2dData
    plotBlob=self.data_binary
    plotBlob=plotBlob[4..-1]
    splitData=plotBlob.split(",")
    nrOfData=splitData.length
    axisDescription=self.data_string
    txtData=""
    if (axisDescription)
      descriptionParts=axisDescription.split(",")
      if (descriptionParts[0])
        txtData+=descriptionParts[0]
      end
        if (descriptionParts[2])
        txtData+=" ["+descriptionParts[2]+"]"
      end
      txtData+="\t"
      if (descriptionParts[1])
        txtData+=descriptionParts[1]
      end
      if (descriptionParts[3])
        txtData+=" ["+descriptionParts[3]+"]"
      end
      txtData+="\n"
    end

    (0..nrOfData-1).step(2) do |dataIndex|
      txtData+=splitData[dataIndex]
      txtData+="\t"
      txtData+=splitData[dataIndex+1]
      txtData+="\n"
    end
    return txtData
  end
end
