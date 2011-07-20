class InstancevaluesController < ApplicationController
  def exportImage
    instanceValue=Instancevalue.find_by_id(params[:instanceValueId])
    if (instanceValue)
      sendImage=instanceValue.exportImage({:exportFormat=>params[:selectedExportFormat],:withColorPalette=>params[:withColorPalette]})
      if (sendImage)
        send_data sendImage[:content], :type => sendImage[:format], :filename => sendImage[:filename]
      else
        flash[:error]="Error exporting image."
        redirect_to shots_path
      end
    else
      flash[:error]="Image not found."
      redirect_to shots_path
    end
  end
  def exportPlot
    instanceValue=Instancevalue.find_by_id(params[:instanceValueId])
    if (instanceValue)
      txtData=instanceValue.export2dData
      if (txtData)
        send_data txtData[:content], :type => txtData[:type], :filename => txtData[:filename]
      else
        flash[:error]="Error exporting 2dData."
        redirect_to shots_path
      end
    else
      flash[:error]="Plot data not found."
      redirect_to shots_path
    end
  end
end

