class AttachmentsController < ApplicationController
  def show
    #TODO: check presence of attachment
    attachment=Attachment.find(params[:id])
    send_data attachment.content, :type => attachment.filetype, :filename => attachment.filename
  end
  def new
      @attachment=Attachment.new
      @pageTitle="Add attachment"
  end
  def create
    #TODO: check presence of experiment and validity of posted data
    if params[:experiment_id]
      @parent=Experiment.find_by_id(params[:experiment_id])
      if params[:cancel]
        flash[:info]="Attachment creation cancelled"
        redirect_to experiment_path(@parent)
      elsif
        uploaded_content=params[:attachment][:content]
        @attachment=@parent.attachments.new
        if (uploaded_content)
          @attachment.filename=uploaded_content.original_filename
          @attachment.filetype=uploaded_content.content_type
          @attachment.content=uploaded_content.read
        end
        @attachment.description=params[:attachment][:description]
        if @attachment.save
          flash[:success]="Attachment created"
          redirect_to experiment_path(@parent)
        else
          render 'new'
        end
      else
        flash[:error]="No experiment / shot selected."
        redirect_to :experiments
      end
    end
    
  end
  def edit
    @attachment=Attachment.find_by_id(params[:id])
    if @attachment
      @pageTitle="Edit attachment"
    else
      flash[:error]="Attachment not found"
      redirect_to experiment_path(params[:experiment_id])
    end
  end
  def update
    @attachment=Attachment.find_by_id(params[:id])
    if @attachment
      updated_content=params[:attachment][:content]
      if (updated_content)
        @attachment.filename=updated_content.original_filename
        @attachment.filetype=updated_content.content_type
        @attachment.content=updated_content.read
      else
        @attachment.content=""
      end
      @attachment.description=params[:attachment][:description]
      if @attachment.save
        flash[:success]="Attachment updated"
        redirect_to experiment_path(@attachment.attachable_id)
      else
        @attachment.reload
        @pageTitle="Edit attachment"
        render 'edit'
      end
    else
      flash[:error]="Attachment not found"
      redirect_to experiment_path(@attachment.attachable_id)
    end
  end
  def destroy
    attachment=Attachment.find_by_id(params[:id])
    if attachment
      if attachment.destroy
        flash[:success] = "Attachment successfully deleted"
      else
        flash[:error] = "Error while deleting attachment"
      end
    else
      flash[:error] = "Attachment not found"
    end
    redirect_to experiment_path(params[:experiment_id])
  end
end
