##
# This module provides application-wide helper methods which can
# be used in all views.
module ApplicationHelper
##
# Return a title on a per-page basis.
  def pageTitle
    base_title = "PHELIX shot database"
    if @pageTitle.nil?
      base_title
    else
      "#{base_title} | #{@pageTitle}"
    end
  end

##
# Format dates from the datebase to nicely formatted local time (database times are UTC).
# Supported options are
# :dateOnly=>true:: display only the date without the time
# :showSeconds=>false:: display without the "seconds" field
  def formatDate(date, options={})
    if (options[:dateOnly]==true)
      return date.localtime().strftime("%d.%m.%Y")
    else
      if (options[:showSeconds]==false)
        return date.localtime().strftime("%d.%m.%Y %H:%M")
      else
        return date.localtime().strftime("%d.%m.%Y %X")
      end
    end
  end
##
# Convert a string (filename) to a project specific name.
  def projectizeName(filename)
    return ApplicationController.projectizeName(filename)
  end
end

