class CreateZones < ActiveRecord::Migration
  def self.up
    create_table :zones do |t|
		#t.integer :top #top position in px of zone 
		#t.integer :left #left position in px 
		#t.integer :width 
		#t.integer :height
		#t.integer :created_by
		#t.integer :post_id #foreign key?
		#t.references :post #relation to :post model
		#t.timestamps
    end
  end

  def self.down
    drop_table :zones
  end
end
