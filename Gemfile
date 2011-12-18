source 'http://rubygems.org'

gem 'rails' , "~> 3.1.0"
gem 'rack', '1.3.3'     # the newer version produces some warnings...
gem 'gnuplot'           # Use plot package
gem 'will_paginate'     # Paginate result lists
gem 'rmagick'           # Bitmap graphics handling (e.g. scaling, false colour,...)
gem 'authlogic'         # Authentication system
gem 'rails3-generators' # necessary for 'session' generator of Authlogic
gem 'declarative_authorization'
gem 'ruby_parser'

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
  gem 'ruby-oci8', "~> 2.0.6"
  gem 'activerecord-oracle_enhanced-adapter'
  gem 'ruby-plsql'
end
# Add support for mysql database
group :mysql do
  gem 'mysql2'
end
# Gems for the local development/ test environment only.
group :development, :test do
  gem 'rspec'		           # Use Rspec as testing framework
  gem 'rspec-rails'        # Use Rspec as testing framework
  gem 'webrat'             # Acceptance testing for webpages
  gem 'faker'              # Use generator for sample data
  gem 'factory_girl_rails' # generate model test instances (experiments, shots, users, ...)
  gem 'annotate'    # Annotate models with the fields of the database
end
