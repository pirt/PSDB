class CreateExperiments < ActiveRecord::Migration
  def self.up
    create_table :experiments do |t|
      t.string :name,         :null => false, :limit => 30
      t.string :description,  :null => false, :limit => 255

      t.timestamps
    end
    # TODO: check problems with migrations of add_index with mysql2
    # add_index :experiments, :name, :unique => true
  end

  def self.down
    drop_table :experiments
  end
end
