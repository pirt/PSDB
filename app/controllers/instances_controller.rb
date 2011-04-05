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
    @instances=selectedInstances.select("name, classtype_id, subsystem_id").group("name, classtype_id, subsystem_id").paginate(:page => params[:page])
    @availableClasstypes=Classtype.all
    @availableSubsystems=Subsystem.all
  end

  def show
    @instance=Instance.find_by_id(params[:id])
    if (params[:shot_id])
      #show detailed data of an instance for one shot
      @instancedatas=@instance.instancedatas.where(:shot_id => params[:shot_id])
    else
      #show short view of instance for a list of shots
      @instancedatas=@instance.instancedatas
    end
  end
  def details
    @instances=Instance.where(:name => params[:instanceName])
  end
end
