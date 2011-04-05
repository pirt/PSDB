class CreateInstancedatasets < ActiveRecord::Migration
  def self.up
    create_table :instancedatasets do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :instancedatasets
  end
end
