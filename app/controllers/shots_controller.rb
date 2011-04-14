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
    @shots=selectedShots.order("created_at DESC").paginate(:page => params[:page])
    @pageTitle="Shot list"
    @formData=params
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
