class CreateClasstypes < ActiveRecord::Migration
  def self.up
    create_table :classtypes, :primary_key_trigger => true,
                 :comment => "List of available class types (such as cam, powermeter, etc.. )" do |t|
      t.string :name, :null => false, :limit => 256, :comment => "Name of the instance class"
<<<<<<< HEAD

      t.timestamps
=======
      t.timestamps :null => false
>>>>>>> f24cb36db55be82eeb0482822fd5f35b4735160b
    end
  end

  def self.down
    drop_table :classtypes
  end
end
