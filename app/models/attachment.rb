# == Schema Information
# Schema version: 20110127161802
#
# Table name: attachments
#
#  id          :integer(38)     not null, primary key
#  filename    :string(255)     not null
#  filetype    :string(255)     not null
#  description :string(255)
#  content     :binary          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Attachment < ActiveRecord::Base
end
