# This restful controller handles upload, download, modification and deletion
# of file attachments. Currently attachments can be used for experiments and shots.
class AttachmentsController < ApplicationController
  def show
    attachment=Attachment.find_by_id(params[:id])
    if !attachment
      flash[:error]="Attachment not found"
      redirect_to experiment_path(:experiment_id)
      return
    end
      send_data attachment.content, :type => attachment.filetype, :filename => attachment.filename
  end
  def new
      if params[:experiment_id]
        @parent=Experiment.find_by_id(params[:experiment_id])
      elsif params[:shot_id]
        @parent=Shot.find_by_id(params[:shot_id])
      end
      @attachment=@parent.attachments.new
      @pageTitle="Add attachment"
  end
  def create
    if params[:experiment_id]
      @parent=Experiment.find_by_id(params[:experiment_id])
    elsif params[:shot_id]
       @parent=Shot.find_by_id(params[:shot_id])
    else
      flash[:error]="No experiment or shot selected."
      redirect_to :experiments
    end
    if !@parent
      flash[:error]="Experiment or shot not found"
      redirect_to experiments_path
      return
    end
    if params[:cancel]
      flash[:info]="Attachment creation cancelled"
      redirect_to polymorphic_path(@parent)
      return
    end
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
      if params[:shot_id]
        expire_fragment('shotline'+params[:shot_id].to_s)
      end
      flash[:success]="Attachment created"
      redirect_to polymorphic_path(@parent)
    else
      @pageTitle="Add attachment"
      render 'new'
    end
  end
  def edit
    if params[:experiment_id]
      @parent=Experiment.find_by_id(params[:experiment_id])
    elsif params[:shot_id]
       @parent=Shot.find_by_id(params[:shot_id])
    end
    @attachment=Attachment.find_by_id(params[:id])
    if !@attachment
      flash[:error]="Attachment not found"
      redirect_to polymorphic_path(@parent)
      return
    end
    @pageTitle="Edit attachment"
  end
  def update
    if params[:experiment_id]
      @parent=Experiment.find_by_id(params[:experiment_id])
    elsif params[:shot_id]
       @parent=Shot.find_by_id(params[:shot_id])
    end
    @attachment=Attachment.find_by_id(params[:id])
    if !@attachment
      flash[:error]="Attachment not found"
      redirect_to polymorphic_path(@parent)
      return
    end
    if params[:cancel]
      flash[:info]="Attachment update cancelled"
      redirect_to polymorphic_path(@parent)
      return
    end
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
      redirect_to polymorphic_path(@parent)
    else
      @attachment.reload
      @pageTitle="Edit attachment"
      render :edit
    end
  end
  def destroy
    if params[:experiment_id]
      @parent=Experiment.find_by_id(params[:experiment_id])
    elsif params[:shot_id]
      @parent=Shot.find_by_id(params[:shot_id])
    end
    attachment=Attachment.find_by_id(params[:id])
    if !attachment
      flash[:error] = "Attachment not found"
    else
      if attachment.destroy
        flash[:success] = "Attachment successfully deleted"
      else
        flash[:error] = "Error while deleting attachment"
      end
    end
    redirect_to polymorphic_path(@parent)
  end
end

