class Listing < ActiveRecord::Base
	has_many :images, :dependent => :destroy #Rails ActiveRecord Relation. Defined here instead of the DB. 1 post has many images.
	# accepts_nested_attributes_for :images # This allows us to access the images straight from the listing object like this: @listing.images. The :reject_if call makes sure that we do not store empty TripImage records – sometimes users will not add an image for the trip right away.
	# for a multi-model form, add this so you can edit the image from the listing form
	accepts_nested_attributes_for :images, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
	
	
	belongs_to :price #this is a one way, non-dependant relationship. If this is erased, we don't want that price range to be destroyed. Belongs to is used
					  #because the foreign key to price is in Listings table
	belongs_to :user #MUST be on separate lines			
					
	#belongs to 1 user... add this in later after we build the user tables...
	delegate :prince_range, :to => :price #makes .price_range available to listing. ie: listing.price_range. Very slick.
	
	# validation for stuff. This will make it fail currently. Adjust my code, so it doesn't save it at first...? ...?
	# validates :name,  :presence => true
	
	# def as_json()
	# 		super(:include => :price)
	# 	end

	#attr_accessible :id
	
	
	
	
	def price_range
	    price.price_range #fetches the price range as an attribute when I add it to the controller...
	end
	
	# so in the view you can call   if @listing.owned_by(current_user) 
	# this didn't seem to work... don't know why...
	def owned_by?(user)
    	user.id == self.user_id 
  	end
	
end
