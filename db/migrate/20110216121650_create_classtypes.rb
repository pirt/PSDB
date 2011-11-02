class CreateClasstypes < ActiveRecord::Migration
  def change
    create_table :classtypes, :primary_key_trigger => true,
                 :comment => "List of available class types (such as cam, powermeter, etc.. )" do |t|
      t.string :name, :null => false, :limit => 256, :comment => "Name of the instance class"
      t.timestamps :null => false
    end
    add_index :classtypes, :name, :unique => true
  end
end
