class CreateExperimentAttachments < ActiveRecord::Migration
  def self.up
    create_table :experiment_attachments, :comment => "Relation between experiments and attachments" do |t|
      t.references :experiment, :null => false # , :foreign_key => true
      t.references :attachment, :null => false # , :foreign_key => true
      t.timestamps
    end
  end

  def self.down
    drop_table :experiment_attachments
  end
end
