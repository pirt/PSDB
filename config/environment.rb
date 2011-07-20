# Load the rails application
require File.expand_path('../application', __FILE__)

# Load PSDB_CONFIG
begin
  raw_config = File.read(Rails.root.to_s + "/config/psdbconfig.yml")
  PSDB_CONFIG = YAML.load(raw_config)
rescue
  puts
  puts "Error while trying to read config/psdbconfig.yml"
  puts "Try to run 'ruby ./lib/configPSDB.rb' first and follow the instructions there."
  exit!
end

# Initialize the rails application
PSDB::Application.initialize!

# define version string from git repository
APP_VERSION = `git describe --always` unless defined? APP_VERSION

