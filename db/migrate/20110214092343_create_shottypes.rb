class CreateShottypes < ActiveRecord::Migration
  def self.up
    create_table :shottypes, :primary_key_trigger => true,
                 :comment => "List of available shot types" do |t|
      t.string :name, :null => false, :limit => 30, :comment => "Name of a shot type"
    end
  end

  def self.down
    drop_table :shottypes
  end
end
