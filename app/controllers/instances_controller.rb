class InstancesController < ApplicationController
  def index
    @instances=Instance.all
  end

  def show
    @instance=Instance.find_by_id(params[:id])
    if (params[:shot_id])
      @instancedatas=@instance.instancedatas.where(:shot_id => params[:shot_id])
    else
      @instancedatas=@instance.instancedatas
    end
  end

end
