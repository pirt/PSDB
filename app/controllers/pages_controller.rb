# This controller ist repsonsible for serving (mostly) static pages.
class PagesController < ApplicationController
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

