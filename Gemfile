source 'http://rubygems.org'

gem 'rails'
gem 'gnuplot'       # Use plot package
gem 'will_paginate', "~> 3.0.pre2" # Paginate result lists
gem 'rmagick'       # Bitmap graphics handling (e.g. scaling, false colour,...)
gem 'jquery-rails'  # jQuery integration

# Add support for oracle database
group :oracle do
  gem 'ruby-oci8'
  gem 'activerecord-oracle_enhanced-adapter'
  gem 'ruby-plsql'
end
# Add support for mysql database
group :mysql do
  gem 'mysql2', "~> 0.2.7"
end
# Gems for the local environment only.
group :development, :test do
  gem 'rspec'		           # Use Rspec as testing framework
  gem 'rspec-rails'        # Use Rspec as testing framework
  gem 'webrat'             # Acceptance testing for webpages
  gem 'faker'              # Use generator for sample data
  gem 'factory_girl_rails' # generate model test instances (experiments, shots, users, ...)
  gem 'annotate-models'    # Annotate models with the fields of the database
end

# gem 'capistrano' # Deploy with Capistrano

