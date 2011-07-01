class PagesController < ApplicationController
  def start
    @pageTitle=""
  end
  def about
    @pageTitle="About"
  end
  def changelog
    @pageTitle="Changelog"
  end
end
