Given /^the following listings:$/ do |listings|
  Listing.create!(listings.hashes)
end

#Manual step by step to create a new listing. Seems to be less buggy.
Given /^I create a new listing "(.+)"$/ do |listing|
	visit('/listings/new') # navigating there from homepage seems to be buggy?
	
	#click_button('Create Listing')
	fill_in('listing_name', :with => listing)
	click_button('Create Listing')
	page.should have_content("Listing was successfully created")
	# verify name is on the page
	page.should have_content(listing)
end


Given /^I create a new listing with name "([^"]*)" and test image$/ do |name|
  	visit('/') # start on homepage
	click_button('Create Listing') # visit create listing page
	
	fill_in('listing_name', :with => name)
	attach_file("listing_images_attributes_0_photo", "features/support/test_image.jpg") # FIXME Consider linking this to the other step instead of this?
	
	click_button('Create Listing')
	# verify Listing is there
	page.should have_content("Listing was successfully created")
	# verify name is on the page
	page.should have_content(name)
	# verify image is there
	# save_and_open_page
	page.should have_xpath("//img[contains(@src, \"test_image.jpg\")]")
end

Given /^I update test image with "([^"]*)" and description "([^"]*)"$/ do |image, description|
	# within the update image section...
	within("form.edit_image") do
	    fill_in('image_description', :with => description)
		attach_file("image_photo", image)
		click_button('Upload')
	end
end




When /^I delete the (\d+)(?:st|nd|rd|th) listing$/ do |pos|
  visit listings_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following listings:$/ do |expected_listings_table|
  expected_listings_table.diff!(tableish('table tr', 'td,th'))
end

Given /^I have listings titled (.+)$/ do |titles| # take any listing title
	titles.split(', ').each do |title|	# split it into an array
		Listing.create!(:title => title) # create a listing based on each of those...
	end
end

# Then /^I should see the image "(.+)"$/ do |image|
#   #page.has_content?(image) #search the content of the page for the image name (based on the capybara docs)
# 	# this works fine if it's text on the page. HOW can I search for the image url or something like that?
# 	if page.respond_to? :should
#       page.should have_content(image)
#     else
#       assert page.has_content?(image)
#     end
# 
# 	
# 	
# 	nodes = Nokogiri::HTML(response.body).css('img')
# 	table.diff!(nodes.map { |img| [img.attributes['alt'].to_s] })


# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
Given /^the following users:$/  do |table|
  	table.rows_hash.each do |username, password|
      	visit "/users/sign_up"
		fill_in('user_email', :with => username)
		fill_in('user_password', :with => password)
		fill_in('user_password_confirmation', :with => password)
		click_button("Sign up")
		page.should have_content("Signed in as #{username}")
		click_link("Sign out")
    end
end


Given /^I am not logged in$/ do
	visit "/" #go to homepage
	if page.has_content?('Signed in as') #if logged in
		click_link("Sign out") # log out
	end	
	
	page.should have_content("Sign up")
	page.should have_content("sign in")
	page.should have_no_content("Signed in as")
end


Given /^I am logged in as "(.+)" with password "(.+)"$/ do |username, password|
	visit "/" #go to homepage
	if page.has_content?('Signed in as') #if logged in. FIXME There must be a session way to verify if your authenticated...
		click_link("Sign out") # log out
	end
	
	visit "/users/sign_in"
	fill_in('user_email', :with => username)
	fill_in('user_password', :with => password)
	click_button("Sign in")
	page.should have_content("Signed in as #{username}")
end


Then /^I should see button "([^"]*)"$/ do |button|
	page.should have_button(button)
end

Then /^I should not see button "([^"]*)"$/ do |button|
  page.should have_no_button(button)
end



# not sure if this works	
Then /^I should see the following images$/ do |table|
  nodes = Nokogiri::HTML(page.body).css('img') #requires the Nokogiri gem
  table.diff!(nodes.map { |img| [img.attributes['href'].to_s] })
end

Then /^I should see the image "(.+)"$/ do |image|
	#page.should have_xpath('//img[@src="test_image.jpg"]')
	#page.should have_xpath('//img[@src="//test_image.jpg"]')
	# look for the image name somewhere in the url. uses nokogiri / capybara I think
	# save_and_open_page # for debugging, it leaves it open. Requires "launchy" gem
	page.should have_xpath("//img[contains(@src, \"#{image}\")]") 
	
end

Given /^I visit the listing for "(.+)"$/ do |listing_name|
	listing = Listing.find_by_name!(listing_name) #this step doesn't appear to work? Test in the other flow?
	#listing = Listing.find(:id => listing_name) #_by_name!(listing_name)
	#visit listing_url(listing)
	visit "/listings/detail/#{listing.id}" #FIXME change this so it uses the proper route instead of hardcoded here... This works for now.
end





 