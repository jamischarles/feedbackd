Feature: Create listings
  	In order to create a feature
	I need to be an authenticated user
	
  

	# Scenario: Listings list
	#     Given I have listings titled Pizza, Breadsticks
	#     When I go to the list of listings
	#     And I press "Create"
	#     Then I should see "Pizza"
	# 	And I should see "Breadsticks"
	
	# paperclip image upload breaks when running the @javascript tag. Not sure why? Do some research. Just avoid for the moment...
	@paperclip @done
  	Scenario: Create new listing with image upload (authenticated)
		Given the following users:
		| ewok@gmail.com | secret |
		And I am logged in as "ewok@gmail.com" with password "secret"
		
		# Given I am on the home page # caused error. TODO get this to work so we can follow entire path
		# And I press "Create Listing" #causes same node error. FIXME Do some research and fix this
		# FIXME how do you handle auth? Add it in here as a step?
	#	Given I am on the new listing page
		
		Given I am on the new listing page
		When I fill in "listing_name" with "Amy Johnson Photography"
		And I attach the file "features/support/test_image.jpg" to "listing_images_attributes_0_photo"
		
		And I press "Create"
		Then I should see "Amy Johnson Photography"
		And I should see the image "test_image.jpg" 
		
	# FIXME Adjust this so it's not the painful redirect... Preferably, they should be able to see the listing preview before having to auth...
	# FIXME undefined method `node_name' is a capybara bug when a button isn't within a form... Change the markup?
	
	Scenario: If I am not authenticated I cannot go to the create listing page
	Given I am not logged in
	And I am on the home page
	And I press "Create Listing"
	Then I should see "Sign in"
	And I should see button "Sign in"
	
	# When I fill in "listing_name" with "Amy Johnson Photography"
	# 	And I attach the file "features/support/test_image.jpg" to "listing_images_attributes_0_photo"
	# 	
	# 	And I press "Create"
	# 	Then I should not see "Amy Johnson Photography"
	# And I should see the image "test_image.jpg"
	
	@wip
	Scenario: If I am not authenticated I cannot place a listing live