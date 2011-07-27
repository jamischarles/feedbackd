class Image < ActiveRecord::Base
	belongs_to :listing #Rails ActiveRecord Relation. An image belongs to a post. 

	# paperclip data
	has_attached_file :photo, :styles => { :medium => "700x700>", :small => "300x300>", :thumb => "100x100>" }, 
	:url => "/system/:attachment/:listing_id/:id/:style_:filename"#, #location where to output the server. :LISTING_ID is defined in config/initializers/paperclib.rb
	
	attr_accessible :photo, :description, :listing_id # what does this do?
	
	#:path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension" #location where to save the file
	#these styles can be retrieved as params like so "<%= image_tag image.photo.url(:medium) %>"

	# http://robots.thoughtbot.com/post/159807063/paperclip-tips-and-updates Blog post on how to pass data to it
	
end

