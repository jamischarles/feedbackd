class Post < ActiveRecord::Base
	has_many :images, :dependent => :destroy #Rails ActiveRecord Relation. Defined here instead of the DB. 1 post has many images.
	#has_many :zones, :dependent => :destroy #:dependent => :nullify. Turns the id null? Try this out...
	#has_many :messages, :through => :zones #what's the purpose of this...? Is it necessary?
end
