class ExperimentsController < ApplicationController
  def index
    @experiments=Experiment.all
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
