# This model represents an experiment to which a Shot can refer to.
# Experiments can only be created, modified, and deleted using the web
# interface. Furthermore file attachments can be added.
#
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
# == Validations
# The following validations exist:
# * The name (such as +P043+) must be unique.
# * The name must not exceed 30 characters.
# * The description must not exceed 255 characters.
# * It cannot be deleted if a Shot refers to it.
#
class Experiment < ActiveRecord::Base

  attr_accessible :name, :description, :active

  # paginate results
  cattr_reader :per_page
  @@per_page = 15

  has_many :shots
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :experiment_owners, :dependent => :destroy
  has_many :users, :through => :experiment_owners

  validates :name, :presence => true,
                   :length => { :maximum => 30 },
                   :uniqueness => { :case_sensitive => false }

  validates :description, :presence => true,
                          :length => { :maximum => 255 }

  before_destroy :check_if_shots_associated

# Return a list of beam times. A beam time is a period of time in which shots
# are refered to this experiment. The beam time start with the date of the first
# shot referring this experiment. If two shots are more than a given time separated
# from each other this is interpreted as a new beam time of the same experiment.
# This functions returns an array of hash lists of the found beam times.
#
# Example of a return value:
#  beamtimes=[{:firstId=1,:lastId=>10,:firstDate=>1.1.2010,:lastDate=>4.1.2010},
#             {:firstId=20,:lastId=>25, :firstDate=>8.2.2010,:lastDate=>9.2.2010}]
# This experiment would have two beam times. One in january and one in february 2010.
#
# minimumTimeBetweenBeamTimes::
# if two shot dates are separated more than this time they are accounted to a new
# beam time.
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
    beamtime={:firstId=>self.shots.first.id, :firstDate=>self.shots.first.created_at}
    durations.each do |d|
      difference=d.t1-d.t2
      if(difference>minimumTimeBetweenBeamTimes)
        beamtime[:lastId]=d.currentid
        beamtime[:lastDate]=d.t2
        beamtimes << beamtime
        beamtime={:firstId=>d.nextid, :firstDate=>d.t1}
      end
    end
    beamtime[:lastId]=self.shots.last.id
    beamtime[:lastDate]=self.shots.last.created_at
    beamtimes << beamtime
    return beamtimes
  end
# Return the name of the experiment. This function was added to simplify views.
  def to_s
    return self.name
  end

private
  def check_if_shots_associated
    if (!shots.empty?)
      errors.add(:base, "cannot be deleted with shots associated")
      return false
    else
      return true
    end
  end
end

