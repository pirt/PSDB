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
      return date.localtime().strftime("%d.%m.%Y %X")
    end
  end

# Get size limitations of the content field (=file size) of the Attachments table
  def getAttributeLength()
    size=nil
    Attachment.validators.each do |v|
      if (v.attributes[0]==:content and v.kind==:length)
        size=v.options[:maximum]
      end
    end
    return size
  end
end
