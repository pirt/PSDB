require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
        :content => "PHELIX shot database | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
        :content => "PHELIX shot database | About")
    end
  end
end
