class ShotsController < ApplicationController
  def index
    @shots=Shot.all.paginate(:page => params[:page])
    @pageTitle="Shot list"
  end

  def show
    @shot=Shot.find_by_id(params[:id])
    availableInstanceDatas=@shot.instancedatas
    groupedInstanceDatas=availableInstanceDatas.select(:instance_id).group(:instance_id).includes(:instance)
    @instanceDatas=groupedInstanceDatas.paginate(:page => params[:page])
    @usedClasses=availableInstanceDatas.joins(:instance => :classtype).select("classtypes.name").group("classtypes.name")
    @usedSubsystems=availableInstanceDatas.joins(:instance => :subsystem).select("subsystems.name").group("subsystems.name")
    @pageTitle="Shot #{@shot.id}"
  end

  def edit
    @shot=Shot.find_by_id(params[:id])
    @pageTitle="Edit shot #{@shot.id}"
  end
end
