class InstancesController < ApplicationController
  def index
    @instances=Instance.all
  end

  def show
    @instance=Instance.find_by_id(params[:id])
    if (params[:shot_id])
      #show detailed data of an instance for one shot
      @instancedatas=@instance.instancedatas.where(:shot_id => params[:shot_id])
    else
      #show short view of instance for a list of shots
      @instancedatas=@instance.instancedatas
    end
  end

end
