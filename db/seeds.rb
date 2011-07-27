# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# puts "seeds data goes here" # "rake" just calls the file and executes it...

# CHANGE THE ENV HERE? Make sure this add it to both Test and Dev DBs?

# wipe out all previous data
Price.delete_all #is there a factory way of doing this?
# set defaults
Factory.define :price do |price|
  price.id                  1
  price.price_range         "$100"
end

# insert seed data
@price = Factory(:price, :id => 1, :price_range => "$100 - $500")
@price = Factory(:price, :id => 2, :price_range => "$500 - $1,000")
@price = Factory(:price, :id => 3, :price_range => "$1,000 - $1,000")
@price = Factory(:price, :id => 4, :price_range => "$10,000 - $100,000")

# user = Factory.create(:user)

# Factory.define :theme do |t|
#   t.background_color '0x000000'
#   t.title_text_color '0x000000',
#   t.component_theme_color '0x000000'
#   t.carrier_select_color '0x000000'
#   t.label_text_color '0x000000',
#   t.join_upper_gradient '0x000000'
#   t.join_lower_gradient '0x000000'
#   t.join_text_color '0x000000',
#   t.cancel_link_color '0x000000'
#   t.border_color '0x000000'
#   t.carrier_text_color '0x000000'
#   t.public true
# end
# 
# Factory(:theme, :id => 1, :name => "Lite", :background_color => '0xC7FFD5')
# Factory(:theme, :id => 2, :name => "Metallic", :background_color => '0xC7FFD5')
# Factory(:theme, :id => 3, :name => "Blues", :background_color => '0x0060EC')


# Price.delete_all # wipe out all prices. HOW CAN YOU FORCE THE ID? It's auto incrementing... THIS IS BAD
# Price.create!(:id => 1, :price_range => "$100 - $500")
# Price.create!(:id => 2, :price_range => "$500 - $1,000")
# Price.create!(:id => 3, :price_range => "$1,000 - $1,000")
# Price.create!(:id => 4, :price_range => "$10,000 - $100,000")

# FIND A SOLUTION FOR THIS







# TODO Replace this with Factory girl instead? Seems more stable... Keep track of when rake db:seed is run in dev and prod...
# Price.delete_all # delete all previous records
# Fixtures.create_fixtures("#{Rails.root/test/fixtures}", "prices.yml")



	
# Price.create!(:id => 1)
# open("text_file_to_state_names.txt") do |countries| # open this text file. REQUIRES open-uri. Through gem? 
# 	countries.read.each_line do |country| # loop through them
# 		code, name = country.chomp.split("|") # split them into array
# 		Country.create!(:name => name, :code => code) # create a new country for each one
# 	end
# end






# got most of these examples from the railscasts seed video


# seed for Price ranges. TODO Find out how to handle this in prod when they change? Do you re-run rake db:seed?
# example 1
# ['200 - 400', '400 - 500', '500 - 2000'].each do |price|
# 	Price.find_or_create_by_name(price) # only create it if it doesn't exist yet 
# end	

# example 2
# Price.delete_all # delete all previous records
# open("text_file_to_state_names.txt") do |countries| # open this text file. REQUIRES open-uri. Through gem? 
# 	countries.read.each_line do |country| # loop through them
# 		code, name = country.chomp.split("|") # split them into array
# 		Country.create!(:name => name, :code => code) # create a new country for each one
# 	end
# end		

# example 3
# You can also use FIXTURES... Which requires active_record/fixtures
# Fixtures.create_fixtures("#{Rails.root/test/fixtures}", "prices.yml")


