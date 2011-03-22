class ShotsController < ApplicationController
  def index
    @shots=Shot.all.paginate(:page => params[:page])
    @pageTitle="Shot list"
  end

  def show
    @shot=Shot.find_by_id(params[:id])
    availableInstanceDatas=@shot.instancedatas
    groupedInstanceDatas=availableInstanceDatas.select(:instance_id).group(:instance_id).includes(:instance)
    if (params[:subsystemName])
      selectedSubsystem=Subsystem.find_by_name(params[:subsystemName])
      selectedInstances=selectedSubsystem.instances
      @instanceDatas=groupedInstanceDatas.where(:instance_id => selectedInstances).paginate(:page => params[:page])
    elsif (params[:classtypeName])
      selectedClasstype=Classtype.find_by_name(params[:classtypeName])
      selectedInstances=selectedClasstype.instances
      @instanceDatas=groupedInstanceDatas.where(:instance_id => selectedInstances).paginate(:page => params[:page])
    else
      @instanceDatas=groupedInstanceDatas.paginate(:page => params[:page])
    end
    @usedClasses=availableInstanceDatas.joins(:instance => :classtype).select("classtypes.name").group("classtypes.name")
    @usedSubsystems=availableInstanceDatas.joins(:instance => :subsystem).select("subsystems.name").group("subsystems.name")
    @pageTitle="Shot #{@shot.id}"
  end

  def edit
    @shot=Shot.find_by_id(params[:id])
    @pageTitle="Edit shot #{@shot.id}"
  end
end
