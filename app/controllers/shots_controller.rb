class ShotsController < ApplicationController
  def index
    if (params[:selectedExp])
      selectedShots=Shot.where(:experiment_id => params[:selectedExp].to_i)
    elsif (params[:startDate] and params[:endDate])
      startDate=Date.civil(params[:startDate][:year].to_i, params[:startDate][:month].to_i, params[:startDate][:day].to_i)
      endDate=Date.civil(params[:endDate][:year].to_i, params[:endDate][:month].to_i, params[:endDate][:day].to_i,23)
      startDate=startDate.to_s+" 00:00:00"
      endDate=endDate.to_s+" 23:59:59"
      selectedShots=Shot.where("created_at >= ? AND created_at <= ?", startDate, endDate)
    else
      selectedShots=Shot
    end
    @shots=selectedShots.order("created_at DESC").paginate(:page => params[:page])
    @pageTitle="Shot list"
  end

  def show
    @shot=Shot.find_by_id(params[:id])
    availableInstanceDataSets=@shot.instancedatasets
    if (params[:subsystemName])
      selectedSubsystem=Subsystem.find_by_name(params[:subsystemName])
      selectedInstances=selectedSubsystem.instances
      @instanceDataSets=availableInstanceDataSets.where(:instance_id => selectedInstances).paginate(:page => params[:page])
    elsif (params[:classtypeName])
      selectedClasstype=Classtype.find_by_name(params[:classtypeName])
      selectedInstances=selectedClasstype.instances
      @instanceDataSets=availableInstanceDataSets.where(:instance_id => selectedInstances).paginate(:page => params[:page])
    else
      @instanceDataSets=availableInstanceDataSets.paginate(:page => params[:page])
    end
    @usedClasses=availableInstanceDataSets.joins(:instance => :classtype).select("classtypes.name").group("classtypes.name")
    @usedSubsystems=availableInstanceDataSets.joins(:instance => :subsystem).select("subsystems.name").group("subsystems.name")
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
