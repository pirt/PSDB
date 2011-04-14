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

  def formatDate(date, options={})
    if (options[:dateOnly]==true)
      return date.localtime().strftime("%d.%m.%Y")
    else
      return date.localtime().strftime("%d.%m.%Y %X")
    end
  end
end
