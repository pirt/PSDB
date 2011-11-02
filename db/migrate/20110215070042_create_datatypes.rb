class CreateDatatypes < ActiveRecord::Migration
  def change
    create_table :datatypes, :primary_key_trigger => true,
                 :comment => "List of available data types (numeric, string, image,...)" do |t|
      t.string :name, :null => false, :limit => 30, :comment => "Name of the data type"
      t.timestamps :null => false
    end
    add_index :datatypes, :name, :unique => true
  end
end
