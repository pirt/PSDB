class ExperimentsController < ApplicationController
  def index
    @experiments = Experiment.select([:id, :name, :description]).paginate(:page => params[:page], 
                                                                          :per_page => Experiment.per_page)
    @pageTitle="Experiments"
  end

  def show
    @experiment=Experiment.find(params[:id])
    @pageTitle=@experiment.name
  end

  def new
    @experiment=Experiment.new
    @pageTitle="Add new experiment"
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
