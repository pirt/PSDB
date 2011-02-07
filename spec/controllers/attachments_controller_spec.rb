require 'spec_helper'

describe AttachmentsController do
  before(:each) do
    @experiment = Factory(:experiment)
  end
  describe "GET 'show'" do
    before(:each) do
      @attachment = @experiment.attachments.create!(Factory.attributes_for(:attachment))
    end
    it "should be successful" do
      get :show, :id => @attachment
      response.should be_success
    end
    it "should have the right title"
  end
  describe "GET 'new'" do
    describe "for existing experiment" do
      it "should be successful"
      it "should have the right title"
    end
    describe "for non-existing experiment" do
      it "should have an error flash"
      it "should redirect to experiments index"
    end
  end
  describe "POST 'create'" do
    describe "for existing experiment" do
      describe "cancel" do
        it "should not create an attachment"
        it "should have an info flash"
        it "should redirect to experiment"
      end
      describe "failure" do
        it "should not create an attachment"
        it "should have an error flash"
        it "should redirect to the 'new' action"
      end
      describe "success" do
        it "should create an attachment"
        it "should have a succes flash"
        it "should redirect to experiment"
      end
    end
    describe "for non-existing experiment" do
      it "should have an error flash"
      it "should redirect to experiments index"
    end
  end
  describe "GET 'edit" do
    describe "for existing experiment" do
      it "should be successful"
      it "should have the right title"
    end
    describe "for non-existing experiment" do
      it "should have an error flash"
      it "should redirect to experiments index"
    end
  end
  describe "PUT 'update'" do
    describe "existing attachment" do
      describe "cancel" do
        it "should not update an attachment"
        it "should have an info flash"
      end
      describe "failure" do
        it "should not update an attachment"
        it "should have an error flash"
      end
      describe "success" do
        it "should update an attachment"
        it "should have a success flash"
      end
      it "should redirect to experiment"
    end
    describe "non-existing attachment" do
      it "should have an error flash"
      it "should redirect to experiments index"
    end
  end
  describe "DELETE 'destroy'" do
    describe "existing attachment" do
      it "should delete attachment"
      it "should have a success flash"
      it "should redirect to experiment"
    end
    describe "non-existing attachment" do
      it "should have error flash"
    end
  end 
end
