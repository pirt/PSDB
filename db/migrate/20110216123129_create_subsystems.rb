class CreateSubsystems < ActiveRecord::Migration
  def self.up
    create_table :subsystems, :primary_key_trigger => true,
                 :comment => "List of available subsystems (PA, MAS, fsFE,...)" do |t|
      t.string :name, :null => false, :limit => 255, :comment => "name of the subsystem"
      t.timestamps :null => false
    end
    add_index :subsystems, :name, :unique => true
  end

  def self.down
    drop_table :subsystems
  end
end
