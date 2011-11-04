# coding: utf-8
# General controller for the entire application.
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate

# Convert a numeric value and a unit with prefix to the numerical value of the base.
# This functions extracts the unit prefix and multiplies it by its prefix value.
#
# Example: 10 km => 10000, 123 cm => 1.23
# value::
# numeric value to be converted
# unit::
# unit string with prefix such as "cm" or "mBar"
  def convertUnitValue(value,unit)
    if (unit.present?)
      unit.strip!
    else
      return value
    unitRegEx=/^([afpnu\xC2\xB5\316\274mcdhkMGTPE]?)[ ]*(.+)/
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
      when "u","\316\274","\xC2\xB5"
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
# Return the physical dimension by stripping away any prefix.
#
# Example: "mBar" -> "Bar", "km" -> "m"
#
# unitString::
# the string to be converted.
  def getBaseUnit(unitString)
    if (unitString.present?)
      unitString.strip!
      unitRegEx=/^([afpnumcdhkMGTPE]?)[ ]*([\w%]+)/
      matchSet=unitRegEx.match(unitString)
      return matchSet[2]
    else
      return unitString
    end
  end
# Return name of underlying database system (adaptor type) such as +OracleEnhanced+
# or +Mysql2+.
  def getDatabaseType
    return ActiveRecord::Base.connection.adapter_name
  end
# Return size information of the database as hash list. The way this information is retrieved
# is database specific. There currently exist methods for oracle and mysql. If the size could not
# be retrieved both hashes are set to -1.
#
# Example of a return value:
#   dbStats={:bytesUsed=>1234556,:bytesFree=>76544321}
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
    end
    return dbStats
  end
  def projectizeName(filename)
    return ApplicationController.projectizeName(filename)
  end
# Return a filename which contains the project name as defined in <tt>config/psdbconfig.yml</tt>
# This function can be used to call different files which are project specific.
# Example:
#   projectizeName("logo.png") => logo_PHELIX.png (for project name PHELIX)
#   projectizeName("logo.png") => logo_POLARIS.png (for project name POLARIS)
# filename::
# the filename where the project name should be inserted.
  def self.projectizeName(filename)
    projectName=PSDB_CONFIG["project"]["name"]
    dirname=File.dirname(filename)
    extname=File.extname(filename)
    basename=File.basename(filename,extname) #basename without extension
    extname=File.extname(filename)
    if dirname=="."
      return basename+"_"+projectName+extname
    else
      return dirname+"/"+basename+"_"+projectName+extname
    end
  end
private
  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == 'admin' && password == '123123'
    end
  end
end
