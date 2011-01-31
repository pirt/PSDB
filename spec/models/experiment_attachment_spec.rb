require 'spec_helper'

describe ExperimentAttachment do
  before(:each) do
    @experiment=Factory(:experiment)
    @attr = { :filename => "hallo.doc", :filetype => "app/word",
              :description => "Experiment proposal", :content => "a"*10000}
  end
  it "should create an instance through experiment <-> attachment relation"
  it "should not create an instance of a second identical exp <-> attachment relation"
end
