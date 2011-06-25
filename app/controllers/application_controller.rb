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
end
