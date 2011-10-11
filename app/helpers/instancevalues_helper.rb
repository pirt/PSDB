module InstancevaluesHelper
  def displayValue (instancevalue, options={})
    if instancevalue.nil?
      return "parameter does not exist!"
    end
    dataType=instancevalue.datatype.name
    partialName="instancevalue_#{dataType}"
    partialFileName=::Rails.root.to_s+"/app/views/instancevalues/_"+partialName+".html.erb"
    if !File.exists?(partialFileName)
      return "no view for data type <"+dataType+"> available !"
    end
    localoptions = {}
    if defined?(options)
      localoptions.merge!(options)
    end
    render "instancevalues/#{partialName}", { :instancevalue => instancevalue, :options => localoptions }
  end
  def number_to_scientific(num,precision=1)
	  numberString="%.#{precision}e" % num
    splitString=numberString.split("e")
    exponent=splitString[1].to_i.to_s
    html=splitString[0]+" x 10<sup>"+exponent+"</sup>"
    return html.html_safe
  end
end
