class InstancesController < ApplicationController
  def index
    if (params[:subsystemName])
      selectedSubsystem=Subsystem.find_by_name(params[:subsystemName])
      selectedInstances=selectedSubsystem.instances.order("name ASC")
    elsif (params[:classtypeName])
      selectedClasstype=Classtype.find_by_name(params[:classtypeName])
      selectedInstances=selectedClasstype.instances.order("name ASC")
    else
      selectedInstances=Instance.order("name ASC")
    end
    @instances=selectedInstances.includes(:classtype, :subsystem).paginate(:page => params[:page])
    @availableClasstypes=Classtype.all
    @availableSubsystems=Subsystem.all
  end

  def show
    @instance=Instance.find_by_id(params[:id])
    interfaceVersions=@instance.instancedatasets.select(:version).group(:version)
    @interfaceInfo=[]
    interfaceVersions.each do |interfaceVersion|
      shotId=@instance.instancedatasets.where(:version => interfaceVersion.version).minimum(:shot_id)
      shot=Shot.find_by_id(shotId)
      if (!shot.nil?)
        shotDate=shot.created_at
      else
	shotDate=nil
      end
      @interfaceInfo << {:version => interfaceVersion.version, :shot_id => shotId, :shotDate => shotDate}
    end
  end
end
