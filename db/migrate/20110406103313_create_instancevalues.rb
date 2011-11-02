class CreateInstancevalues < ActiveRecord::Migration
  def change
    create_table :instancevalues, :primary_key_trigger => true,
                 :comment => "Actual measurement values of the PCS instances" do |t|
      t.references :instancevalueset, :null => false, :foreign_key => true
      t.references :datatype, :null => false,:foreign_key => true
      t.string :name, :null => false, :limit => 256, :comment => "Measurement parameter name"
      t.float :data_numeric, :comment => "Numeric data value"
      t.string :data_string, :comment => "String data value"
      t.binary :data_binary, :comment => "Binary data value"
      t.timestamps :null => false
    end
    add_index :instancevalues, :instancevalueset_id, :name => "valueset_index"
    add_index :instancevalues, :datatype_id
  end
end
