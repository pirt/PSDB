class ExperimentsController < ApplicationController
  def index
    @experiments = Experiment.select([:id, :name, :description]).paginate(:page => params[:page], 
                                                                          :per_page => Experiment.per_page)
    @pageTitle="Experiments"
  end

  def show
    @experiment=Experiment.find_by_id(params[:id])
    if @experiment
        @pageTitle=@experiment.name
        durations=Shot.find_by_sql("select nextTable.created_at as t1,
                                currentTable.created_at as t2 
      		from (select * from shots where experiment_id=1) currentTable
      		join (select * from shots where experiment_id=1) nextTable
        	on nextTable.id=(select min(id) from 
          	(select * from shots where experiment_id=1) where id>currentTable.id)");
	@maxduration=0
	durations.each do |duration|
	  difference=duration.t1-duration.t2
	  if difference>@maxduration
	    @maxduration=difference
          end
	end
    else
      flash[:error] = "Experiment not found"
      redirect_to experiments_path
    end
  end

  def new
    @experiment=Experiment.new
    @pageTitle="Add new experiment"
  end

  def create
    if params[:cancel]
      flash[:info] = "Experiment creation cancelled"
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
    @experiment=Experiment.find_by_id(params[:id])
    if @experiment
      @pageTitle="Edit experiment "+@experiment.name
    elsif
      flash[:error] = "Experiment not found"
      redirect_to experiments_path
    end
  end

  def update
    if params[:cancel]
      flash[:info] = "Experiment update canceled"
      redirect_to experiments_path
    else
      @experiment = Experiment.find_by_id(params[:id])
      if @experiment 
        if @experiment.update_attributes(params[:experiment])
          flash[:success] = "Experiment successfully updated"
          redirect_to experiments_path
        else
          @experiment.reload
          @pageTitle="Edit experiment "+@experiment.name
          render 'edit'
        end
      else
        flash[:error] = "Experiment not found"
        redirect_to experiments_path
      end
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
