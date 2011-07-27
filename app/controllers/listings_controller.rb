class ListingsController < ApplicationController
	# redirect to signin if user is not authenticated on all listing controllers... No auth required for index, detail
	before_filter :authenticate_user!, :except => [:index, :detail, :create] #TODO remove :create from here?
	
	#require 'FileUtils' #for the delete folder action #breaks in staging
	
	
	def index
	
		
		@listings = Listing.all
		
		#@listings = Listing.find.includes(:prices).(:price_range => params[:id])  #not working quite yet
		

		respond_to do |format|
			format.html #index.html.erb
			format.xml { render :xml =>@listings }
		end
	end	

	# def detail
	# 		render :action => "detail" #render the detail view...?
	# 	end	

	# --------------------------------------------------------------------

	def detail 
		@listing = Listing.find(params[:id])  
		@image = Image.new #should this link somewhere else?

		respond_to do |format| 
			format.html # show.html.erb  
			format.xml { render :xml => @listing } 
		end 
	end 
	
	# --------------------------------------------------------------------
	
	def destroy 
		@listing = Listing.find(params[:id])  
		
		# if destroy was a success, remove the listing image folder
		if @listing.destroy 
			#require 'fileutils' # thought this was necessary, but it's not... The below delete still works, without the req...
			dir = Rails.root + '/system/photos/' + @listing.id.to_s()
			FileUtils.rm_rf(dir)	
			
		end	
		
		
		 

		respond_to do |format| 
			format.html { redirect_to(listings_url) } 
			format.xml { head :ok } 
		end 
	end 
	
	# --------------------------------------------------------------------
	
	def new
		# create a new listing, with a status of "draft"
		@listing = Listing.new(:price_id => 1)  # Default price id
		# save it to db
		# TODO add validation that it has to have a price ID, on record creation. So the view doesn't break.
		# @listing.save
		@image = Image.new

		# redirect_to "/detail/@listing.id"
		# redirect_to "/listings/detail/:id"
		
		respond_to do |format| 
			format.html # show.html.erb  
			format.xml { render :xml => @listing } 
		end
	end	
	
	# --------------------------------------------------------------------
	
	# TODO consider combining this one and create, and fork based on whether params are passed or not.
	def create
		# create a new listing and save it immediately. Assign it to guest, with a status of "draft"
		
		# if the user is singed in, attach the user_id to the params...
		if user_signed_in?
			params[:listing][:user_id] = current_user.id
		end
		
		# if the user isn't signed in, create a temp user? FIXME really think about this...
		
		
		
		@listing = Listing.new(params[:listing])  
		# save it to db
		# TODO add validation that it has to have a price ID, on record creation. So the view doesn't break.
		
		# @image = Image.new
		
		
		# on success, redirect to listing
		# if @listing.save
		# 			redirect_to "/detail/@listing.id"
		# 		else
		# 			redirect_to "/"
		# 		end
		#on failure... 
		
		# redirect_to "/listings/detail/:id"
		
		# process the file upload...
		
		
		
		respond_to do |format| 
			if @listing.save
			      format.html { redirect_to("/listings/detail/#{@listing.id}",
			                    :notice => 'Listing was successfully created.') }
			      format.xml  { render :xml => @listing,
			                    :status => :created, :location => @listing }
			    else
			      format.html { render :action => "new" }
			      format.xml  { render :xml => @listing.errors,
			                    :status => :unprocessable_entity }
			    end
		end
	end	

	
	# --------------------------------------------------------------------
	
	def update
		@listing = Listing.find(params[:listing][:id])
		
		#if params were passed in for updating
		if @listing.update_attributes(params[:listing])
	 	#should we return the whole thing or just what's needed?
			json_response = {
				"success" => @listing.save, #save to DB and assign true/false based on success...
				# "message" => @listing.attributes
				"message" => @listing.serializable_hash(:methods => [:price_range]) #calls the listing.price_range method defined in the model
				# "message" => @listing.as_json(:only => [:price], :include =>[:prices]) 
				# "message" => @listing.as_json
				# "message" => @listing.attributes.as_json(:include => [:price])
				
				#@listing.attributes #USE attributes to show output the content of the @message obj, and not another object called "message"
			}
			
			respond_to do |format| 
				#json response
				format.html { render:json => json_response }
					 
				format.xml { render :xml => @listing } 
				
				#normal response. Consider leaving this for now?
				#format.html { render :action => "detail" } #refresh this page, with new data in it. Consider trying to use redirect instead?
				#format.xml  { head :ok }
			end
		end #end if	
	
	 # respond_to do |format|
	 # 	    if @listing.update_attributes(params[:listing])
	 # 	      format.html { redirect_to(@listing,
	 # 	                    :notice => 'Post was successfully updated.') }
	 # 	      format.xml  { head :ok }
	 # 	    else
	 # 	      format.html { render :action => "edit" }
	 # 	      format.xml  { render :xml => @listing.errors,
	 # 	                    :status => :unprocessable_entity }
	 # 	    end
	 # 	  end
	
	
	end
	
	# --------------------------------------------------------------------
	
	
	


end
