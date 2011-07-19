# == Schema Information
#
# Table name: instances
#
#  id           :integer(38)     not null, primary key
#  classtype_id :integer(38)     not null
#  subsystem_id :integer(38)     not null
#  name         :string(255)     not null
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class Instance < ActiveRecord::Base
  attr_accessible :name, :classtype_id, :subsystem_id
  belongs_to :classtype
  belongs_to :subsystem

  has_many :instancevaluesets

  validates :name, :presence => true,
                   :length => { :maximum => 255 },
                   :uniqueness => { :case_sensitive => false}

  validates :classtype, :presence => true
  validates :subsystem, :presence => true

  def viewExists?(interfaceVersion,detailed=false)
    viewType= detailed ? "/_detailed_" : "/_short_"
    viewFileName=::Rails.root.to_s+"/app/views/instancevaluesets/"+
      self.classtype.name+viewType+interfaceVersion.to_s+".html.erb"
    return File.exists?(viewFileName)
  end

  def interfaceVersionInfo
    interfaceVersions=self.instancevaluesets.select(:version).group(:version)
    interfaceInfo=[]
    interfaceVersions.each do |interfaceVersion|
      shotId=self.instancevaluesets.where(:version => interfaceVersion.version).minimum(:shot_id)
      shotDate=Shot.find(shotId).created_at
      interfaceInfo << {:version => interfaceVersion.version, :shot_id => shotId, :shotDate => shotDate}
    end
    return interfaceInfo
  end
end
