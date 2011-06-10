module InstancesHelper
  def viewExists(classType,version,detailed=false)
    viewType= detailed ? "/_detailed_" : "/_short_"
    viewFileName=::Rails.root.to_s+"/app/views/instancevaluesets/"+classType+viewType+version.to_s+".html.erb"
    return File.exists?(viewFileName)
  end
end
