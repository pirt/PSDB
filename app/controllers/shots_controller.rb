# This restful controller is responsible for handling shots.
class ShotsController < ApplicationController
  def index
    selectedShots=Shot
    if (params[:selectedExp].present?)
      selectedShots=selectedShots.where(:experiment_id => params[:selectedExp].to_i)
    end
    if (params[:shotType].present?)
      selectedShots=selectedShots.where(:shottype_id => params[:shotType].to_i)
    end
    if (params[:from_date].present?)
      begin
        startDate=Date.parse(params[:from_date]).to_s+" 00:00:00"
        selectedShots=selectedShots.where("created_at >= ?",startDate)
        params[:from_date]=Date.parse(params[:from_date]).to_s
      rescue ArgumentError
        params[:from_date]=""
      end
    end
    if (params[:to_date].present?)
      begin
        endDate=Date.parse(params[:to_date]).to_s+" 23:59:59"
        selectedShots=selectedShots.where("created_at <= ?",endDate)
        params[:to_date]=Date.parse(params[:to_date]).to_s
      rescue ArgumentError
        params[:to_date]=""
      end
    end
    @shots=selectedShots.order("created_at DESC").paginate(:page => params[:page],
      :include => :attachments, :per_page => 30)
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
    @selectedSubsystemName=""
    @selectedClasstypeName=""
    if (params[:subsystemName] and !params[:subsystemName].blank?)
      @selectedSubsystemName=params[:subsystemName]
      selectedSubsystem=Subsystem.find_by_name(params[:subsystemName])
      selectedInstances=selectedSubsystem.instances
      availableInstanceValueSets=availableInstanceValueSets.where(:instance_id => selectedInstances)
    end
    if (params[:classtypeName] and !params[:classtypeName].blank?)
      @selectedClasstypeName=params[:classtypeName]
      selectedClasstype=Classtype.find_by_name(params[:classtypeName])
      selectedInstances=selectedClasstype.instances
      availableInstanceValueSets=availableInstanceValueSets.where(:instance_id => selectedInstances)
    end
    @instanceValueSets=availableInstanceValueSets.order(:instance=>"name").paginate(:page => params[:page])
    @usedClasses=@shot.involvedClasstypes.order("name asc")
    @usedSubsystems=@shot.involvedSubsystems.order("name asc")
    @pageTitle="Shot #{@shot.id}"
    @reportTypes=getAvailableReportTypes() # [["z6","z6"]]
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
      expire_fragment('shotline'+@shot.id.to_s)
      redirect_to shot_path(@shot)
    else
      @shot.reload
      @pageTitle="Edit shot #{@shot.id}"
      render 'edit'
    end
  end

  def report
    @shot=Shot.find_by_id(params[:id])
    if params[:reportType].present?
      @reportName=params[:reportType]
    end
    if !@shot
      flash[:error]="Shot not found."
      redirect_to shots_path
      return
    end
    @pageTitle="Shot report for shot #{@shot.id}"
    @instanceValueSets=@shot.instancevaluesets
    render :layout => false
  end
private
  def getAvailableReportTypes
    reportsPath=Rails.root.to_s+"/app/views/shots/"+projectizeName("reports")+"/*"
    files=Dir.glob(reportsPath)
    reportTypes=[]
    files.each do |file|
      reportType=File.basename(file,".html.erb").sub("_","")
      reportTypes << [reportType,reportType]
    end
    return reportTypes
  end
  
end
