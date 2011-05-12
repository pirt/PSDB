class StatisticsController < ApplicationController
  def overview
    nrOfExps=Experiment.count
    nrOfExpShots=Shot.where(:shottype_id=>1).count
    @avgShotsPerExperiment=nrOfExpShots/nrOfExps
  end

  def calendar
    selectedShots=Shot.all
    if (params[:shotType] and params[:shotType]!="0")
      selectedShots=Shot.where(:shottype_id => params[:shotType].to_i).to_a
    end
    @shots=selectedShots
    @date=params[:month] ? Date.parse(params[:month]) : Date.today
    @formData=params 
  end

end
