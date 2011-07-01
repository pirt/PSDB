require 'spec_helper'

# define a mock object representing an uploaded file
class Mockfile
  def initialize(filename="test.png",content="abcd")
    @filename=filename
    @content=content
  end

  def original_filename
    @filename
  end
  def content_type
    'image'
  end
  def read
    @content
  end
end

describe AttachmentsController do
  render_views

  # login to http basic auth
  include AuthHelper
  before(:each) do
    http_login
  end

  before(:all) do
    @experiment = Factory(:experiment)
    @nonExistingId=@experiment.id+1
  end
  after(:all) do
    @experiment.destroy
  end
  describe "GET 'show'" do
    before(:each) do
        @attachment = @experiment.attachments.create!(Factory.attributes_for(:attachment))
    end
    describe "for existing attachment" do
      it "should be successful" do
        get :show, :experiment_id => @experiment, :id => @attachment
        response.should be_success
      end
    end
    describe "for non-existing attachment" do
      before(:each) do
        @nonExistingAttachmentId=@attachment.id+1
      end
      it "should have an error flash message" do
        get :show, :experiment_id => @experiment, :id => @nonExistingAttachmentId
        flash[:error].should =~ /Attachment not found/i
      end
      it "should redirect to experiment" do
        get :show, :experiment_id => @experiment, :id => @nonExistingAttachmentId
        response.should redirect_to experiment_path(:experiment_id)
      end
    end
  end
  describe "GET 'new'" do
    it "should be successful" do
      get :new, :experiment_id => @experiment
      response.should be_success
    end
    it "should have the right title" do
      get :new, :experiment_id => @experiment
      response.should have_selector("title",
      :content => "Add attachment")
    end
  end
  describe "POST 'create'" do
    describe "for existing experiment" do
      describe "cancel" do
        it "should not create an attachment" do
          lambda do
            post :create, :experiment_id => @experiment, :cancel => "1"
          end.should_not change(Attachment, :count)
        end
        it "should have an info flash" do
          post :create, :experiment_id => @experiment, :cancel => "1"
          flash[:info].should =~ /Attachment creation cancelled/i
        end
        it "should redirect to experiment" do
          post :create, :experiment_id => @experiment, :cancel => "1"
          response.should redirect_to(experiment_path(@experiment))
        end
      end
      describe "failure" do
        before(:each) do
          @attr = {:content => "", :description => ""}
        end
        it "should not create an attachment" do
          lambda do
            post :create, :experiment_id => @experiment, :attachment => @attr
          end.should_not change(Attachment, :count)
        end
        it "should have the right title" do
          post :create, :experiment_id => @experiment, :attachment => @attr
          response.should have_selector("title", :content => "Add attachment")
        end
        it "should render the 'new' page" do
          post :create, :experiment_id => @experiment, :attachment => @attr
          response.should render_template('new')
        end
      end
      describe "success" do
        before(:each) do
          @attr = {:content => Mockfile.new, :description => ""}
        end
        it "should create an attachment" do
          lambda do
            post :create, :experiment_id => @experiment, :attachment => @attr
          end.should change(Attachment, :count).by(1)
        end
        it "should have a success flash message" do
          post :create, :experiment_id => @experiment, :attachment => @attr
          flash[:success].should =~ /Attachment created/i
        end
        it "should redirect to experiment" do
          post :create, :experiment_id => @experiment, :attachment => @attr
          response.should redirect_to(experiment_path(@experiment))
        end
      end
    end
    describe "for non-existing experiment" do
      it "should have an error flash" do
        post :create, :experiment_id => @nonExistingId
        flash[:error].should =~ /Experiment or shot not found/i
      end
      it "should redirect to experiments index" do
        post :create, :experiment_id => @nonExistingId
        response.should redirect_to(experiments_path)
      end
    end
  end
  describe "GET 'edit" do
    before(:each) do
      @attachment = @experiment.attachments.create!(Factory.attributes_for(:attachment))
    end
    describe "for existing attachment" do
      it "should be successful" do
        get :edit, :experiment_id => @experiment, :id => @attachment
        response.should be_success
      end
      it "should have the right title" do
        get :edit, :experiment_id => @experiment, :id => @attachment
        response.should have_selector("title",
                                      :content => "Edit attachment")
      end
    end
    describe "for non-existing attachment" do
      before(:each) do
        @nonExistingAttachmentId=@attachment.id+1
      end
      it "should have an error flash" do
        get :edit, :experiment_id => @experiment, :id => @nonExistingAttachmentId
        flash[:error].should =~ /Attachment not found/i
      end
      it "should redirect to experiments index" do
        get :edit, :experiment_id => @experiment, :id => @nonExistingAttachmentId
        response.should redirect_to(experiment_path(@experiment))
      end
    end
  end
  describe "PUT 'update'" do
    before(:each) do
      @attachment = @experiment.attachments.create!(Factory.attributes_for(:attachment))
    end
    describe "existing attachment" do
      describe "cancel" do
        it "should not update an attachment" do
          lambda do
            put :update, :experiment_id => @experiment, :id => @attachment, :cancel => 1
          end.should_not change(Attachment, :all)
        end
        it "should have an info flash" do
          put :update, :experiment_id => @experiment, :id  => @attachment, :cancel => 1
          flash[:info].should =~ /Attachment update cancelled/i
        end
      end
      describe "failure" do
        before(:each) do
          @attr = {:content => "", :description => ""}
        end
        it "should not update an attachment" do
          lambda do
            put :update, :experiment_id => @experiment, :id => @attachment, :attachment => @attr
          end.should_not change(Attachment, :all)
        end
        it "should set the right title" do
          put :update, :experiment_id => @experiment, :id => @attachment, :attachment => @attr
          response.should have_selector("title",
                                      :content => "Edit attachment")
        end
        it "should render the 'edit' page" do
          put :update, :experiment_id => @experiment, :id => @attachment, :attachment => @attr
          response.should render_template('edit')
        end
      end
      describe "success" do
        before(:each) do
          @attr = {:content => Mockfile.new("test2.png","fghij"), :description => "abcd"}
        end
        it "should update an attachment" do
          put :update, :experiment_id => @experiment, :id => @attachment, :attachment => @attr
          @attachment.reload
          mockfile=@attr[:content]
          @attachment.filename.should  == mockfile.original_filename
          @attachment.filetype.should == mockfile.content_type
          @attachment.content.should == mockfile.read
          @attachment.description.should  == @attr[:description]
          @attachment.attachable_id.should == @experiment.id
        end
        it "should have a success flash" do
          put :update, :experiment_id => @experiment, :id => @attachment, :attachment => @attr
          flash[:success].should =~ /Attachment updated/i
        end
        it "should redirect to experiment" do
          put :update, :experiment_id => @experiment, :id => @attachment, :attachment => @attr
          response.should redirect_to(experiment_path(@experiment))
        end
      end
    end
    describe "non-existing attachment" do
      before(:each) do
        @nonExistingAttachmentId=@attachment.id+1
      end
      it "should have an error flash" do
        put :update, :experiment_id => @experiment, :id => @nonExistingAttachmentId
        flash[:error].should =~ /Attachment not found/i
      end
      it "should redirect to experiments index" do
        put :update, :experiment_id => @experiment, :id => @nonExistingAttachmentId
        response.should redirect_to experiment_path(@experiment)
      end
    end
  end
  describe "DELETE 'destroy'" do
    before(:each) do
      @attachment = @experiment.attachments.create!(Factory.attributes_for(:attachment))
    end
    describe "existing attachment" do
      it "should delete attachment" do
        lambda do
          delete :destroy, :experiment_id => @experiment, :id => @attachment
        end.should change(Attachment, :count).by(-1)
      end
      it "should have a success flash" do
        delete :destroy, :experiment_id => @experiment, :id => @attachment
        flash[:success].should =~ /Attachment successfully deleted/i
      end
      it "should redirect to experiment" do
        delete :destroy, :experiment_id => @experiment, :id => @attachment
        response.should redirect_to(experiment_path(@experiment))
      end
    end
    describe "non-existing attachment" do
      before(:each) do
        @nonExistingAttachmentId=@attachment.id+1
      end
      it "should have error flash" do
        delete :destroy, :experiment_id => @experiment, :id => @nonExistingAttachmentId
        flash[:error].should =~ /Attachment not found/i
      end
      it "should redirect to experiment" do
        delete :destroy, :experiment_id => @experiment, :id => @nonExistingAttachmentId
        response.should redirect_to(experiment_path(@experiment))
      end
    end
  end 
end
