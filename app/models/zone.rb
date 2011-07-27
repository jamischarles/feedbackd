class Zone < ActiveRecord::Base
	belongs_to :post #relation mapping to a post.
	has_many :messages, :dependent => :destroy
end
