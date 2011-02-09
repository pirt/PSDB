class CreateShots < ActiveRecord::Migration
  def self.up
    create_table :shots do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :shots
  end
end
