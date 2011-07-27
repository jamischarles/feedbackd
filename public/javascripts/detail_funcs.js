/*
**********************************************************************
* Copyright 2010
* Jamis Charles
* All Rights Reserved
*
* File: detail_funcs.js
**********************************************************************
* Target    Chg Date    Name             Description
* ========  =========   =============    ================================
* --/--/--  08/18/10    Jamis Charles    initial creation (1.0)


**********************************************************************

*/


/**
* @fileOverview session.fb
* @author Jamis Charles
* @version 1.0
* @requires YUI 3 node base 
* @requires 
*/




/*
todo:
Properly comment and namespace everything like we do at work... Follow the JSdocs convention

1) Build a factory of thread and msg items. DONE
2) Use datasource to query the data from the db. Still necessary?
3) Store all of the thread data from the DB in JS memory. There it will have crud available - DONE
4) Q: Can I convert the already existing object, and add more functionality to it? Or do I need to wrap each one to wrap in more functionality? - DONE

5) Q: Should the overlays be built from markup or be built from JS every time? Lets just see..

TODO: combine all of hte AJAX functions into 1 that takes a lot of config vars? Seems excessive to have this many...

NOTE: Throghout this document you should note that 'thread_id' refers to a thread's database id (primary key), whereas 'thread_index' refers to the index in the zones[] array.

*/




/*
var session = {
	fb: {}
}
*/

//session.fb = {};

/**  
 * @class session.fb
 * @return exposes the init, toggleEC, toggleAll, resizeHeight methods and ecMaskHeights array to the browser 
 * @description private namespace method containing all of the properties and methods related to the animated Expand/Collapse functionality
*/


fb = function() {
	/**
	* @name _overlays
 	* @memberOf session.fb 
	* @type Object
	* @description Object containing the url parameters once getUrlParam() is called...
	*/
	//var Y = "";//make this _Y? So it's private?
	
	/**
	* @name _persistClassName
 	* @memberOf session.fb 
	* @type String
	* @description Classname to give element that should not hide on mouseout.
	*/
	var _persistClassName = "fb-persist";
	
	/**
	* @name _overlays
 	* @memberOf session.fb 
	* @type Object
	* @description Object containing the url parameters once getUrlParam() is called...
	*/
	var _overlays = { //move these children to the bottom where they're declared?
		addItem: function(){},
		zones: [] //array of zones on the page
	};
	
	/**
	* @name _session
 	* @memberOf session.fb 
	* @type Object
	* @description Session data. User name. Consider hashing this? post id...
	*/
	var _session = {}
	
	/**
	 * @method _init
	 * @param  {int} post_id ###
	 * @description Get all dependent YUI components.
	*/
	function _init(post_id, user_name){
		
		//load all dependent YUI Modules
		//it has to wait to execute the rest because they are dependent... so wrap the entire doc in this unless there's desired lazy loading...
		YUI().use('node', 'overlay', "dd-plugin", "io-base", "io-form", "querystring-stringify-simple", "json-parse", "event-key", function(Y_obj) { //package these up globally, so you don't have to wrap the whole thing? Maybe just use the callback to pass the init, then call it globally?
			Y = Y_obj;
			
			//attach listeners to show/hide buttons
			Y.one(".edit_form").on("click", function(){ 
				Y.all(".photo-data .show_on_edit-js").removeClass("hidden");	//this back and forth action should be a generic function. Just pass in the queryselector of them...
				Y.all(".photo-data .hide_on_edit-js").addClass("hidden");
				
			});
			
			//attach submit listener to save button
			Y.one("#edit_listing_form button.save").on("click", function(e){ 
				e.preventDefault();
				_updateListing( Y.one("#edit_listing_form") );
			});
			
			//attach submit listener to cancel button
			Y.one("#edit_listing_form button.cancel").on("click", function(e){ 
				Y.all(".photo-data .hide_on_edit-js").removeClass("hidden");	
				Y.all(".photo-data .show_on_edit-js").addClass("hidden");
			});
			
			//attach delete listener to delete image button
			Y.all(".delete_image").on("click", function(e){ 
				e.preventDefault();
				var id = Y.one(e.target).get("id").replace("delete_", ""); //remove the delete_ prefix and return the actual id...
				//console.log(id);
				_deletePhoto(id);
			});
			
			//console.log("components loaded");
			//console.log(Y); 
			
			//get all the thread data from the DB, and assemble the zones global obj
			// _getThreadData(post_id);
			// 			
			// 			//build the zones from the threadData...
			// 	        for(var i=0; i < _overlays.zones.length; i++){
			// 	        	_build_zone(i);
			// 	        }
			// 	        
			// 	        //set the user id
			// 	        _session.user_name = user_name;
			// 	        _session.post_id = post_id;
			// 	        
			// 	        //attach listeners to the basic menu functions...
			// 	        Y.one("#addCommentOverlayLink").on("click", _draw_new_zone);
			// 	        Y.one("#toggleAllZonesLink").on("click", function(){ _toggle_all_zones(); });
			// 	        
			// 	        //be able to create new zones
			// 	        _prep_draw_zone();
			// 	        
			// 	        //prep author overlay
			// 	        _create_author_overlay();
		});
		
		//load the resizable module from the gallery. HACK from the gallery. consider using yui 2 instead?
		
		
		
		
		//maybe put the loader in here?
		//start building the page...?
		
		//loop through all the records from the db and store them in new zones and msgs	
		
	};
		
	
	/**
	 * @method _overlays.addItem
	 * @param  {int} post_id ###
	 * @return Returns the threadIndex of the thread item just inserted into the zones array. 
	 * @description @description Add a new overlay. FIXME This will need to be changed for the ajax stuff...
	*/
	_overlays.addItem = function(threadData){
		//_overlays[] = {};
		
		//I think this stuff should live in the getThreadData fn. 
		//include a flag for if it's ajax. If it is, modify in db, and then here in obj...
		var thread = _wrapThread(threadData);
		
		//add new element to the zones array, which returns array.length. 
		var threadIndex = _overlays.zones.push(thread) -1; //get the proper index
		
		
		//return the index that was just inserted
		return threadIndex;
	} 
		
	//@description Constructor function, sort of for adding a new thread to the overlays	
	_overlays.deleteItem = function(){ 
		
		
	} 
	
		
		
	//@description Wrap existing thread data with custom functions. 
	function _wrapThread(threadData){
		//take current data, and wrap it in the custom functions...
		threadData.addMsg = function(btnNode){
			//url to add a new msg
		    var uri = "/posts/new_message"; //FIXME make this a better relative url based on how CI does it...
		 
		 	//build form data to submit
		 	var postData = {
				user: _session.user_name,
				zone_id: this.id, //zone id in the DB, not the global zone[index] as in the global js obj
				msg_body: btnNode.get('parentNode').one("textarea.comment_msg").get("value") //the the new message
			}
		 
		   // Create a configuration object for the asynchronous transaction.
			var cfg = {
				method: 'POST',
				data: postData,
				arguments: {
					threadIndex:  btnNode.ancestor(".comment_container").getData("thread_index") //get the thread_index from the container node
				},

				on: { //specific listener, only to this transaction. if Y.on is used, it's a listener for ALL io transactions...
					complete: complete
				}

			};
		   
		    // Define a function to handle the response data.
		    function complete(id, o, args) {
		    	//console.log("firing complete");
		        var id = id; // Transaction ID.
		        var jsonData = Y.JSON.parse(o.responseText); // Response data.
		        
		        //jsonData contains the whole threadData (only the message inserted though) for the thread that was inserted
		               
		       //store the response in the zones object
		        _overlays.zones[args.threadIndex].messages.push( jsonData.message );
		        
				//inject it back into the dom using the same method that is used when the msgs are rendered in the first place
				// _buildMsgNode( comment_containerNode, msgData )
				_buildMsgNode( _overlays.zones[args.threadIndex].msgOverlayNode.bodyNode.one(".comment_container"), jsonData.message );
		    };
		 
		    // lifecycle, success or failure is not yet known.
		    //Y.on('io:complete', completeAddMsg, this, ['lorem', 'ipsum']); //global listener for when global IO is happening. we need more specific.
		 	
		 	
			// Make ajax request
			//console.log(Y);
		    var request = Y.io(uri, cfg); 
		   
		}
		
		threadData.deleteMsg = function(){
			console.log('delete Message');
		}
		
		threadData.updateMsg = function(){
			console.log('update Message');
		}
		
		threadData.getMsg = function(){
			console.log('get Message');
		}
		//have child getters, setters, and attributes for this obj...
		
		return threadData;
	}
	
	/**
	 * @method _updateListing
	 * @param  {int} post_id ###
	 * @return ### 
	 * @description ###
	*/
	//fn for foolio
	function _deletePhoto(id){
		YUI().use("io-form", "json-parse", function(Y) {
			//url to add a new msg
		    var uri = "/images/delete/" + id; //FIXME make this a better relative url based on how CI does it...
	 		//console.log(formObject);
		 	//build form data to submit
		 	var postData = {
				//user: _session.user_name,
				//listing_id: this.id, //zone id in the DB, not the global zone[index] as in the global js obj
				//msg_body: btnNode.get('parentNode').one("textarea.comment_msg").get("value") //the the new message
			}
	 
		   // Create a configuration object for the asynchronous transaction.
			var cfg = {
				method: 'POST',
				// form: {
				// 					id: formObject,
				// 					useDisabled: true
				// 				},

				on: { //specific listener, only to this transaction. if Y.on is used, it's a listener for ALL io transactions...
					complete: complete
				}

			};
	   
		    // Define a function to handle the response data.
			function complete(id, o, args) {
		    	//console.log("firing complete");
				//var id = id; // Transaction ID.
				var jsonData = Y.JSON.parse(o.responseText); // Response data.
	        	
				//console.log(jsonData);
		       	if(jsonData.success === true){
					console.log(jsonData.message);
			
					
				}
				 
	        
				//inject it back into the dom using the same method that is used when the msgs are rendered in the first place
				// _buildMsgNode( comment_containerNode, msgData )
				//_buildMsgNode( _overlays.zones[args.threadIndex].msgOverlayNode.bodyNode.one(".comment_container"), jsonData.message );
				};

		    // lifecycle, success or failure is not yet known.
		    //Y.on('io:complete', completeAddMsg, this, ['lorem', 'ipsum']); //global listener for when global IO is happening. we need more specific.
	 	
	 	
			// Make ajax request
		    var request = Y.io(uri, cfg);
		}); //complete
	} //_deletePhoto	
	
	
	/* todo: Write a generic function for swapping out data with fields, and vice versa with response...*/
	
	/**
	 * @method _updateListing
	 * @param  {int} post_id ###
	 * @return ### 
	 * @description ###
	*/
	//fn for foolio
	function _updateListing(formObject){
		YUI().use("io-form", "json-parse", function(Y) {
			//url to add a new msg
		    var uri = "/listings/update_listing"; //FIXME make this a better relative url based on how CI does it...
	 		//console.log(formObject);
		 	//build form data to submit
		 	var postData = {
				//user: _session.user_name,
				//listing_id: this.id, //zone id in the DB, not the global zone[index] as in the global js obj
				//msg_body: btnNode.get('parentNode').one("textarea.comment_msg").get("value") //the the new message
			}
	 
		   // Create a configuration object for the asynchronous transaction.
			var cfg = {
				method: 'POST',
				form: {
					id: formObject,
					useDisabled: true
				},

				on: { //specific listener, only to this transaction. if Y.on is used, it's a listener for ALL io transactions...
					complete: complete
				}

			};
	   
		    // Define a function to handle the response data.
			function complete(id, o, args) {
		    	//console.log("firing complete");
				//var id = id; // Transaction ID.
				var jsonData = Y.JSON.parse(o.responseText); // Response data.
	        	
				//console.log(jsonData);
		       	if(jsonData.success === true){
					//console.log(jsonData.message);
			
					//inject all the data
					Y.one("#edit_name").set("innerHTML", jsonData.message.name);
					Y.one("#edit_city").set("innerHTML", jsonData.message.city);
					Y.one("#edit_state").set("innerHTML", jsonData.message.state);
					
					Y.one("#edit_price").set("innerHTML", jsonData.message.price_range);
					Y.one("#edit_description").set("innerHTML", jsonData.message.description);
					
					Y.one("#edit_phone").set("innerHTML", jsonData.message.phone);
					Y.one("#edit_email").set("innerHTML", jsonData.message.email);
					Y.one("#edit_website").set("innerHTML", jsonData.message.website);
					
					//show and hide
					Y.all(".photo-data .hide_on_edit-js").removeClass("hidden");	
					Y.all(".photo-data .show_on_edit-js").addClass("hidden");
					
					//success message that it's all successful
					Y.one(".notice_container").set("innerHTML", "Listing Successfully Updated");
				}
				 
	        
				//inject it back into the dom using the same method that is used when the msgs are rendered in the first place
				// _buildMsgNode( comment_containerNode, msgData )
				//_buildMsgNode( _overlays.zones[args.threadIndex].msgOverlayNode.bodyNode.one(".comment_container"), jsonData.message );
				};

		    // lifecycle, success or failure is not yet known.
		    //Y.on('io:complete', completeAddMsg, this, ['lorem', 'ipsum']); //global listener for when global IO is happening. we need more specific.
	 	
	 	
			// Make ajax request
		    var request = Y.io(uri, cfg);
		}); //complete
	} // _updateListing
	
	
	
	//@description Factory for creating new msgs
	function _msg(){
		
	}
	
	
	//@description When page is loaded, call this to get the threadData from the db initially. Maybe call this later for ajax checks?
	function _getThreadData(postID){
		//max an Ajax request to get the thread data...
	    var uri = "/posts/get_zones/" + postID; //FIXME make this a better relative url based on how CI does it...
	 
	   // Create a configuration object for the synchronous transaction.
		var cfg = {
			method: 'POST',
			sync: true, //make it a synchronous request (makes everything wait), because other parts are dependant on this info...
			arguments: { 'foo' : 'bar' },
			headers: {'Content-Type': 'application/json',},
			on: { //specific listener, only to this transaction. if Y.on is used, it's a listener for ALL io transactions...
				complete: complete
			}
		};
	   
	    // Define a function to handle the response data.
	    function complete(id, o, args) {
	        var id = id; // Transaction ID.
	        var jsonData = Y.JSON.parse(o.responseText); // Response data.
	        var args = args[1]; // 'ipsum'.
	        
	        //store the threadData in the global JS obj
	        //wrap this in a singleton?
			
			//MOVE all this stuff? SHOULD this stuff be in the init fn?
	        //console.log(jsonData)
			//deep dive to response about zones, since the response includes the post data too...
			for (var key in jsonData.post.zones){					
	        	_overlays.addItem( jsonData.post.zones[key] );
			}
	        
	        
	        //fb.buildMsgContainer(0);
	    };
	 
	    // Subscribe to event "io:complete", and pass an array
	    // as an argument to the event handler "complete", since
	    // "complete" is global.   At this point in the transaction
	    // lifecycle, success or failure is not yet known.
	    //Y.on('io:complete', complete, this, ['lorem', 'ipsum']); //this one is global. Using the specific one up above instead
	 
	 	
		// Make an HTTP request to 'get.php'.
	    // NOTE: This transaction does not use a configuration object.
	    var request = Y.io(uri, cfg);
		
	}	
	
	/**
	 * @method _create_author_overlay
	 * @param  {String} showOrHide Possible values: 'show', 'hide'. Force state for the toggle. 
	 * @description Create the overlay for the author
	*/
	function _create_author_overlay(){
		var authorNode = Y.one("#author_data");
		
		//build overlay and show it
		var overlay = new Y.Overlay({
		    srcNode: authorNode,
			
			height: "800px",
			width: "340px",
			x: 800, 
			y: 16, 
	        
	        visible: false,
	        zIndex: 9
		});
		
		//remove hidden class
		authorNode.removeClass("hidden");
		//add to dom, and show
		overlay.render();
		
		
		//add listener to the edit link
		overlay.headerNode.one(".edit_link").on("click", function(){
			//show the textarea and fill the text in it
			//console.log(overlay.headerNode.one(".author_content"));
			var oldText = overlay.headerNode.one(".author_content").get('innerHTML');
			overlay.headerNode.one("#author_comment_textarea").set('value', oldText);
			
			this.addClass('hidden');
			overlay.headerNode.one(".author_content").addClass('hidden');
			overlay.headerNode.one("#author_comment_textarea").removeClass('hidden');
			overlay.headerNode.one("form .save_button").removeClass('hidden');
			
			//focus the textarea
			overlay.headerNode.one("#author_comment_textarea").focus();
			
		});
		
		
		var textAreaNode = overlay.headerNode.one("#author_comment_textarea"); 
		//add Enter listener for textarea
		Y.on("key", function(e){
			//if shiftkey is on, don't submit, else submit
			if(e.shiftKey == true){
				//think about simulating enter...?
			}else{
				e.halt();
				submit_author_comment();
			}
		}, textAreaNode, 'press:13', Y);
		
		//add listener for save button
		overlay.headerNode.one(".save_button").on("click", submit_author_comment);   
		
		function submit_author_comment(){
		    var uri = "../../post_detail/update_author_comment"; //FIXME make this a better relative url based on how CI does it...
		 
		 	//build form data to submit
		 	var postData = {
				post_id: _session.post_id, //thread id in the DB, not the global thread[index] as in the global js obj
				author_comments: overlay.headerNode.one("#author_comment_textarea").get("value") //the the new message
			}
		 
		   // Create a configuration object for the asynchronous transaction.
			var cfg = {
				method: 'POST',
				data: postData,
				arguments: {
					//threadIndex:  btnNode.ancestor(".comment_container").getData("thread_index") //get the thread_index from the container node
				},

				on: { //specific listener, only to this transaction. if Y.on is used, it's a listener for ALL io transactions...
					complete: complete
				}

			};
		   
		    // Define a function to handle the response data.
		    function complete(id, o, args) {
		    	//console.log("firing complete");
		        var id = id; // Transaction ID.
		        var jsonData = Y.JSON.parse(o.responseText); // Response data.
		        
		        //console.log(jsonData);
		        
		        //if the db was updated successfully
		        if(jsonData.success == true){
		        		
		        	//reset everything. Is there an easier way to do this?
		        	overlay.headerNode.one(".author_content").removeClass('hidden');
		        	overlay.headerNode.one(".edit_link").removeClass('hidden');
					overlay.headerNode.one("#author_comment_textarea").addClass('hidden');
					overlay.headerNode.one("form .save_button").addClass('hidden');	
					
					overlay.headerNode.one(".author_content").set('innerHTML', jsonData.author_comments);
		        		
		        }//else alert the user that it failed...
		        
		       //_buildMsgNode( _overlays.zones[args.threadIndex].msgOverlayNode.bodyNode.one(".comment_container"), jsonData.msgs[0] );
		    };
		 
		    // lifecycle, success or failure is not yet known.
		    //Y.on('io:complete', completeAddMsg, this, ['lorem', 'ipsum']); //global listener for when global IO is happening. we need more specific.
		 	
		 	
			// Make ajax request
		    var request = Y.io(uri, cfg); 
		}
		
		//add listeners for it
		//pass in either the id, or the node
		_add_overlay_events(overlay, "#toggleAuthorComments");
	}
	
	
	/**
	 * @method _toggle_all_zones
	 * @param  {String} showOrHide Possible values: 'show', 'hide'. Force state for the toggle. 
	 * @description Show/hide all zones... Currently accepts a force hide, but not a force show...
	*/
	function _toggle_all_zones(showOrHide){ //just make this one function that is toggle, with a force param?
		
		
		//if clicked from the menu and is hidden OR forceState is show
		if( (typeof showOrHide == "undefined" && Y.one("#zone_container").hasClass("hidden")) || showOrHide == "show" ){
			//show it
			Y.one("#zone_container").removeClass("hidden");
		}else{
			//hide it
			Y.one("#zone_container").addClass("hidden");
		}
		
	}
	
	/**
	 * @method _prep_draw_zone
	 * @description Fired only once. Prepare the draw zone including new zone overlay and its functionality (new zone, ajax submit, close, etc).
	*/
	function _prep_draw_zone(){ 
		var currentZones = [];
		
		var activeZone = ""; //zone that is currently being drawn. Reset to "" after one is done.
		
		//var newZoneNode; //current zoneNode
		var draw_pane = Y.one("#comp_container .draw_zone_pane");
		/*
var position = {
			x: 0,
			y: 0,
			height: 0,
			width: 0
		};
*/
	
	
		//add listeners to draw zone
		draw_pane.on("mousedown", create_zone);
		draw_pane.on("mousemove", resize_zone);
		draw_pane.on("mouseup", place_zone);
		
		//constructor for a zone obj
		function zone(e){
			var newZoneNode = Y.one("#zone_template").cloneNode(true);
			
			//customize it
			//newZoneNode.addClass("active"); //add class of active (set z-index to auto) so the pane will be ABOVE the zone, so listeners will work on pane.
			newZoneNode.removeAttribute("id");
			newZoneNode.removeClass("hidden");
			
			//create overlay
			this.overlay = new Y.Overlay({
			    srcNode: newZoneNode,
			    //id: "jamis", //gets a unique yui id we can reference...
				
				height: "1px",
				width: "1px",
				x: e.pageX, 
				y: e.pageY, 
				plugins: [ Y.Plugin.Drag ],
		        //fillHeight property is what sets the inline height of the -bd body div with the outline in it
		        visible: true
			});
			
			this.position = {
				x: e.pageX,
				y: e.pageY
			}; 
			
			this.overlay.render();
		}
		
		//add handlers
		//on mousedown
		function create_zone(e){
			//!NOTE if problems occur with recognizing the move or up events, it's likely because the z-index of the pane is LOWER than the z-index of the zone.
			
			//set flag that a current draw is happening
			draw_pane.addClass("active");
			
			//create new zone obj, and add to currentZones array, and set as current active
			activeZone = new zone(e);
			currentZones.push( activeZone );		
			//console.log(activeZone);
		} //end create_zone
		
		//on mousemove
		function resize_zone(e){
			
			//if draw_pane is not set to active (current draw or resize in progress), exit.
			if( !draw_pane.hasClass("active") ){
				return;
			}
			
			//console.log(e);
			//get current width, height of the zone
			var newWidth = e.pageX - activeZone.position.x;
			var newHeight = e.pageY - activeZone.position.y;
			
			//console.log("w,h:  " + position.width + " | " + position.height);
			
			activeZone.overlay.set("width", newWidth); //set width of the overlay
			activeZone.overlay.set("height", newHeight); //set height of the overlay

		}
		
		//on mouseup
		function place_zone(e){
			//set local context for overlay
			var overlay = activeZone.overlay;
			
			//console.log("place_zone check");
			//remove flag that pane is being drawn on
			draw_pane.removeClass("editable").removeClass("active");  //how should editable be handled? should you have to click add for each zone?
			
			//show close, drag, and resize_handle, and input field
			overlay.headerNode.one(".controls").removeClass("hidden");
			overlay.footerNode.one(".input_container").removeClass("hidden");
			overlay.bodyNode.one(".resize_handle").removeClass("hidden");
			
			//add listener to the submit button
			var submitButton = overlay.footerNode.one(".input_container button");
			submitButton.on("click", add_zone_ajax, submitButton, overlay); // pass submitButton as the context (this), and overlay as an argument
			
			//add key listener for enter...
			var textAreaNode = overlay.footerNode.one(".comment_msg"); 
			Y.on("key", function(e){
				//if shiftkey is on, don't submit, else submit
				if(e.shiftKey == true){
					//don't do anything
				}else{
					e.halt();
					add_zone_ajax(e, overlay);
				}
			}, textAreaNode, 'press:13', Y);
			
			//add listener to the close button
			overlay.headerNode.one(".controls .close_handle a").on("click", function(){
				//remove overlay completely
				overlay.dd.destroy(); //must remove the draggable first to avoid error. Not sure why.
				overlay.destroy();
			});
			
			//make the overlay draggable, enables the DD plugin for that node
			//overlay.plug(Y.Plugin.Drag);
	 		//add dragHandle
			overlay.dd.addHandle('.drag_handle');
			
			overlay.dd.on('drag:end', function(e){
				//update X,Y manually because drag doesn't seem to reset the overlay x,y automatically...
				overlay.set( "x", e.target.actXY[0] );
				overlay.set( "y", e.target.actXY[1] );
			});
			
			//add resize by harnessing drag and adding a resize handler
			var resize_handle = overlay.bodyNode.one(".resize_handle");
			resize_handle.plug(Y.Plugin.Drag);
			
			//add resize listener for on drag
			resize_handle.dd.on('drag:drag', function(e){
				//SOLUTION 1 to jump bug on resize: hide the controls while resizing (so they won't be included in the height)
				//SOLUTION 2 to jump bug on resize: at start of resize, set the overlay height to include the header and footer heights.
				//SOLUTION 3: measure the height that is sent to db AFTER header and footer are shown so the they are included properly...
				
				//tell the draw_pane we're resizing something
				draw_pane.addClass("active"); //something's happening
				
				//hide controls
				overlay.headerNode.one(".controls").addClass("hidden");
				overlay.footerNode.one(".input_container").addClass("hidden");
				
				//disable the drag
				e.halt();// stopPropagation() and preventDefault()
				
				//resize the zone
				var newWidth = overlay.get("width") + e.info.delta[0]; //current overlay width minus the distance it traveled 
				var newHeight = overlay.get("height") + e.info.delta[1];
				
				//console.log(newHeight);
				//resize using the event delta info (YUI for how much it's changed)
				overlay.set("width", newWidth); //set width of the overlay
				overlay.set("height", newHeight); //set height of the overlay
				
			});
			
			//add resize listener for on end drag
			resize_handle.dd.on('drag:end', function(e){
				//show controls
				overlay.headerNode.one(".controls").removeClass("hidden");
				overlay.footerNode.one(".input_container").removeClass("hidden");
			});
			
			//hide all the other zones
			_toggle_all_zones("hide");
			
			//remove active zone after mouseup
			activeZone = "";
			
			//focus on textarea
			overlay.footerNode.one(".comment_msg").focus();
		} // END place_zone()
		
		//add a zone to the db, and handle the response
		function add_zone_ajax(e, overlay){ //overlay is passed in through the handler up above...
			
			//max an Ajax request to get the thread data...
		    var uri = "/posts/new_zone/"; //FIXME make this a better relative url based on how CI does it...
		 
		   	//build form data to submit
		 	var postData = {
				user: _session.user_name,
				postID: _session.post_id,
				msg_body: overlay.footerNode.one("textarea.comment_msg").get("value"),
				top: overlay.get("y"), //get these from DOM to include resize or move updates
				left: overlay.get("x"),
				height: overlay.get("height"),
				width: overlay.get("width")
			}
		   	
		   
		   	// Create a configuration object for the asynchronous transaction.
			var cfg = {
				method: 'POST',
				data: postData,
				on: { //specific listener, only to this transaction. if Y.on is used, it's a listener for ALL io transactions...
					complete: complete
				}
			};
		   
		    // Define a function to handle the response data.
		    function complete(id, o, args) {
		        var id = id; // Transaction ID.
		        var jsonData = Y.JSON.parse(o.responseText); // Response data.
		        
		        //jsonData contains the threadData obj for the new thread	
		        //add new thread to the global obj				
		        var threadIndex = _overlays.addItem( jsonData.zone );
		        
		        //remove drawing zone
		        //remove draggable first, so destroy() won't cause error. Not sure why.
		        overlay.dd.destroy();
		        overlay.destroy();
		        
		        //show the current zones again
		        Y.one("#zone_container").removeClass("hidden");
		        
		        //add new zone to the dom, based on the proper threadIndex where the info is stored
		        _build_zone(threadIndex);
				
		        
		    };
		 	
		 	//submit ajax request
		    var request = Y.io(uri, cfg);
		    
		} // end add_zone_ajax()
		
	};
	
	/**
	 * @method _draw_new_zone
	 * @param  {int} ###
	 * @description Provide drawing tools in the UI to draw a new zone.
	*/
	function _draw_new_zone(){ //consider building it once, and then just reusing it?
		//show the draw pane
		Y.one("#comp_container .draw_zone_pane").removeClass("hidden").addClass("editable");
		//set flag that pane is being drawn on
		//draw_pane.addClass("editable");
		
		//show
		_toggle_all_zones("show");
		
		
	}
	
	 
	//FIXME this should be ajax ready, so it can be done on the fly with the same mechanism...
	/**
	 * @method _build_zone
	 * @param  {int} thread_index Index of the thread we're referencing in the _overlay.zones[thread_index] obj. NOT the thread_id from the DB.
	 * @description Build zones from the threadData and inject into the dom with listeners attached...
	*/
	function _build_zone(thread_index){
		//clone the zone template. Make this a singleton so it doesn't have to grab the DOM each time?
		var newZoneNode = Y.one("#zone_template").cloneNode(true);
		var threadData = _overlays.zones[thread_index];
		
		//customize it
		newZoneNode.removeAttribute("id");
		newZoneNode.removeClass("hidden");
		
		//add data to the node, just like .data() in jQuery
		newZoneNode.setData("thread_index", thread_index);
		
		//build overlay and show it
		var overlay = new Y.Overlay({
		    srcNode: newZoneNode,
			
			height: threadData.height,
			width: threadData.width,
			x: parseInt(threadData.left), //change this value to x ?
			y: parseInt(threadData.top), //change this value to y ?
	        
	        visible: true
		});
		
		
		
		//add Listeners to show/hide the comment containers...
		newZoneNode.on("mouseover", function(){ _showMsgContainer( this.getData("thread_index"), this ); });
		newZoneNode.on("mouseout", function(){ _hideMsgContainer( this.getData("thread_index"), this ); });
		
		//tie this closer to the other thing?
		//when clicked, persist msgContainer so it disables hide on mouseout
		newZoneNode.on("click", function(){ 
			var thread_index = newZoneNode.getData("thread_index");
			//add the fb-persist className to the overlay
			_overlays.zones[thread_index].msgOverlayNode.bodyNode.addClass( _persistClassName ); 
			
		});
		
		
		//show overlay
		overlay.render("#zone_container"); //SHOULD ONLY HAPPEN ONCE. Then use .show(), and .hide()?
		
		//add the overlay instance to the zones obj
		_overlays.zones[thread_index].zoneOverlayNode = overlay;
		
		//inject it
		//Y.one("#zone_container").append(newZoneNode);
		
	}
	
	/**
	 * @method _showOverlay
	 * @param  {yui3-overlay} overlay Overlay to show
	 * @param  {HTMLNode} targetNode The node that is firing the event. The hide timer will be attached to this node.  
	 * @description Build zones from the threadData and inject into the dom with listeners attached...
	*/
	function _showOverlay(overlay, targetNode){
		//clear the timeout for the el, attached to the node?	
		clearTimeout( targetNode.getData("hideTimer") );
		
		overlay.show();
	}
	
	/**
	 * @method _hideOverlay
	 * @param  {yui3-overlay} overlay Overlay to hide
	 * @param  {HTMLNode} targetNode The node that is firing the event. The hide timer will be attached to this node.
	 * @description Build zones from the threadData and inject into the dom with listeners attached...
	*/
	function _hideOverlay(overlay, targetNode){
		var timer = setTimeout( function(){
			overlay.hide();
		}, 400);
		
		//store the timer 
		targetNode.setData("hideTimer", timer);
	}
	
	//see if this can be combined with the func above?
	//@description See if msgContainer has already been built. If not, build it, then show. If yes, then just show it...
	function _showMsgContainer(threadIndex, zoneNode){
		//clear the hidetimer
		clearTimeout( zoneNode.getData("hideMsgContainerTimer") );
		
		//if it doesn't exist, create it, then show it
		if( typeof _overlays.zones[threadIndex].msgOverlayNode == "undefined" ){
			var msgOverlayNode = _buildMsgContainer(threadIndex, zoneNode);
			msgOverlayNode.show();
		
			return;
		}
			
			//if it exists, just show it
			_overlays.zones[threadIndex].msgOverlayNode.show(); //Use CSS transitions for this instead?
		
	}
	
	//@description Simply hide the message container if persist is not set. Use CSS transitions for this instead? Include logic to not hide if it's on the comment container...
	function _hideMsgContainer(threadIndex, zoneNode){
		//if the msgContainer has a class set to persist, don't start the hide timer. exit fn
		if( _overlays.zones[threadIndex].msgOverlayNode.bodyNode.hasClass(_persistClassName) ){
			return;
		}
		
		var timer = setTimeout( function(){
			_overlays.zones[threadIndex].msgOverlayNode.hide();
		}, 400);
		
		//store the timer 
		zoneNode.setData("hideMsgContainerTimer", timer);
		
	}
	
	/**
	 * @method _buildMsgNode
	 * @param  {node} comment_containerNode Comment_containerNode to insert the comments into
	 * @param  {object} msgData Message object from _overlays.zones[threadIndex].msgs[] array.
	 * @description Build and inject a message node item
	*/
	function _buildMsgNode(comment_containerNode, msgData){
		//for each msg, clone a node and add it to the 
 		var contentNode = comment_containerNode.one(".content"); //combine these 2 into 1?
 		
 		var newMsgNode = contentNode.one(".msg_item").cloneNode(true);
 		//remove the template class from the cloned copy
 		newMsgNode.removeClass("template");
 		
 		//remove any template nodes... Should only be found the first time
 		contentNode.all(".msg_item.template").remove(); 

 		//get data from obj
 		var body = msgData.body;
 		var name = msgData.user_id; //we'll join the user name in later.
 		//console.log(msgData);
 		
 		//set the data in the newly created node
 		newMsgNode.one(".msg_body").set("innerHTML", body); //set the body
 		newMsgNode.one(".msg_name").set("innerHTML", name); //set the author
 		
 		//insert the new message node
 		contentNode.append(newMsgNode, "after");
	}
	
	//@description Build the container that holds a threads (zones') given messages. Attach listeners to show/hide/close etc it.
	function _buildMsgContainer(threadIndex, zoneNode){
		//gather the data to show in the overlay
	 	var comment_containerNode = Y.one("#comment_flyover_template").cloneNode(true);
	 	//console.log(comment_containerNode);
	 	var contentNode = comment_containerNode.one(".content");
	 	
	 	//set heading #. Clean this up?
	 	contentNode.one(".zone_num").set("innerHTML", threadIndex);
	 	
	 	//assign the thread_index to the container node
	 	comment_containerNode.setData("thread_index", threadIndex);
	 	
	 	//get the msgs from the global JS object, and inject them... 
	 	var msgArray = _overlays.zones[threadIndex].messages;
	 	
	 	//assemble the MsgNodes
	 	for (var i=0; i < msgArray.length; i++){
	 		//build msgNodes
	 		_buildMsgNode( comment_containerNode, msgArray[i] );
	 	}
	 	
	 	
	 	//build the overlay
	    var overlay = new Y.Overlay({ //do we really have to build them each time, or can we build them once and then just show them? Does YUI Cache them?
			bodyContent: comment_containerNode, //use bodyContent instead of srcNode. That way you can use 'overlay.bodyNode' to get the content node.
			visible: true,
	        width: "340px"

		});
		
		//position the overlay and align with the zone and align it with one of the corners
		overlay.set( "align", {node:zoneNode, points:["tl", "bl"]});
		
		//add Listeners to hide the comment containers and cancel the hide timer... 
		comment_containerNode.on("mouseout", function(){ _hideMsgContainer( zoneNode.getData("thread_index"), zoneNode ); });
		comment_containerNode.on("mouseover", function(){ 
			//cancel the hide timer.
			clearTimeout( zoneNode.getData("hideMsgContainerTimer") ); 
		});
		
		//add listener to close button
		comment_containerNode.one(".close_handle a").on("click", function(){
			//un-persist the overlay by removing the classname
			overlay.bodyNode.removeClass( _persistClassName ); //overlay must be defined when the parent function is run, NOT when the event handler is executed
			
			//hide the overlay
			overlay.hide();
		} );
		
		//add listener to 'add comment' link
		comment_containerNode.one(".add_comment_link").on("click", function(){
			//hide the add comment link
			this.addClass("hidden");
			//show the input container
			this.next(".input_container").removeClass("hidden");
			
			//focus on input
			this.next(".input_container").one("textarea").focus();
		} );
		
		
		
		//add listener to 'add comment button'
		comment_containerNode.one(".add_comment_button").on("click", function(e){
			
			var thread_index = zoneNode.getData("thread_index");
			//call the add a message action, pass the button node
			_overlays.zones[thread_index].addMsg(e.target);
			
		} );
		
		//add same listener to 'enter' key while focusing on the textarea... FIX THIS? combine with above?
		var textAreaNode = comment_containerNode.one(".input_container .comment_msg"); 
		Y.on("key", function(e){
			//if shiftkey is on, don't submit, else submit
			if(e.shiftKey == true){
				
			}else{
				e.halt();
				var thread_index = zoneNode.getData("thread_index");
				//call the add a message action, pass the button node
				_overlays.zones[thread_index].addMsg(e.target);
			}
		}, textAreaNode, 'press:13', Y);
		
		
		
		//make the overlay draggable, enables the DD plugin for that node
		comment_containerNode.plug(Y.Plugin.Drag);
 		//add dragHandle
		comment_containerNode.dd.addHandle('.drag_handle');
	    
	    
		
		
		//show the overlay
		overlay.render("body");
		
		//add overlay to zones obj
		_overlays.zones[threadIndex].msgOverlayNode = overlay;
	 	
	 	return overlay;
	}
	 
	/**
	 * @method _add_overlay_events
	 * @param  {yui3-overlay} overlay Overlay to show / hide
	 * @param  {HTMLNode} target Target node that the mouseover, click will be tied to.
	 * @description On mouseover show, on mouseout hide, on click persist, on close remove persist.
	*/
	function _add_overlay_events(overlay, target){
		//get the node in case an ID was passed...
		var target = Y.one(target);
		var close_handle = overlay.headerNode.one(".close_handle a");
		
		//click on link will show/hide overlay
		target.on("click", function(){ 
			//click will show/hide
			//if set to persist
			if ( target.hasClass(_persistClassName) ){
				quickHide();
			}else{ //else, show and add persist
				overlay.show();
				target.addClass(_persistClassName);
				close_handle.ancestor(".controls").removeClass("hidden");
			}
		});
		
		//overlay close handle
		close_handle.on("click", quickHide);
		

		//overlay mouseover / mouseout
		overlay.on("mouseover", function(){
			_showOverlay(overlay, overlay.bodyNode); //bodyNode will have timer data attached to it
		});
		
		overlay.on("mouseout", delayHide);

		
		//hover over link will show overlay
		target.on("mouseover", function(e){
			//if set to persist, simply exit
			if ( target.hasClass(_persistClassName) ){
				return;
			}
			//show it
			_showOverlay(overlay, e.target); //this fn is delayed
			//overlay.show(); //consider using the hideTimer instead?
		});
		
		//mouseOut of link will fire delay hide
		target.on("mouseout", delayHide);
		
		function quickHide(){
			//hide overlay and remove any persist without delay
			overlay.hide();
			target.removeClass(_persistClassName);
			close_handle.ancestor(".controls").addClass("hidden");
		}
		
		function delayHide(){
			//if set to persist, simply exit
			if ( target.hasClass(_persistClassName) ){
				return;
			}
			//hide it
			_hideOverlay(overlay, overlay.bodyNode);
			//overlay.hide();//consider using the hideTimer instead?
		}
	} 
	 
	return{
		init: _init,
		getThreadData: _getThreadData,
		overlays: _overlays,
		showMsgContainer: _showMsgContainer,
		buildMsgContainer: _buildMsgContainer,
		build_zone: _build_zone,
		updateListing: _updateListing
		
	}

}(); //END fb CLASS



//YAHOO.util.Event.onDOMReady(session.linkage.init);
//make sure the content is ready before this fires...
//put this call at the end of hte other file
	
	



