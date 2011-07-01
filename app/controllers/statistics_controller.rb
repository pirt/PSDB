class StatisticsController < ApplicationController
  def overview
    nrOfExps=Experiment.count
    nrOfExpShots=Shot.where(:shottype_id=>1).count
    if (nrOfExpShots>0)
      @avgShotsPerExperiment=nrOfExpShots/nrOfExps
    else
      @avgShotsPerExperiment=0
    end
    @nrOfDaysPerYear=(Date.today-(Date.today-1.year)).to_i
    queryString="Select to_char(created_at,'DDD') FROM shots
                                                  WHERE shottype_id=1
                                                  GROUP BY to_char(created_at,'DDD')"
    @nrOfShotDays=Shot.find_by_sql(queryString).count
    queryString="Select MAX(d.bytes) total_bytes,
                        nvl(SUM(f.Bytes), 0) free_bytes,
                        d.file_name,
                        MAX(d.bytes) - nvl(SUM(f.bytes), 0) used_bytes,
                        ROUND(SQRT(MAX(f.BLOCKS)/SUM(f.BLOCKS))*(100/SQRT(SQRT(COUNT(f.BLOCKS)))), 2) frag_idx 
                        from   DBA_FREE_SPACE f , DBA_DATA_FILES d
                        where  f.tablespace_name(+) = d.tablespace_name
                          and    f.file_id(+) = d.file_id
                          and    d.tablespace_name = 'PHELIX_TEST'
                        group by d.file_name"
    @statistics=Shot.find_by_sql(queryString).last
    @pageTitle="Statistics overview"
  end

  def calendar
    selectedShots=Shot.all
    if (params[:shotType] and params[:shotType]!="0")
      selectedShots=Shot.where(:shottype_id => params[:shotType].to_i).to_a
    end
    @shots=selectedShots
    @date=params[:month] ? Date.parse(params[:month]) : Date.today
    @formData=params
    @pageTitle="Shot calendar"
  end

end
