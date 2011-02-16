class CreateSubsystems < ActiveRecord::Migration
  def self.up
    create_table :subsystems, :comment => "List of available subsystems (PA, MAS, fsFE,...)" do |t|
      t.string :name, :null => false, :limit => 255, :comment => "name of the subsystem"
    end
  end

  def self.down
    drop_table :subsystems
  end
end
