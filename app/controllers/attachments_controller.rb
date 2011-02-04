class AttachmentsController < ApplicationController
  def show
    #TODO: check presence of attachment
    attachment=Attachment.find(params[:id])
    send_data attachment.content, :type => attachment.filetype
  end
  def new
    @attachment=Attachment.new
    @pageTitle="Add attachment"
  end
  def create
    #TODO: check presence of experiment and validity of posted data
    if params[:experiment_id]
      @parent=Experiment.find_by_id(params[:experiment_id])
      uploaded_content=params[:attachment][:content]
      @parent.attachments.create! (
        :filename => uploaded_content.original_filename,
        :filetype => uploaded_content.content_type,
        :description => params[:attachment][:description],
        :content => uploaded_content.read
      )
      flash[:success]="Attachment created"
      redirect_to experiment_path(@parent)
    else
      flash[:error]="No experiment / shot selected."
      redirect_to :experiments
    end
    
  end
  def edit
  end
  def update
  end
  def destroy
  end
end
