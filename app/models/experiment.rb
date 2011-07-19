# == Schema Information
#
# Table name: experiments
#
#  id          :integer(38)     not null, primary key
#  name        :string(30)      not null
#  active      :boolean(1)      default(TRUE)
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
  def getBeamtimes(minimumTimeBetweenBeamTimes=5.days)
    if self.shots.empty? 
      return []
    end
    queryString="
        select nextTable.created_at as t1,
               currentTable.created_at as t2,
               currentTable.id as currentid,
               nextTable.id as nextid
        from (select * from shots where experiment_id=%d) currentTable
      	join (select * from shots where experiment_id=%d) nextTable
       	on nextTable.id=(select min(id) from
         	(select * from shots where experiment_id=%d) dummyTable where id>currentTable.id)" % [self.id,self.id,self.id]
    durations=Shot.find_by_sql(queryString)
    beamtimes=[]
    beamtime={:firstId=>self.shots.first.id}
    durations.each do |d|
      difference=d.t1-d.t2
      if(difference>minimumTimeBetweenBeamTimes)
        beamtime[:lastId]=d.currentid
        beamtimes << beamtime
        beamtime={:firstId=>d.nextid}
      end
    end
    beamtime[:lastId]=self.shots.last.id
    beamtimes << beamtime
    return beamtimes
  end
end

