class CreateShots < ActiveRecord::Migration
  def change
    create_table :shots, :primary_key_trigger => true,
                 :comment => "A PHELIX shot belonging to an experiment. All mesurement data reference this" do |t|
      t.string :description, :limit => 255, :comment => "Description of a PHELIX shot"
      t.references :experiment, :null => false, :foreign_key => true
      t.references :shottype, :null => false, :foreign_key => true
      t.references :configuration_id
      t.integer :status
      t.timestamps :null => false
    end

    add_index :shots, :experiment_id
    add_index :shots, :shottype_id
  end
end
