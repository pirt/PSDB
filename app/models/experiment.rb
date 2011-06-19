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
  def getBeamtimes
    queryString="
        select nextTable.created_at as t1,
               currentTable.created_at as t2,
               currentTable.id as currentid,
               nextTable.id as nextid
        from (select * from shots where experiment_id=%d) currentTable
      	join (select * from shots where experiment_id=%d) nextTable
       	on nextTable.id=(select min(id) from
         	(select * from shots where experiment_id=%d) where id>currentTable.id)" % [self.id,self.id,self.id]
    durations=Shot.find_by_sql(queryString)
    minimumTimeBetweenBeamTimes=5.days
    if self.shots.exists?
      beamtimes=[{:firstId => self.shots.first.id}]
      if (!durations.empty?)
        (0..(durations.length-1)).each do |i|
          difference=durations[i].t1-durations[i].t2
          if (difference>minimumTimeBetweenBeamTimes and i<durations.length-1)
            beamtimes[beamtimes.length-1]=beamtimes.last.merge(:lastId => durations[i].currentid)
            beamtimes << {:firstId => durations[i].nextid}
          end
        end
      end
      beamtimes[beamtimes.length-1]=beamtimes.last.merge(:lastId => self.shots.last.id)
      return beamtimes
    end
  end
end
