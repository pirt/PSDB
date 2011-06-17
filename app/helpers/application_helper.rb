module ApplicationHelper
# Return a title on a per-page basis.
  def pageTitle
    base_title = "PHELIX shot database"
    if @pageTitle.nil?
      base_title
    else
      "#{base_title} | #{@pageTitle}"
    end
  end

# Format dates from the datebase to nicely formatted local time (database times are UTC)
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
end
