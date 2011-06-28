require 'spec_helper'

describe Attachment do
  before(:each) do
    @attr = { :filename => "hallo.doc", :filetype => "app/word",
              :description => "Experiment proposal", :content => "a"*10000,
              :attachable_id => "1", :attachable_type => "testparent"}
  end
  it "should create a new instance given valid attributes" do
    Attachment.create!(@attr)
  end
  describe "unique filename" do
    it "should have a unique filename per attachable" do
      Attachment.create!(@attr)
      duplicate_attachment=Attachment.new(@attr)
      duplicate_attachment.should_not be_valid
    end
    it "should allow double filenames with different attachment id" do
      Attachment.create!(@attr)
      duplicate_attachment=Attachment.new(@attr.merge(:attachable_id => "2"))
      duplicate_attachment.should be_valid
    end
    it "should allow double filenames with different attachment type" do
      Attachment.create!(@attr)
      duplicate_attachment=Attachment.new(@attr.merge(:attachable_type => "other parent"))
      duplicate_attachment.should be_valid
    end
  end
  it "should require a filename" do
    no_filename_attachment = Attachment.new(@attr.merge(:filename => ""))
    no_filename_attachment.should_not be_valid
  end
  it "should require a filetype" do
    no_filetype_attachment = Attachment.new(@attr.merge(:filetype => ""))
    no_filetype_attachment.should_not be_valid
  end
  it "should require a content" do
    no_content_attachment = Attachment.new(@attr.merge(:content => ""))
    no_content_attachment.should_not be_valid
  end
  it "should reject filenames that are longer than 255 characters" do
    longFilename="a"*256
    no_longFilename_attachment = Attachment.new(@attr.merge(:filename => longFilename))
    no_longFilename_attachment.should_not be_valid
  end
  it "should reject descriptions that are longer than 255 characters" do
    longDescription="a"*256
    no_longDescription_attachment = Attachment.new(@attr.merge(:description => longDescription))
    no_longDescription_attachment.should_not be_valid
  end
  it "should reject filetypes that are longer than 255 characters" do
    longFiletype="a"*256
    no_longFiletype_attachment = Attachment.new(@attr.merge(:filetype => longFiletype))
    no_longFiletype_attachment.should_not be_valid
  end
  it "should reject content larger than model limit" do
    maxContentSize=Attachment.maxContentSize
    largeContent="a"*(maxContentSize+1)
    largeContent_attachment = Attachment.new(@attr.merge(:content => largeContent))
    largeContent_attachment.should_not be_valid
  end
end
