# This restful controller handles the Experiment resources.
# Experiments can be displayed, created, and modified. Deletion of Experiments
# is only possible if no shots are related to it.
#
# In addition it is possible to add file attachments to a particular experiment. This
# functionality is handles by the AttachmentsController.
class ExperimentsController < ApplicationController

  def index
    @experiments = Experiment.select([:id, :name, :description, :active]).
      paginate(:page => params[:page], :include=>[:attachments])
    @pageTitle="Experiments"
  end
  def show
    @experiment=Experiment.find_by_id(params[:id])
    if @experiment
      @pageTitle=@experiment.name
      @beamtimes=@experiment.getBeamtimes(7.days)
    else
      flash[:error] = "Experiment not found"
      redirect_to experiments_path
    end
  end

  def new
    @experiment=Experiment.new(:active => true)
    @pageTitle="Add new experiment"
  end
  def create
    if params[:cancel]
      flash[:info] = "Experiment creation cancelled"
      redirect_to experiments_path
      return
    end
    @experiment = Experiment.new(params[:experiment])
    if @experiment.save
      flash[:success] = "Experiment successfully created"
      redirect_to experiments_path
    else
      @pageTitle = "Add new experiment"
      render 'new'
    end
  end
  def edit
    @experiment=Experiment.find_by_id(params[:id])
    if @experiment
      @pageTitle="Edit experiment "+@experiment.name
    elsif
      flash[:error] = "Experiment not found"
      redirect_to experiments_path
    end
  end
  def update
    @experiment = Experiment.find_by_id(params[:id])
    if !@experiment
      flash[:error] = "Experiment not found"
      redirect_to experiments_path
      return
    end
    if params[:cancel]
      flash[:info] = "Experiment update canceled"
      redirect_to experiment_path(@experiment)
      return
    end
    if @experiment.update_attributes(params[:experiment])
      flash[:success] = "Experiment successfully updated"
      redirect_to experiments_path
    else
       @experiment.reload
       @pageTitle="Edit experiment "+@experiment.name
       render 'edit'
    end
  end
  def destroy
    experiment=Experiment.find_by_id(params[:id])
    if experiment
      if experiment.destroy
        flash[:success] = "Experiment successfully deleted"
      else
        flash[:error] = "Error while deleting experiment"
      end
    else
      flash[:error] = "Experiment not found"
    end
    redirect_to experiments_path
  end
end
