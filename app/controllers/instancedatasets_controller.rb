class InstancedatasetsController < ApplicationController
  def index
    if (params[:instance_id])
      selectedDataSets=Instancedataset.where(:instance_id => params[:instance_id])
      @instanceId=params[:instance_id]
    else
      selectedDataSets=Instancedataset
    end
    @fromDate=""
    @toDate=""
    if (params[:from_date] and params[:to_date])
      @fromDate=params[:from_date]
      @toDate=params[:to_date]
      startDate=@fromDate.to_date.to_s+" 00:00:00"
      endDate=@toDate.to_date.to_s+" 23:59:59"
      selectedDataSets=selectedDataSets.where("created_at >= ? AND created_at <= ?", 
                                                startDate, endDate)
    end
    
    @instanceDataSets=selectedDataSets.order("shot_id DESC").paginate(:page => params[:page])
  end

  def show
    @instanceDataSet=Instancedataset.find_by_id(params[:id])
  end

end
