class ImagesController < ApplicationController
	
	def index
		upload #call the upload function
	end	
	
	#use this one? Just leave it for now... automatically looks for the upload view.
	def upload
		@image = Image.new(params[:image])
		
		# @image = Image.new 
		@message = "testing"
	end
	
	# def create
	# 		do_upload #consider just adding the route instead of doing it this way...?
	# 	end	
	
	def create
		# TODO validate that they are admin, and have rights to create an image...
		# TODO validate that they have rights to change the listing_id...
		
		#add listing_id param to it, so it's not saved on the page? OR just put in the form on the page to make it easy
	
		#append the id that was passed in as the parent listing id
		listing_id = params[:id]
		params[:image][:listing_id] = listing_id	
		
	    @image = Image.create( params[:image] )
		#@image.save #save the newly created image
		
		if @image.save
		      redirect_to("/listings/detail/#{listing_id}", :notice => 'Image was successfully updated.')
		end
		
		#if # @image.save
		 # 			format.html { redirect_to("/listings/detail/#{listing_id}",
		 # 	                    :notice => 'Listing was successfully updated.') }
		 # 	    	format.xml  { render :xml => @image,
		 # 	                    :status => :created, :location => @image }
	    # else
	    # 	    	format.html { render :action => "new" }
	    # 	    	format.xml  { render :xml => @listing.errors,
	    # 	                    :status => :unprocessable_entity }
	    # 	    end
		
		# respond_to do |format|
		# 			format.html #index.html.erb
		# 			format.xml { render :xml =>@image }
		# 		end
	end
	
	
	def update
	
		@image = Image.find(params[:image][:id])
		# replace the current image attachment with a new one...
		
		listing_id = @image.listing_id
		
		if @image.update_attributes(params[:image])
			notice = 'Image was successfully updated.'
		else
			notice = 'There was a problem updating your image'
		end		
		
		redirect_to("/listings/detail/#{listing_id}", :notice => notice)
		
		
		# at some point, do JSON. For now, just refresh the page...
		# json_response = {
		# 			"success" => @image.update_attributes(params[:image]), #save to DB and assign true/false based on success... This will update the attachment
		# 			"message" => "" #return a message if it fails... Figure out how to do this...
		# 		}
		# 		
		# 		respond_to do |format| 
		# 			#json response
		# 			format.html { render:json => json_response }
		# 				 
		# 			format.xml { render :xml => @image } 
		# 		end
	end	
	
	def delete
		@image = Image.find(params[:id]) #find image
		 
		# remove attachment, then image model
		@image.update_attribute(:photo, nil)
		
		#how can we make this fail gracefully and return the response properly?
		
		# TODO check for the existince of the image and return something based on that...
		
		json_response = {
			"success" => @image.delete, #save to DB and assign true/false based on success...
			"message" => "" #return a message if it fails... Figure out how to do this...
		}
		
		respond_to do |format| 
			#json response
			format.html { render:json => json_response }
				 
			format.xml { render :xml => @image } 
		end
	end	
	
	#should this be renamed to create?
	# def create
	# 	   	@image = Image.new( :listing_id => params[:id], :photo_file_name => params[:image][:photo], :description => params[:image][:description]) #params[:image]
	# 		
	# 		# what part of this should paperclip be handling?
	# 		@image.save
	# 		#redirect_to listing_url(@image)
	# 	end
	
	
	
	# def create 
	# 		#currently works... Extend this some more...
	# 		uploaded_io = params[:image][:url] 
	# 		File.open(Rails.root.join('public', 'images_user', uploaded_io.original_filename), 'w') do |file| #uploaded_io.original_filename is the param for the new filename to be saved.
	# 			file.write(uploaded_io.read)
	# 			@message = puts YAML::dump(file)
	# 		end 
	# 		
	# 		#image.new calls creates it in the DB. We have to pass it params...
	# 		#@image = Image.new(params[:image])  #call the new method...? How do we pass the params...?
	# 		@image = Image.new(:url => uploaded_io.original_filename) #we could either pass it in like this 1by1, or an array of params[]
	# 			
	# 		#@message = @image
	# 		#@message = "testing this message right here"
	# 
	# 		#we need to pass the image params back with it here...
	# 		render :action => "upload" #using render just loads the view, doesn't run through the upload function and actions... 
	# 		#redirect_to(upload_url)
	# 		#redirect_to image_url(@image_file) #pass it a param...
	# 			
	# 		
	# 	end 
	
	#from the tutorial. Not working so far.
	def do_upload
	  @image = Image.new(params[:image])
	  #if @image.save
	    #flash[:notice] = 'Image was successfully created.' #figure this one out later. FIXME Figure out how to send messages to 
	    redirect_to posts_url(@image)     
	  #else
	   # render :action => :index
	  #end
	end
	
	#accept image (add to db, leave on harddisk. Move if necessary.) Attach this to a new post also? Pass a post id, and create if not existent yet.
	def accept
		#create a new image obj, or take the one that was already created? Attach it to a post...
		@post = Post.new() #SHOULD this really be here...?
		@post.save
		#FIXME: for now, just have the post_id be put for the new post that was just created. Later be able to assign it better and check for success better. 
		@image = Image.new(:url => params[:url], :post_id => @post.id) #we could either pass it in like this 1by1, or an array of params[]
	
		
		respond_to do |format| 
			#if save to DB has been made
			if @image.save
				format.html { redirect_to(posts_path,  
					:notice => 'Post was successfully created.') } 
				format.xml { render :xml => posts_path,  
					:status => :created, :location => @post } 
			else  
				format.html { render :action => "new" } 
				format.xml { render :xml => @image.errors,  
					:status => :unprocessable_entity } 
			end  
		end 
	end
	
	#reject image (delete from file and DB)
	def reject
		#delete file...
		File.delete( Rails.root.join('public', 'images_user', params[:url]) )
		respond_to do |format|
			format.html { redirect_to(posts_path,  
				:notice => 'Image successfully deleted') }
		end	
		
	end		
	
	# def create
	# 		@image_file = Image.new(params[:image])
	# 		if @image_file.save
	# 			flash[:notice] = 'Attachment was successfully created.'
	# 			redirect_to image_url(@image_file)     
	# 		else
	# 			render :action => :new
	# 		end
	# 	end
	
	#not being used currently?
	def create_image 
		@image = Image.new 
		
		respond_to do |format| 
			redirect_to(posts_url)
		end 
	end 
	
end
