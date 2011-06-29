class CreateShottypes < ActiveRecord::Migration
  def self.up
    create_table :shottypes, :primary_key_trigger => true,
                 :comment => "List of available shot types" do |t|
      t.string :name, :null => false, :limit => 30, :comment => "Name of a shot type"
      t.timestamps :null => false
    end
    add_index :shottypes, :name, :unique => true
  end

  def self.down
    drop_table :shottypes
  end
end
