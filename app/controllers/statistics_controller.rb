# This controller is repsonsible for displaying statics information of PSDB.
class StatisticsController < ApplicationController
# Render the overview page of PSDB.
  def overview
    nrOfExps=Experiment.count
    nrOfExpShots=Shot.where(:shottype_id=>1).count
    if (nrOfExpShots>0)
      @avgShotsPerExperiment=nrOfExpShots/nrOfExps
    else
      @avgShotsPerExperiment=0
    end
    @nrOfDaysPerYear=Time.parse("12/31").yday
    yearBegin=Time.parse("1/1")
    yearEnd=yearBegin+1.year
    shotsOfTheYear=Shot.where(:shottype_id=>1,:created_at=>yearBegin..yearEnd)
    @nrOfFailedShots=getNumberOfFailedShots(shotsOfTheYear)
    @nrOfShotDays=shotsOfTheYear.group_by {|s| s.created_at.yday}.length
    @databaseType=getDatabaseType()
    @dbStats=getDBSize()
    @pageTitle="Statistics overview"
  end
# Render the shot calendar.
  def calendar
    selectedShots=Shot.all
    if (params[:shotType].present?)
      selectedShots=Shot.where(:shottype_id => params[:shotType].to_i).to_a
    end
    @shots=selectedShots
    @date=params[:month] ? Date.parse(params[:month]) : Date.today
    @formData=params
    @pageTitle="Shot calendar"
  end
private
  def getNumberOfFailedShots(shots)
    failedShots=0
    Shot.all.each do |shot|
      if shot.getShotStatus=="failedshot"
        failedShots+=1
      end
    end
    return failedShots
  end
end
