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
  end
end
