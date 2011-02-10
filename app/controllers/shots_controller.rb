class ShotsController < ApplicationController
  def index
    @shots=Shot.all.paginate(:page => params[:page])
    @pageTitle="Shot list"
  end

  def show
    @shot=Shot.find_by_id(params[:id])
    @pageTitle="Shot #{@shot.id}"
  end

  def edit
  end

end
