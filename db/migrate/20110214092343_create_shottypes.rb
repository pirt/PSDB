class CreateShottypes < ActiveRecord::Migration
  def self.up
    create_table :shottypes do |t|
      t.string :name, :null => false, :limit => 30
    end
  end

  def self.down
    drop_table :shottypes
  end
end
