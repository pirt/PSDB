source 'http://rubygems.org'

gem 'rails' , "~> 3.1.0"
gem 'gnuplot'       # Use plot package
gem 'will_paginate', "~> 3.0.2" # Paginate result lists
gem 'rmagick'       # Bitmap graphics handling (e.g. scaling, false colour,...)

# Gems used only for assets and not required  
# in production environments by default.  
group :assets do  
  gem 'sass-rails', " ~> 3.1.0"  
  gem 'coffee-rails', " ~> 3.1.0"  
  gem 'uglifier'  
end  

gem 'jquery-rails'  # jQuery integration

# Add support for oracle database
group :oracle do
  gem 'ruby-oci8'
  gem 'activerecord-oracle_enhanced-adapter'
  gem 'ruby-plsql'
end
# Add support for mysql database
group :mysql do
  gem 'mysql2' #, "~> 0.2.7"
end
# Gems for the local environment only.
group :development, :test do
  gem 'rspec'		           # Use Rspec as testing framework
  gem 'rspec-rails'        # Use Rspec as testing framework
  gem 'webrat'             # Acceptance testing for webpages
  gem 'faker'              # Use generator for sample data
  gem 'factory_girl_rails' # generate model test instances (experiments, shots, users, ...)
  gem 'annotate'    # Annotate models with the fields of the database
end

# gem 'capistrano' # Deploy with Capistrano

