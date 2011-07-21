class InstancevaluesController < ApplicationController
  def exportImage
    instanceValue=Instancevalue.find_by_id(params[:instanceValueId])
    if (instanceValue)
      begin
        sendImage=instanceValue.
            exportImage({:exportFormat=>params[:selectedExportFormat],
                        :withColorPalette=>params[:withColorPalette]})
      rescue
        flash[:error]="Error exporting image."
        redirect_to shots_path
        return
      end
      send_data sendImage[:content], :type => sendImage[:format], :filename => sendImage[:filename]
    else
      flash[:error]="Image not found."
      redirect_to shots_path
    end
  end
  def exportPlot
    instanceValue=Instancevalue.find_by_id(params[:instanceValueId])
    if (instanceValue)
      begin
        txtData=instanceValue.export2dData
      rescue
        flash[:error]="Error exporting 2dData."
        redirect_to shots_path
        return
      end
      send_data txtData[:content], :type => txtData[:type], :filename => txtData[:filename]
    else
      flash[:error]="Plot data not found."
      redirect_to shots_path
    end
  end
end

