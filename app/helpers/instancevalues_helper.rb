module InstancevaluesHelper
  def displayValue (instancevalue, options={})
    if instancevalue.nil?
      return "parameter does not exist!"
    end
    dataType=instancevalue.datatype.name
    partialName="instancevalue_#{dataType}"
    partialFileName=::Rails.root.to_s+"/app/views/instancevalues/_"+partialName+".html.erb"
    if !File.exists?(partialFileName)
      partialName="instancevalue_unknown"
    end
    localoptions = {}
    if defined?(options)
      localoptions.merge!(options)
    end
    render "instancevalues/#{partialName}", { :instancevalue => instancevalue, :options => localoptions }
  end
end
