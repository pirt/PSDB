class ExperimentOwner < ActiveRecord::Base
  attr_accessible :experiment_id, :user_id

  belongs_to :experiment
  belongs_to :user

  # check for reference to an existing experiment / user
  # this also checks the presence of experiment_id and shottype_id

  validates :experiment, :presence => true

  validates :user, :presence => true

  validates :user_id, :uniqueness => {:scope => :experiment_id}
end
