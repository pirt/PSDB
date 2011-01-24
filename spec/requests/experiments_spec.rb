require 'spec_helper'

describe "Experiment" do
  describe "Add new" do
    describe "failure" do
      it "should not create a new experiment" do
        lambda do
          visit new_experiment_path
          fill_in "Name",        :with => ""
          fill_in "Description", :with => ""
          click_button
          response.should render_template('experiments/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(Experiment, :count)
      end
    end
    describe "success" do
      it "should create a new experiment" do
        lambda do
          visit new_experiment_path
          fill_in "Name",        :width => "P0010"
          fill_in "Description", :width => "The Description"
          click_button
          responde.should have_selector("div.flash.success", :content => "created")
          response.should render_template('users')
        end.should change(Experiment, :count).by(1)
      end
    end
  end
end
