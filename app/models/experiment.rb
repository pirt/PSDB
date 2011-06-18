# == Schema Information
# Schema version: 20110127161802
#
# Table name: experiments
#
#  id          :integer(38)     not null, primary key
#  name        :string(30)      not null
#  description :string(255)     not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Experiment < ActiveRecord::Base
  attr_accessible :name, :description, :active

  # paginate results
  cattr_reader :per_page
  @@per_page = 15

  has_many :shots
  has_many :attachments, :as => :attachable, :dependent => :destroy

  validates :name, :presence => true,
                   :length => { :maximum => 30 },
                   :uniqueness => { :case_sensitive => false }

  validates :description, :presence => true,
                          :length => { :maximum => 255 }

  before_destroy :check_if_shots_associated

  def check_if_shots_associated
    if (!shots.empty?)
      errors.add(:base, "cannot be deleted with shots associated")
      return false
    else
      return true
    end
  end
end
