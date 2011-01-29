require 'spec_helper'

describe AttachmentsController do
  describe "POST 'create'" do
    describe "failure" do
      it "should not create an attachment"
    end
    describe "success" do
      it "should create an attachment"
    end
  end
  describe "PUT 'update'" do
    describe "failure" do
      it "should not update an attachment"
    end
    describe "success" do
      it "should update an attachment"
    end
  end
  describe "DELETE 'destroy'" do
    describe "existing attachment" do
      it "should delete attachment"
      it "should redirect to experiment"
    end
    describe "non-existing attachment" do
      it "should have error flash"
    end
  end 
end
