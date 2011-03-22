class ShotsController < ApplicationController
  def index
    @shots=Shot.order("created_at DESC").paginate(:page => params[:page])
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

  def update
    if params[:cancel]
      flash[:info] = "Shot update canceled"
      redirect_to shot_path(@shot)
    else
      @shot = Shot.find_by_id(params[:id])
      if @shot 
        if @shot.update_attributes(params[:shot])
          flash[:success] = "Shot successfully updated"
          redirect_to shot_path(@shot)
        else
          @experiment.reload
          @pageTitle="Edit shot #{@shot.id}"
          render 'edit'
        end
      else
        flash[:error] = "Shot not found"
        redirect_to shot_path(@shot)
      end
    end
  end
end
