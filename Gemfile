source 'http://rubygems.org'

# file is what is loaded when the mongrel server loads...

gem 'rails', '3.0.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-ext'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
gem 'mysql2' #for the mysql db

gem 'devise' #auth system devise. For authentication.
gem 'cancan' #role based abiilty system by ryanb (couples with Devise). For authorization.

gem 'paperclip' # image upload

# for seed data 
gem 'factory_girl_rails'



# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
#	gem 'mongrel', '>= 1.2.0.pre2' #use at least this version, (necessary for Ruby 1.9.2). #don't let this override the load in prod. Causes server failure.

	# cucumber setup
	#gem "rspec", '>= 1.2.2' 
	#gem "rspec-rails", '>=1.2.2'
	#gem "webrat", '>=0.4.3'
	# gem "cucumber", '>=0.2.2'
	
	# from the cucumber rails docs: https://github.com/aslakhellesoy/cucumber-rails/blob/master/README.rdoc
	gem 'cucumber-rails'
	gem 'capybara'
	gem 'launchy' # to be able to open_and_save from capybara (for debugging)
	gem 'database_cleaner'
	gem 'nokogiri'
	
	# use factory girl for my test data...?
	gem 'factory_girl_rails'
	
	# gem to create seeds from yaml files (fixtures)
	# gem 'yaml_seeder'

end
