# == Schema Information
# Schema version: 20110127161802
#
# Table name: attachments
#
#  id          :integer(38)     not null, primary key
#  filename    :string(255)     not null
#  filetype    :string(50)      not null
#  description :string(255)
#  content     :binary          not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Attachment < ActiveRecord::Base
  attr_accessible :filename, :filetype, :description, :content

  has_many :experiment_attachments
  has_many :experiments, :through => :experiment_attachments

  validates :filename, :presence => true,
                        :length => { :maximum => 255 },
                        :uniqueness => { :case_sensitive => false }
  validates :filetype, :presence => true,
                       :length => { :maximum => 50 }

  validates :description, :length => { :maximum => 255 }

  # validates :content, :presence => true,
  #                    :length => { :maximum => 100.kilobytes }
end
