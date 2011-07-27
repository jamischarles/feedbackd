Feature: Manage listings
  	In order to update or delete a listing
	I must be an authenticated user
  

	# Scenario: Listings list
	#     Given I have listings titled Pizza, Breadsticks
	#     When I go to the list of listings
	#     And I press "Create"
	#     Then I should see "Pizza"
	# 	And I should see "Breadsticks"
	
		
	# consider moving this to an images feature file?	
	# FIXME Make this more high level? Hide the details in the step defs?
	# Image upload in this view breaks when I turn on @javascript with paperclip. Something with the folder or file names I think...
	@paperclip 	
	Scenario: Upload a new photo to an existing Listing (if authenticated as owner)
		# Given I am on the home page # caused error. TODO get this to work so we can follow entire path
		# And I press "Create Listing"
		# FIXME how do you handle auth? Add it in here as a step?
		# FIXME Create a new user here, instead of using the one I already have? Use Factory Girl for that...
		Given the following users:
		| Bob@gmail.com | secret |
		And I am logged in as "Bob@gmail.com" with password "secret"
		And I create a new listing "Mark Warnick Photosizzle"
		#Then I should see "Mark Warnick Photosizzle"
	 	
		Given I attach the file "features/support/test_image.jpg" to "image_photo"
		And I press "Upload"
		#Then I should see "Image successfully updated" #move this to the definition
		Then I should see "Image was successfully updated"
		And I should see the image "test_image.jpg"	

	 	
	
	Scenario: Upload a different image with caption to replace existing image and caption
		Given the following users:
		| darth_vader@gmail.com | secret |
		And I am logged in as "darth_vader@gmail.com" with password "secret"
		Given I create a new listing with name "Darth Vader Studio" and test image
		And I update test image with "features/support/test_image_2.jpg" and description "Love this one"
		
		Then I should see the image "test_image_2.jpg"
		And I should see "Image was successfully updated."
		And I should see "Love this one"
		
		
		# create a listing as auth...
		# TODO Must first require that a non-logged in person cannot create a listing
		# this will introduce a bug IF a listing is created WITHOUT a user_id. Should create validation for that
		Scenario: IF NOT authenticated THEN I should NOT see controls to Update listing 
			Given the following users:
			| luke@gmail.com | secret |
			And I am logged in as "luke@gmail.com" with password "secret"
			And I create a new listing "test listing 990"
			#Then I should see "test listing 990"
			# log out
			Given I am not logged in
			#this should be in the step defs
			Then I should not see "Edit this section" 
			And I should not see button "Upload"
			And I should not see button "Choose file"
		
		#no ajax, so @javascript not required
		Scenario: If authenticated as non-owner, I should NOT see controls. If owner I should see update controls.
			# this step seems to require testing with @js tag up above
			Given the following users: 
			| BobaFett@gmail.com | secret |
			| Chewbacca@gmail.com | secret |
			And I am logged in as "BobaFett@gmail.com" with password "secret"
			And I create a new listing "Boba Fetts Photoshoot"
		
			#Then I should see "Boba Fetts Photoshoot"
			#this should be in the step defs
			# if I'm the owner I should see this
			And I should see "Edit this section"
		
			Given I am logged in as "Chewbacca@gmail.com" with password "secret" 
			And I visit the listing for "Boba Fetts Photoshoot"
			# if I'm NOT the owner I should NOT see this
			Then I should not see "Edit this section"
			And I should not see button "Upload"
			And I should not see button "Choose file"
		
		@javascript
		Scenario: Update a listing when authenticated as owner
			Given the following users:
			| Bob@gmail.com | secret |
			And I am logged in as "Bob@gmail.com" with password "secret"
			And I create a new listing "test listing 44"
			#Then I should see "test listing 44"
			#this should be in the step defs
			And I press "Edit this section" 
			When I fill in the following:
			| listing_name | Joe the photo guy       |
			# AJAX action, so @javascript is required
			And I press "Save"
			Then I should see "Joe the photo guy"
			And I should see "Listing Successfully Updated"
		
		@wip	
		Scenario: Delete a Listing	
		
		@wip
		Scenario: Deleting a Listing should only be possible and visible if you are authenticated as owner

  # Rails generates Delete links that use Javascript to pop up a confirmation
  # dialog and then do a HTTP POST request (emulated DELETE request).
  #
  # Capybara must use Culerity/Celerity or Selenium2 (webdriver) when pages rely
  # on Javascript events. Only Culerity/Celerity supports clicking on confirmation
  # dialogs.
  #
  # Since Culerity/Celerity and Selenium2 has some overhead, Cucumber-Rails will
  # detect the presence of Javascript behind Delete links and issue a DELETE request 
  # instead of a GET request.
  #
  # You can turn this emulation off by tagging your scenario with @no-js-emulation.
  # Turning on browser testing with @selenium, @culerity, @celerity or @javascript
  # will also turn off the emulation. (See the Capybara documentation for 
  # details about those tags). If any of the browser tags are present, Cucumber-Rails
  # will also turn off transactions and clean the database with DatabaseCleaner 
  # after the scenario has finished. This is to prevent data from leaking into 
  # the next scenario.
  #
  # Another way to avoid Cucumber-Rails' javascript emulation without using any
  # of the tags above is to modify your views to use <button> instead. You can
  # see how in http://github.com/jnicklas/capybara/issues#issue/12
  #
  # Scenario: Delete listing
  #     Given the following listings:
  #       |title|
  #       |title 1|
  #       |title 2|
  #       |title 3|
  #       |title 4|
  #     When I delete the 3rd listing
  #     Then I should see the following listings:
  #       |Title|
  #       |title 1|
  #       |title 2|
  #       |title 4|
