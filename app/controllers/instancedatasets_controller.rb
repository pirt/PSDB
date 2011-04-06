class InstancedatasetsController < ApplicationController
  def index
    @instanceDataSets=Instancedataset.all
  end
  def show
    @instanceDataSet=Instancedataset.find_by_id(params[:id])
  end

end
