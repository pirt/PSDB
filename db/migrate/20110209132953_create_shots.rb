class CreateShots < ActiveRecord::Migration
  def self.up
    create_table :shots, :comment => "A PHELIX shot belonging to an experiment. All mesurement data reference this" do |t|
      t.string :comment, :limit => 255
      t.references :experiment, :null => false
      t.references :shottype, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :shots
  end
end
