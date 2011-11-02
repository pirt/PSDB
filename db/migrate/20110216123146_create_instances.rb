class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances, :primary_key_trigger => true,
                 :comment => "List of available instances (devices) (PA_Input_NF_Cam,...)" do |t|
      t.references :classtype, :null => false, :foreign_key => true
      t.references :subsystem, :null => false, :foreign_key => true
      t.string :name, :null => false, :limit => 255, :comment => "name of the instance"

      t.timestamps :null => false
    end
    add_index :instances, :name, :unique => true
    add_index :instances, :classtype_id
    add_index :instances, :subsystem_id
  end
end
