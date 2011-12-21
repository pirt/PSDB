# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
puts "Initializing PSDB..."
  print "  Creating experiment... "
  STDOUT.flush
  Experiment.create!(:name => "Internal", :description => "internal shots of PHELIX", :active => true)
  puts "done"
  print "  Creating shot types... "
  STDOUT.flush
  shotTypes=["experiment shot","test shot","snapshot","other"]
  shotTypes.each do |shottype|
    Shottype.create!(:name => shottype)
  end
  puts "done"
  print "  Creating admin user... "
  STDOUT.flush
  user=User.create!(:login => "admin", :realname=>"Administrator", :email=>"psdb@gsi.de",
                    :password=>"admin", password_confirmation=>"admin")
  user.roles.create!(:title=>"admin")
  puts "done"
puts "Done."
