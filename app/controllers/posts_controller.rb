class PostsController < ApplicationController
	
	def index
		@posts = Post.all
	
		respond_to do |format|
			format.html #index.html.erb
			format.xml { render :xml =>@posts }
		end
	end	
	
	# def detail
	# 		render :action => "detail" #render the detail view...?
	# 	end	
	
	# --------------------------------------------------------------------
	
	def detail 
		@post = Post.find(params[:id])  
		
		respond_to do |format| 
			format.html # show.html.erb  
			format.xml { render :xml => @post } 
		end 
	end 
	
	def destroy 
		@post = Post.find(params[:id])  
		@post.destroy 
		
		respond_to do |format| 
			format.html { redirect_to(posts_url) } 
			format.xml { head :ok } 
		end 
	end 
	
	# --------------------------------------------------------------------

	# ajax call to get all of the zones and the associated data in a json object
	def get_zones
		#Eager Loading Associations. http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations
		zones = Post.includes(:zones => :messages).find(params[:id])
		
		respond_to do |format| 
			#format.html { render :json => output } 
			
			#output the json and tell it what to include...
			format.html { render:json => zones.to_json( 
			  :include => {
			    :zones => {
			      :include => :messages
			    }
			  }
			)}
			
			#format.xml { head :ok } 
		end
		
	end
	
	# --------------------------------------------------------------------
	
	#ajax method for new message in post_detail
	def new_zone
		#create new Zone
		@zone = Zone.new(:top => params[:top], :width => params[:width], :height => params[:height], :left => params[:left], :post_id => params[:postID], :created_by => 2)  
		@zone.save
		#create new message for 1st message and associate with zone... @zone.message.new just for kicks...
		@message = Message.new(:body => params[:msg_body], :zone_id => @zone.id, :user_id => 2) #fix the user_id deelio... Use this for now...
		
		
		#attach the message as a child to the zone
		@zone["messages"] = [@message.attributes] #The JS expects an array of messages. So that's what we'll give.
		
		#should we return the whole thing or just what's needed?
		json_response = {
			"success" => @message.save, #save to DB and assign true/false based on success...
			"zone" => @zone.attributes #USE attributes to show the child object only...!!!
		}
		
		respond_to do |format| 
			format.html { render:json => json_response.to_json } 
			#render :action => :test
			
			#format.xml { render :xml => @post } 
		end 
	end
	
	# --------------------------------------------------------------------
	
	#ajax method for new message in post_detail
	def new_message
		#ajax is passing and handling the params... All through YUI. For now, let YUI handle that instead of Rails...
		@message = Message.new(:body => params[:msg_body], :zone_id => params[:listing_id], :user_id => 2)  
		
		
		#should we return the whole thing or just what's needed?
		json_response = {
			"success" => @message.save, #save to DB and assign true/false based on success...
			"message" => @message.attributes #USE attributes to show output the content of the @message obj, and not another object called "message"
		}
		
		respond_to do |format| 
			format.html { render:json => json_response } 
			format.xml { render :xml => @post } 
		end 
	end	
	
end #END Class


#why is the delete not being sent through properly???
#Q: Why is the "get" being sent over instead of "delete" head? Ask somebody who knows...