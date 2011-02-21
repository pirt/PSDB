require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    #
    nrOfExperiments=2
    maxNrOfShotsPerExperiment=10
    #
    #Rake::Task['db:reset'].invoke
      
    createExperiments(nrOfExperiments)

    shotTypes=["experiment shot","test shot","snapshot","other"]
    createShottypes(shotTypes)

    createShots(maxNrOfShotsPerExperiment,shotTypes)

    createDataTypes

    # generate instances, subsystems and classtypes (typically 100)

    instances=["fsFE_BB", "fsFE_Shut_PA_BB", "fsFE_SwitchYLF_BB",
               "PA_Input_FF_Cam", "PA_Input_NF_Cam", "PA_Exit_FF_Cam", "PA_Exit_Powermeter",
               "PPPA_19_1_PU", "PPPA_19_2_PU", "PPPA_45_PU", 
               "MA_InjectIn_Cam", "MA_InjectOut_Cam", "MA_CH1_BB", "MA_CH2_BB", "MA_CH3_BB", "MA_CH4_BB",
               "PPMA_1_PU", "PPMA_2_PU", "PPMA_3_PU", "PPMA_4_PU", "PPMA_5_PU",
               "MAS_Powermeter", "MAS_Spectrometer", "MAS_Filt1_BB", "MAS_Filt2_BB", "MAS_Filt3_BB",
               "COS_FF_Cam", "COS_NF_Cam", "COS_Filt1_BB", "COS_Filt2_BB", "COS_Filt3_BB", ]

    createInstances(instances)
    
    
    # generate instance data (typically 10 per instance)
    classParams={'Cam' => ["brightness_n","shutter_n","gain_n","image_i","serial_s","paramA_s", "paramB_n", "paramC_n"], 
                 'Powermeter' => ["serial_s","range_s","energy_n", "paramD_s", "paramE_n", "paramF_n", "paramG_n"],
                 'PU' => ["voltage_n","current_curve_sp", "param14_s", "param15_s", "param16_n", "param17_n", "param18_n"],
                 'BB' => ["in_n","out_n","direction_n", "param18_n", "param19_n"],
                 'Spectrometer' => ["integrationtime_n","spectrum_sp","serial_s", "param20_s", "param21_n", "param22_n"]
                }

    Shot.find_each do |shot|
      puts "Creating measurement data for shot #{shot.id}"
      Instance.find_each do |instance|
	      probabilityInstanceExists=rand()
	      if (probabilityInstanceExists>0.5)
          classType=instance.classtype.name
	        classParams[classType].each do |classParam|
            classParamType=classParam.split("_").last
            classParamName=classParam.split("_").first
            case classParamType
              when "s"
                data_string=fillStringData()
                dataTypeId=Datatype.find_by_name("string").id
              when "n"
                data_numeric=fillNumericData()
                dataTypeId=Datatype.find_by_name("numeric").id
              when "i"
                #data_binary=fillImageData()
                #dataTypeId=Datatype.find_by_name("image").id
                data_binary=fillNumericData()
                dataTypeId=Datatype.find_by_name("numeric").id
	            when "sp"
                data_binary=fillSpectrumData()
                dataTypeId=Datatype.find_by_name("spectrum").id
            end
            Instancedata.create!(:shot_id => shot.id, 
                                 :instance_id => instance.id,
                                 :name => classParamName,
                                 :datatype_id => dataTypeId,
                                 :data_string => data_string,
                                 :data_numeric => data_numeric,
                                 :data_binary => data_binary)
          end
	      end
      end
    end
  end
end
def createShottypes(shotTypes)
  puts "Generate shot types:"
  shotTypes.each do |shottype|
    puts "Generate shot type <#{shottype}>"
    Shottype.create!(:name => shottype)
  end
end
def createShots(maxNrOfShotsPerExperiment,shotTypes)
  Experiment.find_each do |experiment|
    nrOfShots=1+rand(maxNrOfShotsPerExperiment)
    (1..nrOfShots).each do |s|
      comment= Faker::Lorem.sentence(4)
      shottypeName=shotTypes[rand(shotTypes.length)]
	    shottypeId=Shottype.find_by_name(shottypeName).id
      shot=experiment.shots.create!(:description => comment , :shottype_id => shottypeId)
      puts "Created Shot #{shot.id}"
    end
  end
end
def createInstances(instances)
  instances.each do |instance|
    instanceParts=instance.split("_")
    subsystemName=instanceParts.first
    classtypeName=instanceParts.last
    subsystem=Subsystem.find_or_create_by_name(subsystemName)
    classtype=Classtype.find_or_create_by_name(classtypeName)     
    puts "Create Instance #{instance}"
    Instance.create!(:name => instance, :subsystem_id => subsystem.id, :classtype_id => classtype.id)
  end
end
def createExperiments(nrOfExperiments)
  (1..nrOfExperiments).each do |n|
    name  = "P#{n}"
    description = Faker::Lorem.sentence(1)
    experiment=Experiment.create!(:name => name, :description => description)
    puts "Created Experiment #{experiment.id}"
  end
end
def createDataTypes
  datatypes=["numeric","string","image","spectrum","voltage"]
  datatypes.each do |datatype|
    puts "Generate data type <#{datatype}>"
    Datatype.create!(:name => datatype)
  end
end

=begin
def fillImageData
  imageNr=rand(1000)
  image=File.open("#{:Rails.root.to_s}/lib/tasks/test_images/#{imageNr}.jpg",'rb').read
  return image
end
=end
def fillSpectrumData
  spectrum="" 
  (1..100).each do |dataPoint|
    spectrum = spectrum + dataPoint.to_s + "," + (100*rand()-50).to_s + "\n"
  end
  return spectrum
end
def fillStringData
  return Faker::Lorem.words(2)
end
def fillNumericData
  return 100*rand()
end

