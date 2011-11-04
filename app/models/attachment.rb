# This model represents a file attachment. It is connected to a Shot
# or an Experiment using a polymorphic index.
#
# == Schema Information
#
# Table name: attachments
#
#  id              :integer(38)     not null, primary key
#  filename        :string(255)     not null
#  filetype        :string(50)      not null
#  description     :string(255)
#  content         :binary          not null
#  attachable_id   :integer(38)
#  attachable_type :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#
# == Validations
# The following validations exist:
# * The filename (without the file path) must not exceed 255 characters.
# * The description must not exceed 255 characters.
# * The maximum file size is 5 Mb.
class Attachment < ActiveRecord::Base
  attr_accessible :filename, :filetype, :description, :content, :attachable_id, :attachable_type

  belongs_to :attachable, :polymorphic => true

  validates :filename, :presence => true,
                       :length => { :maximum => 255 },
                       :uniqueness => { :scope => [:attachable_id, :attachable_type] }

  validates :filetype, :presence => true,
                       :length => { :maximum => 50 }

  validates :description, :length => { :maximum => 255 }

  @@maxContentSize=5.megabytes

  validates :content, :presence => true,
                      :length => { :maximum => @@maxContentSize }

  # Get size limitations (in bytes) of the content field (=file size) of the Attachments table
  def self.maxContentSize()
    return @@maxContentSize
  end
end
