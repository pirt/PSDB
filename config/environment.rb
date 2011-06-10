# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
PSDB::Application.initialize!

# define version string from git repository
APP_VERSION = `git describe --always` unless defined? APP_VERSION

