class CreateInstancevaluesets < ActiveRecord::Migration
  def self.up
    create_table :instancevaluesets, :primary_key_trigger => true,
                 :comment => "A set of measurements from a given instance for a given shot" do |t|
      t.references :shot, :null => false, :foreign_key => true
      t.references :instance, :null => false,:foreign_key => true
      t.integer :version, :null => false, :comment => "Version number of the interface"
      t.timestamps
    end
    add_index :instancevaluesets, :shot_id
    add_index :instancevaluesets, :instance_id
  end

  def self.down
    drop_table :instancevaluesets
  end
end
