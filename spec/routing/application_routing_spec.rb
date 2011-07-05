require "spec_helper"

describe "PSDB" do
  it "routes default to pages#start" do
    get("/").should route_to("pages#start")
  end
end

#  get "instancevalues/exportImage"
#  get "instancevalues/exportPlot"

#  get "statistics/overview"
#  get "statistics/calendar"


#  get "pages/about"
#  get "pages/changelog"
