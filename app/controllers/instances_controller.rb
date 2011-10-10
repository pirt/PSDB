class InstancesController < ApplicationController
  def index
    selectedInstances=Instance.includes(:classtype, :subsystem)
    @selectedSubsystemName=""
    @selectedClasstypeName=""
    if (params[:subsystemName] and !params[:subsystemName].blank?)
      @selectedSubsystemName=params[:subsystemName]
      selectedSubsystem=Subsystem.find_by_name(params[:subsystemName])
      selectedInstances=selectedInstances.where(:subsystem_id=>selectedSubsystem)
    end
    if (params[:classtypeName] and !params[:classtypeName].blank?)
      @selectedClasstypeName=params[:classtypeName]
      selectedClasstype=Classtype.find_by_name(params[:classtypeName])
      selectedInstances=selectedInstances.where(:classtype_id=>selectedClasstype)
    end
    @instances=selectedInstances.order("name ASC").
       paginate(:page => params[:page])
    @availableClasstypes=Classtype.order("name ASC")
    @availableSubsystems=Subsystem.order("name ASC")
    @pageTitle="Instance list"
  end

  def show
    @instance=Instance.find_by_id(params[:id])
    @interfaceInfo=@instance.interfaceVersionInfo
    @pageTitle="Details for instance <#{@instance.name}>"
  end
end
