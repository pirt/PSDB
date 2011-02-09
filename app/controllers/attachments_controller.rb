class AttachmentsController < ApplicationController
  def show
    attachment=Attachment.find_by_id(params[:id])
    if (attachment)
      send_data attachment.content, :type => attachment.filetype, :filename => attachment.filename
    else
      flash[:error]="Attachment not found"
      redirect_to experiment_path(:experiment_id)
    end
  end
  def new
      @attachment=Attachment.new
      @pageTitle="Add attachment"
  end
  def create
    if !params[:experiment_id]
      flash[:error]="No experiment / shot selected."
      redirect_to :experiments
    end
    @parent=Experiment.find_by_id(params[:experiment_id])
    if !@parent
      flash[:error]="Experiment not found"
      redirect_to experiments_path
    else
      if params[:cancel]
        flash[:info]="Attachment creation cancelled"
        redirect_to experiment_path(@parent)
      elsif
        @attachment=@parent.attachments.new
        @attachment.description=params[:attachment][:description]
        uploaded_content=params[:attachment][:content]
        if (uploaded_content)
          if uploaded_content.respond_to?('original_filename')
            @attachment.filename=uploaded_content.original_filename
         end
          if uploaded_content.respond_to?('content_type')
            @attachment.filetype=uploaded_content.content_type
          end
          if uploaded_content.respond_to?('read')
            @attachment.content=uploaded_content.read
          end
        end
        if @attachment.save
          flash[:success]="Attachment created"
          redirect_to experiment_path(@parent)
        else
          @pageTitle="Add attachment"
          render 'new'
        end
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
      if params[:cancel]
        flash[:info]="Attachment update cancelled"
        redirect_to experiment_path(@attachment.attachable_id)
      else
        @attachment.description=params[:attachment][:description]
        @attachment.filename="" # make attachment invalid at first
        updated_content=params[:attachment][:content]
        if updated_content
          if updated_content.respond_to?('original_filename')
            @attachment.filename=updated_content.original_filename
          end
          if updated_content.respond_to?('content_type')
            @attachment.filetype=updated_content.content_type
          end
          if updated_content.respond_to?('read')
            @attachment.content=updated_content.read
          else
            @attachment.content=""
          end
        end
        if @attachment.save
          flash[:success]="Attachment updated"
          redirect_to experiment_path(@attachment.attachable_id)
        else
          @attachment.reload
          @pageTitle="Edit attachment"
          render :edit
        end
      end
    else
      flash[:error]="Attachment not found"
      redirect_to experiment_path(params[:experiment_id])
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
