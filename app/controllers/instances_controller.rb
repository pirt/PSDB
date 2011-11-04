# This controller handles the display of information about Instances
# either as a list which can be filtered by a given class type and
# subsystem or showing details of a particular instance.
class InstancesController < ApplicationController
  def index
    selectedInstances=Instance.includes(:classtype, :subsystem)
    @selectedSubsystemName=""
    @selectedClasstypeName=""
    if (params[:subsystemName].present?)
      @selectedSubsystemName=params[:subsystemName]
      selectedSubsystem=Subsystem.find_by_name(params[:subsystemName])
      selectedInstances=selectedInstances.where(:subsystem_id=>selectedSubsystem)
    end
    if (params[:classtypeName].present?)
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
