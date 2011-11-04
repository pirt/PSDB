# This class represents an instance which is most cases (but not necessarily!) a 
# physical device such as +PA_Nearfield_Input_Cam+. An Instance belongs to a Subsystem
# (e.g. +PreAmp+) and has a certain Classtype (e.g. +PH_IEEE1394_Cam+).
#
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
# == Validations
# The following validations exist:
# * The instance name must be unique.
# * The instance name must not exceed 255 characters.
# * It must refer to a valid classtype
# * It must refer to a valid subsystem.
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
# Check if a view for the given instance and the given interface version exists.
# Returns true if successful and false otherwise.
# interfaceVersion:: 
# check for a view with this API version number. This version number is part of
# the view's filename (e.g. <tt>views/instancevaluesets/<classname>/_short_<interfaceVersion>.html.erb</tt>)
# detailed:: 
# if false it checks whether if a short view exists otherwise it checks for the existence of
# a detailed view.
  def viewExists?(interfaceVersion,detailed=false)
    viewType= detailed ? "/_detailed_" : "/_short_"
    viewFileName=::Rails.root.to_s+"/app/views/instancevaluesets/"+
      self.classtype.name+viewType+interfaceVersion.to_s+".html.erb"
    return File.exists?(viewFileName)
  end
# Return information about exisiting interface versions of measurement data. The return value is an array
# of hashes of all found interface version, their shot id in which this version appeared first and the
# respective shot date.
#
# Example of a return value:
#   interfaceInfo=[{:version=>0,:shot_id=>123,:shotDate=>1.1.2010},
#                  {:version=>3,:shot_id=>345,:shotDate=>2.2.2011}]
#
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
# Return the name of the instance. This function was added to simplify views.
  def to_s
    return self.name
  end
end
