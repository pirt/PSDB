# This module contains helper functions for displaying Instancevalues in views.
module InstancevaluesHelper
# Display an instancevalue.
#
# This function calls the right view depending on the data type of the instancevalue. This ist done lookking for
# the right partial following the naming scheme <tt>/app/views/instancevalues/_<data type>.html.erb</tt>.
# An error message is returned if the partial for the particular data type is not found.
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
# Display a numerical value in scientific notation.
#
# Returns a HTML representation of the numerical value in scientific notation.
# num:: Numerical value to be displayed.
# precision:: Number of digits to be displayed after the separator.
  def number_to_scientific(num,precision=1)
    numberString="%.#{precision}e" % num
    splitString=numberString.split("e")
    exponent=splitString[1].to_i.to_s
    html=splitString[0]+" x 10<sup>"+exponent+"</sup>"
    return html.html_safe
  end
end
