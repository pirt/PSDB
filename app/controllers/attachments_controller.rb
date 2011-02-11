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
      @attachment=Attachment.new
      @pageTitle="Add attachment"
  end
  def create
    if params[:experiment_id]
      @parent=Experiment.find_by_id(params[:experiment_id])
    elsif params[:shot_id]
       @parent=Shot.find_by_id(params[:shot_id])
    else
      flash[:error]="No experiment / shot selected."
      redirect_to :experiments
    end
    parentPath="/#{@parent.class.to_s.downcase}s/#{@parent.id}"
    if !@parent
      flash[:error]="Experiment / shot not found"
      redirect_to experiments_path
      return
    end
    if params[:cancel]
      flash[:info]="Attachment creation cancelled"
      redirect_to parentPath
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
      flash[:success]="Attachment created"
      redirect_to parentPath
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
    parentPath="/#{@parent.class.to_s.downcase}s/#{@parent.id}"
    @attachment=Attachment.find_by_id(params[:id])
    if !@attachment
      flash[:error]="Attachment not found"
      redirect_to parentPath
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
    parentPath="/#{@parent.class.to_s.downcase}s/#{@parent.id}"
    @attachment=Attachment.find_by_id(params[:id])
    if !@attachment
      flash[:error]="Attachment not found"
      redirect_to parentPath
      return
    end
    if params[:cancel]
      flash[:info]="Attachment update cancelled"
      redirect_to parentPath
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
      redirect_to parentPath
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
    parentPath="/#{@parent.class.to_s.downcase}s/#{@parent.id}"
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
    redirect_to parentPath
  end
end
