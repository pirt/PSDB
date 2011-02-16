class CreateInstancedatas < ActiveRecord::Migration
  def self.up
    create_table :instancedatas, :comment => "Actual measurement data of the PCS instances" do |t|
      t.references :shot, :null => false #, :foreign_key => true
      t.references :instance, :null => false #,:foreign_key => true
      t.references :datatype, :null => false #,:foreign_key => true
      t.string :name, :null => false, :limit => 256, :comment => "Measurement parameter name"
      t.float :data_numeric, :comment => "Numeric data value"
      t.string :data_string, :comment => "String data value"
      t.binary :data_binary, :comment => "Binary data value"
      t.timestamps
    end
  end

  def self.down
    drop_table :instancedatas
  end
end
