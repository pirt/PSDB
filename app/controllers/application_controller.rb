class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate

  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == 'admin' && password == '123123'
    end
  end

  def convertUnitValue(value,unit)
    if (unit.nil?)
      return value
    end
    if (unit.empty?)
      return value
    else
      unit.strip!
    end
    unitRegEx=/^([afpnumcdhkMGTPE]?)[ ]*([\w%]+)/
    matchSet=unitRegEx.match(unit)
    if (matchSet.nil?)
      return value
    else
      prefix=matchSet[1]
      baseUnit=matchSet[2]
      case prefix
      when "a"
        mult=1.0E-18
      when "f"
        mult=1.0E-15
      when "p"
        mult=1.0E-12
      when "n"
        mult=1.0E-9
      when "u","\316\274"
        mult=1.0E-6
      when "m"
        mult=1.0E-3
      when "c"
        mult=1.0E-2
      when "d"
        mult=1.0E-1
      when ""
        mult=1.0
      when "h"
        mult=1.0E2
      when "k"
        mult=1.0E3
      when "M"
        mult=1.0E6
      when "G"
        mult=1.0E9
      when "T"
        mult=1.0E12
      when "P"
        mult=1.E15
      when "E"
        mult=1.0E18
      else
        mult=1.0
      end
      return value*mult
    end
  end
  def getBaseUnit(unitString)
    if (unitString.nil?)
      return unitString
    elsif (unitString.empty?)
      return unitString
    else
      unitString.strip!
      unitRegEx=/^([afpnumcdhkMGTPE]?)[ ]*([\w%]+)/
      matchSet=unitRegEx.match(unitString)
      return matchSet[2]
    end
  end
  def getDatabaseType
    return ActiveRecord::Base.connection.adapter_name
  end
  def getDBSize
    dbStats={:bytesUsed=>-1,:bytesFree=>-1}
    case (getDatabaseType)
      when "OracleEnhanced"
        if (!Rails.env.test?) # avoid problems while unit testing
          queryString="Select MAX(d.bytes) total_bytes,
                          nvl(SUM(f.Bytes), 0) free_bytes,
                          d.file_name,
                          MAX(d.bytes) - nvl(SUM(f.bytes), 0) used_bytes,
                          ROUND(SQRT(MAX(f.BLOCKS)/SUM(f.BLOCKS))*(100/SQRT(SQRT(COUNT(f.BLOCKS)))), 2) frag_idx
                          from   DBA_FREE_SPACE f , DBA_DATA_FILES d
                          where  f.tablespace_name(+) = d.tablespace_name
                            and    f.file_id(+) = d.file_id
                            and    d.tablespace_name = 'PHELIX'
                          group by d.file_name"
          stats=Shot.find_by_sql(queryString).last
          dbStats[:bytesUsed]=stats.used_bytes
          dbStats[:bytesFree]=stats.free_bytes
        end
      when "Mysql2"
        bytesUsed=0
        bytesFree=0
        stats=Shot.find_by_sql("SHOW TABLE STATUS")
        stats.each do |status|
          bytesUsed+=status.Data_length
          bytesUsed+=status.Index_length
          bytesFree+=status.Data_free
        end
        dbStats[:bytesUsed]=bytesUsed
        dbStats[:bytesFree]=bytesFree
    end
    return dbStats
  end
  def self.projectizeName(filename)
    projectName=PSDB_CONFIG["project"]["name"]
    dirname=File.dirname(filename)
    basename=File.basename(filename)
    if dirname=="."
      return projectName+"_"+basename
    else
      return basename+"/"+projectName+"_"+basename
    end
  end
end

