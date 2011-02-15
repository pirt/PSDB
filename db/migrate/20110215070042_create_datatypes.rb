class CreateDatatypes < ActiveRecord::Migration
  def self.up
    create_table :datatypes, :comment => "List of available data types (numeric, string, image,...)" do |t|
      t.string :name, :null => false, :limit => 30, :comment => "Name of the data type"
    end
  end

  def self.down
    drop_table :datatypes
  end
end
