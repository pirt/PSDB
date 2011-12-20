class CreateExperimentOwners < ActiveRecord::Migration
  def change
    create_table :experiment_owners do |t|
      t.references :experiment
      t.references :user
    end
  end
end
