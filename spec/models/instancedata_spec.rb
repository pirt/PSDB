require 'spec_helper'

describe Instancedata do
  before(:each) do
    @experiment=Factory(:experiment)
    @shottype=Factory(:shottype)
    @attr=Factory.attributes_for(:shot)
    @attr=@attr.merge(:shottype_id => @shottype.id)
  end
end
