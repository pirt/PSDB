class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments, :primary_key_trigger => true,
                 :comment => "Available PHELIX Experiments" do |t|
      t.string :name, :comment => "Short name of experiment (such as P039)", :null => false, :limit => 30
      t.boolean :active, :comment => "Is the experiment active or finished?", :default => true
      t.string :description,  :comment => "Description or title of the experiment", :null => false, :limit => 255

      t.timestamps :null => false
    end
    add_index :experiments, :name, :unique => true
  end
end
