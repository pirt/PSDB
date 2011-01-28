require 'spec_helper'

describe Attachment do
  before(:each) do
    @attr = { :filename => "hallo.doc", :filetype => "app/word",
              :description => "Experiment proposal", :content => "a"*10000}
  end
  it "should create a new instance given valid attributes" do
    Attachment.create!(@attr)
  end

  it "should require a filename"
  it "should require a filetype"
  it "should require a content"

  it "should have a unique (case insensitive) name"
  it "should have a unique index on filename column"

  it "should reject filenames that are longer than 255 characters"
  it "should reject descriptions that are longer than 255 characters"
  it "should reject filetypes that are longer than 255 characters"
  it "should reject content larger than 50 megabytes"

end
