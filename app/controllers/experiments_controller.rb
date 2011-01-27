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
    if params[:cancel]
      flash[:info] = "Experiment creation canceled"
      redirect_to experiments_path
    elsif
      @experiment = Experiment.new(params[:experiment])
      if @experiment.save
        flash[:success] = "Experiment successfully created"
        redirect_to experiments_path
      else
        @pageTitle = "Add new experiment"
        render 'new'
      end
    end
  end

  def edit
    @experiment=Experiment.find(params[:id])
    @pageTitle="Edit experiment "+@experiment.name
  end

  def update
    if params[:cancel]
      flash[:info] = "Experiment update canceled"
      redirect_to experiments_path
    elsif
      @experiment = Experiment.find(params[:id])
      if @experiment.update_attributes(params[:experiment])
        flash[:success] = "Experiment successfully updated"
        redirect_to experiments_path
      else
        @experiment.reload
        @pageTitle="Edit experiment "+@experiment.name
        render 'edit'
      end
    end
  end

  def destroy
  end
end
