class InstancedatasetsController < ApplicationController
  def index
    if (params[:instance_id])
      @instanceDataSets=Instancedataset.where(:instance_id => params[:instance_id]).paginate(:page => params[:page])
    else
      @instanceDataSets=Instancedataset.paginate(:page => params[:page])
    end
  end

  def show
    @instanceDataSet=Instancedataset.find_by_id(params[:id])
  end

end
