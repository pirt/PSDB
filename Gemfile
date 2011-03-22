source 'http://rubygems.org'

gem 'rails', "3.0.4"
gem 'gnuplot'       # Use plot package
gem 'will_paginate', '3.0.pre2' # Paginate result lists
gem 'rmagick'       # Bitmap graphics handling (e.g. scaling, false colour,...)

# Add support for oracle database
gem 'ruby-oci8'
gem 'activerecord-oracle_enhanced-adapter'
gem 'ruby-plsql'

# Gems for the local environment only. 
group :development, :test do
  gem 'mysql2'             # Support for mySQL database (development only)
  gem 'rspec'		       # Use Rspec as testing framework
  gem 'rspec-rails'        # Use Rspec as testing framework
  gem 'webrat'             # Acceptance testing for webpages
  gem 'faker'              # Use generator for sample data
  gem 'factory_girl_rails' # generate model test instances (experiments, shots, users, ...)
  gem 'annotate-models'    # Annotate models with the fields of the database
end
 
# gem 'capistrano' # Deploy with Capistrano
