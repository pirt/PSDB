class InstancevaluesetsController < ApplicationController
  def index
    selectedValueSets=Instancevalueset
    if (params[:instance_id] and !params[:instance_id].blank?)
      selectedValueSets=selectedValueSets.where(:instance_id => params[:instance_id])
      @instanceId=params[:instance_id]
    end
    if (params[:from_date] and !params[:from_date].blank?)
      begin
       startDate=Date.parse(params[:from_date]).to_s+" 00:00:00"
        selectedValueSets=selectedValueSets.where("instancevaluesets.created_at >= ?",startDate)
        params[:from_date]=Date.parse(params[:from_date]).to_s
      rescue ArgumentError
        params[:from_date]=""
      end
    end
    if (params[:to_date] and !params[:to_date].blank?)
      begin
        endDate=Date.parse(params[:to_date]).to_s+" 23:59:59"
        selectedValueSets=selectedValueSets.where("instancevaluesets.created_at <= ?",endDate)
        params[:to_date]=Date.parse(params[:to_date]).to_s
      rescue ArgumentError
        params[:to_date]=""
      end
    end
    @instanceValueSets=selectedValueSets.order("shot_id DESC").paginate(:page => params[:page])
    datatype=Datatype.find_by_name("numeric")
    if (datatype) 
      datatypeId=datatype.id
      availableParameters=selectedValueSets.joins(:instancevalues).where("datatype_id=?",datatypeId).
        select("instancevalues.name").group("instancevalues.name")
    else
      availableParameters=[]
    end
    @doPlot=false
    if (availableParameters.length!=0)
      @doPlot=true
      @parameterArray=[]
      count=0
      availableParameters.each do |availableParameter|
        @parameterArray << [availableParameter.name,count]
        count+=1
      end
      if (params[:plotParameter] and !params[:plotParameter].blank?)
        # check if parameterNr still valid
        if params[:plotParameter].to_i<@parameterArray.length
          selectedPlotParameter=@parameterArray[params[:plotParameter].to_i][0]
        else
          selectedPlotParameter=availableParameters.first.name
          params[:plotParameter]=0
        end
      else
        selectedPlotParameter=availableParameters.first.name
        params[:plotParameter]=0
      end
      parameterValues=selectedValueSets.joins(:instancevalues).
          where("name=?",selectedPlotParameter).
          select("shot_id,instancevalues.data_numeric,instancevalues.data_string")
      xValues=[]
      yValues=[]
      parameterValues.each do |parameterValue|
        xValues << parameterValue.shot_id
        yValues << convertUnitValue(parameterValue.data_numeric,parameterValue.data_string)
      end
      @yLabel=selectedPlotParameter
      baseUnit=getBaseUnit(parameterValues.last.data_string)
      if (!baseUnit.nil?)
        if (!baseUnit.empty?)
          @yLabel+=" ["+baseUnit+"]"
        end
      end
      @xyValues=[xValues,yValues]
    end
    @formData=params
  end

  def show
    @instanceValueSet=Instancevalueset.find_by_id(params[:id])
  end
end
