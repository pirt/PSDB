require 'yaml'
puts "--------------------------------"
puts "-    Welcome to PSDB Config    -"
puts "--------------------------------"
print "Enter name of the project (such as 'PHELIX' or 'POLARIS'):"
projectName = STDIN.gets.strip
print "Enter type of database (such as 'oracle_enhanced' or 'mysql2'):"
dbtype=STDIN.gets.strip
print "Enter user name:"
username=STDIN.gets.strip
print "Enter password:"
password=STDIN.gets.strip
puts
puts " Project name: " + projectName
puts "Database type: " + dbtype
puts "    User name: " + username
puts "     Password: " + password
psdbConfig={}
psdbConfig["project"]={}
psdbConfig["project"]["name"]=projectName
psdbConfig["database"]={}
psdbConfig["database"]["development"]={}
psdbConfig["database"]["development"]["adapter"]=dbtype
psdbConfig["database"]["development"]["database"]="psdb_development"
psdbConfig["database"]["development"]["username"]=username
psdbConfig["database"]["development"]["password"]=password
psdbConfig["database"]["test"]={}
psdbConfig["database"]["test"]["adapter"]=dbtype
psdbConfig["database"]["test"]["database"]="psdb_test"
psdbConfig["database"]["test"]["username"]=username
psdbConfig["database"]["test"]["password"]=password
psdbConfig["database"]["production"]={}
psdbConfig["database"]["production"]["adapter"]=dbtype
psdbConfig["database"]["production"]["database"]="psdb_production"
psdbConfig["database"]["production"]["username"]=username
psdbConfig["database"]["production"]["password"]=password
psdbConfigYml=psdbConfig.to_yaml
file=File.new("psdbconfig.yml.temp","w")
file.write(psdbConfigYml)
file.close
puts
puts "Config file written to ./psdbconfig.yml.temp"
puts "1. Edit this file to match your setup if necessary."
puts "2. Move/rename this file: 'mv ./psdbconfig.yml.temp PSDB/config/psdbconfig.yml'"

