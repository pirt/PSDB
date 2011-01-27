class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments, :comment => "table for storing file attachements to experiments and shots" do |t|
      t.string :filename, :null => false, :comment => "A unique filename"
      t.string :filetype, :null => false, :comment => "The MIME type of the file"
      t.string :description, :comment => "A description of the file"
      t.binary :content, :null => false, :comment => "the actual (binary) content"
      t.timestamps
    end

      add_index :attachments, :filename, :unique => true
  end

  def self.down
    drop_table :attachments
  end
end
