# TODO find a way to call in the actual seed data instead of this?

# IT APPEARS THAT the contents of features/support get loaded automatically before each teast... 
# FIXME... What happens when I put this in a subfolder?

Price.delete_all #is there a factory way of doing this?
# set defaults
Factory.define :price do |price|
  price.id                  1
  price.price_range         "$100"
end

# insert seed data
@price = Factory(:price, :id => 1, :price_range => "$100 - $500")
@price = Factory(:price, :id => 2, :price_range => "$500 - $1,000")
@price = Factory(:price, :id => 3, :price_range => "$1,000 - $1,000")
@price = Factory(:price, :id => 4, :price_range => "$10,000 - $100,000")