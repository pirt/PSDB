require 'spec_helper'

describe Attachment do
  before(:each) do
    @attr = { :filename => "hallo.doc", :filetype => "app/word",
              :description => "Experiment proposal", :content => "a"*10000}
  end
  it "should create a new instance given valid attributes" do
    Attachment.create!(@attr)
  end
  it "should have a unique filename per attachable"
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
  it "should reject content larger than 100 kilobytes" do
    largeContent="a"*(100.kilobytes+1)
    no_largeContent_attachment = Attachment.new(@attr.merge(:content => largeContent))
    no_largeContent_attachment.should_not be_valid
  end
end
