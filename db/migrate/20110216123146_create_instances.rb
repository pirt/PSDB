class CreateInstances < ActiveRecord::Migration
  def self.up
    create_table :instances, :primary_key_trigger => true,
                 :comment => "List of available instances (devices) (PA_Input_NF_Cam,...)" do |t|
      t.references :classtype, :null => false
      t.references :subsystem, :null => false
      t.string :name, :null => false, :limit => 255, :comment => "name of the instance"
     
      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :instances
  end
end
