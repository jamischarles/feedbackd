class CreateListings < ActiveRecord::Migration
	def self.up
    	create_table :listings do |t|
			t.string :name #name of the listing / agency
			t.string :description #description that will appear on the detail page 
			t.string :phone
			t.string :website #url of their website
			t.string :email 
			t.string :city 
			t.string :state
			t.integer :price_id #foreign key to price table
			t.integer :user_id #foreign key to user table
			t.references :price #relation to :price model. Not sure if this should be used here... It does if the price row #s change... TEST THIS
			t.references :user
			t.timestamps
		end
	end

	def self.down
		drop_table :listings
	end
end
