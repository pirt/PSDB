class CreateClasstypes < ActiveRecord::Migration
  def self.up
    create_table :classtypes, :primary_key_trigger => true,
                 :comment => "List of available class types (such as cam, powermeter, etc.. )" do |t|
      t.string :name, :null => false, :limit => 256, :comment => "Name of the instance class"
    end
  end

  def self.down
    drop_table :classtypes
  end
end
