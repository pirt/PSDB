class ExperimentAttachment < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :attachment
end
