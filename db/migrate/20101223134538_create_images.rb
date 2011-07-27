class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
		t.string :description #the description for the detail page...
	 	t.integer :listing_id #this is superfluous due to the t.references... below...
		t.references :listing
		t.timestamps
		
	end
  end

  def self.down #during rollbacks we'll have to make sure to target a specific revisions so we don't undo something more in prod...
    drop_table :images
  end
end



