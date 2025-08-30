// Function to start transition
function start_transition(next_room) {
	if !instance_exists(ObjTransition) instance_create_depth(0,0,-9998,ObjTransition)
	else exit;
	
	with(ObjTransition)
	{
	    if (!transition_active) {

	        var app_w = surface_get_width(application_surface);
	        var app_h = surface_get_height(application_surface);
        
	        old_surface = surface_create(app_w, app_h);
	        
	        // Check if this is a battle transition
	        var is_battle_transition = (next_room == RoomBattle);
	        
	        if (is_battle_transition) {
	            // For battle transitions, capture surface without players/followers
	            // Temporarily hide player and follower sprites
	            var player_visible = false;
	            var followers_visible = [];
	            
	            if (instance_exists(objPlayer)) {
	                player_visible = objPlayer.visible;
	                objPlayer.visible = false;
	            }
	            
	            with (ObjFollower) {
	                array_push(followers_visible, visible);
	                visible = false;
	            }
	            
	            // Capture the application surface without characters
	            surface_copy(old_surface, 0, 0, application_surface);
	            
	            // Restore player and follower visibility
	            if (instance_exists(objPlayer)) {
	                objPlayer.visible = player_visible;
	            }
	            
	            var follower_index = 0;
	            with (ObjFollower) {
	                if (follower_index < array_length(followers_visible)) {
	                    visible = followers_visible[follower_index];
	                    follower_index++;
	                }
	            }
	        } else {
	            // Normal transition - capture everything
	            surface_copy(old_surface, 0, 0, application_surface);
	        }
        
	        transition_active = true;
	        target_room = next_room;
	        erase_amount = 0;
        
	        room_goto(next_room);
	    }
	}
}