# This controller ist repsonsible for serving (mostly) static pages.
class PagesController < ApplicationController
  filter_access_to :all

  def start
    @pageTitle=""
  end
  def about
    @pageTitle="About"
    render projectizeName("about")
  end
  def changelog
    @pageTitle="Changelog"
  end
end

