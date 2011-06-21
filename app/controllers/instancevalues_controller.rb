class InstancevaluesController < ApplicationController
  def exportImage
    instanceValue=Instancevalue.find_by_id(params[:instanceValueId])
    sendImage=instanceValue.exportImage({:exportFormat=>params[:selectedExportFormat],:withColorPalette=>params[:withColorPalette]})
    send_data sendImage[:content], :type => sendImage[:format], :filename => sendImage[:filename]
  end
  def exportPlot
    instanceValue=Instancevalue.find_by_id(params[:instanceValueId])
    txtData=instanceValue.export2dData
    send_data txtData[:content], :type => txtData[:content], :filename => txtData[:filename]
  end
end
