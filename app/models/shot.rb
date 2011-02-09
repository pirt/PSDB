# == Schema Information
# Schema version: 20110209132953
#
# Table name: shots
#
#  id            :integer(38)     not null, primary key
#  comment       :string(255)
#  experiment_id :integer(38)     not null
#  shottype_id   :integer(38)     not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Shot < ActiveRecord::Base
end
