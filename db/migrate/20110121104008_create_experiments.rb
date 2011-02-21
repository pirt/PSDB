class CreateExperiments < ActiveRecord::Migration
  def self.up
    create_table :experiments, :primary_key_trigger => true,
                 :comment => "Available PHELIX Experiments" do |t|
      t.string :name, :comment => "Short name of experiment (such as P039)", :null => false, :limit => 30
      t.string :description,  :comment => "Description or title of the experiment", :null => false, :limit => 255

      t.timestamps :null => false
    end
    # TODO: check problems with migrations of add_index with mysql2
    add_index :experiments, :name, :unique => true
  end

  def self.down
    drop_table :experiments
  end
end
