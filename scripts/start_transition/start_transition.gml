// Function to start transition
function start_transition(next_room) {
	if !instance_exists(ObjTransition) instance_create_depth(0,0,-9999,ObjTransition)
	else exit;
	
	with(ObjTransition)
	{
	    if (!transition_active) {

	        var app_w = surface_get_width(application_surface);
	        var app_h = surface_get_height(application_surface);
        
	        old_surface = surface_create(app_w, app_h);
	        surface_copy(old_surface, 0, 0, application_surface);
        
	        transition_active = true;
	        target_room = next_room;
	        erase_amount = 0;
        
	        room_goto(next_room);
	    }
	}
}