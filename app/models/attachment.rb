# == Schema Information
# Schema version: 20110127161802
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

class Attachment < ActiveRecord::Base
  attr_accessible :filename, :filetype, :description, :content

  belongs_to :attachable, :polymorphic => true
 
  validates :filename, :presence => true,
                       :length => { :maximum => 255 },
                       :uniqueness => { :scope => [:attachable_id, :attachable_type] }

  validates :filetype, :presence => true,
                       :length => { :maximum => 50 }

  validates :description, :length => { :maximum => 255 }

  validates :content, :presence => true,
                      :length => { :maximum => 100.kilobytes }
end
