# I created this file based on a blogpost. Hopefully this is right...
Paperclip.interpolates :listing_id do |attachment, style|
  attachment.instance.listing_id # or whatever you've named your User's login/username/etc. attribute
end