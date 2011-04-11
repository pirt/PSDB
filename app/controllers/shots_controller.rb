class ShotsController < ApplicationController
  def index
    @fromDate=""
    @toDate=""
    if (params[:selectedExp])
      selectedShots=Shot.where(:experiment_id => params[:selectedExp].to_i)
    elsif (params[:from_date] and params[:to_date])
      @fromDate=params[:from_date]
      @toDate=params[:to_date]
      begin
        startDate=Date.parse(@fromDate).to_s+" 00:00:00"
        endDate=Date.parse(@toDate).to_s+" 23:59:59"
        selectedShots=Shot.where("created_at >= ? AND created_at <= ?", startDate, endDate)
      rescue ArgumentError
        selectedShots=Shot
        @fromDate=""
        @toDate=""
        flash[:error]="Uncorrect dates selected."
      end
    else
      selectedShots=Shot
    end
    @shots=selectedShots.order("created_at DESC").paginate(:page => params[:page])
    @pageTitle="Shot list"
    @durations=Shot.find_by_sql("select nextTable.created_at as t1,
                                currentTable.created_at as t2 
      from shots currentTable
      join shots nextTable
        on nextTable.id=(select min(id) from shots where id>currentTable.id)");
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
