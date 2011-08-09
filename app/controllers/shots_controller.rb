class ShotsController < ApplicationController
  def index
    selectedShots=Shot
    if (params[:selectedExp] and params[:selectedExp]!="0")
      selectedShots=selectedShots.where(:experiment_id => params[:selectedExp].to_i)
    end
    if (params[:shotType] and params[:shotType]!="0")
      selectedShots=selectedShots.where(:shottype_id => params[:shotType].to_i)
    end
    if (params[:from_date] and !params[:from_date].blank?)
      begin
        startDate=Date.parse(params[:from_date]).to_s+" 00:00:00"
        selectedShots=selectedShots.where("created_at >= ?",startDate)
        params[:from_date]=Date.parse(params[:from_date]).to_s
      rescue ArgumentError
        params[:from_date]=""
      end
    end
    if (params[:to_date] and !params[:to_date].blank?)
      begin
        endDate=Date.parse(params[:to_date]).to_s+" 23:59:59"
        selectedShots=selectedShots.where("created_at <= ?",endDate)
        params[:to_date]=Date.parse(params[:to_date]).to_s
      rescue ArgumentError
        params[:to_date]=""
      end
    end
    @shots=selectedShots.order("created_at DESC").paginate(:page => params[:page],:per_page => 30)
    @pageTitle="Shot list"
    @formData=params
  end

  def show
    @shot=Shot.find_by_id(params[:id])
    if !@shot
      flash[:error]="Shot not found."
      redirect_to shots_path
      return
    end
    availableInstanceValueSets=@shot.instancevaluesets
    if (params[:subsystemName])
      selectedSubsystem=Subsystem.find_by_name(params[:subsystemName])
      selectedInstances=selectedSubsystem.instances
      availableInstanceValueSets=availableInstanceValueSets.where(:instance_id => selectedInstances)
    elsif (params[:classtypeName])
      selectedClasstype=Classtype.find_by_name(params[:classtypeName])
      selectedInstances=selectedClasstype.instances
      availableInstanceValueSets=availableInstanceValueSets.where(:instance_id => selectedInstances)
    end
    @instanceValueSets=availableInstanceValueSets.paginate(:page => params[:page])
    @usedClasses=@shot.involvedClasstypes
    @usedSubsystems=@shot.involvedSubsystems
    @pageTitle="Shot #{@shot.id}"
  end

  def edit
    @shot=Shot.find_by_id(params[:id])
    if !@shot
      flash[:error]="Shot not found."
      redirect_to shots_path
      return
    end
    @pageTitle="Edit shot #{@shot.id}"
  end

  def update
    @shot = Shot.find_by_id(params[:id])
    if !@shot
      flash[:error] = "Shot not found"
      redirect_to shots_path
      return
    end
    if params[:cancel]
      flash[:info] = "Shot update canceled"
      redirect_to shot_path(@shot)
      return
    end
    if @shot.update_attributes(params[:shot])
      flash[:success] = "Shot successfully updated"
      redirect_to shot_path(@shot)
    else
      @shot.reload
      @pageTitle="Edit shot #{@shot.id}"
      render 'edit'
    end
  end
end
