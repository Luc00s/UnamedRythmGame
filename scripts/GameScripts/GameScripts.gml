


/// @description Flash effect constructor - creates a screen flash effect
/// @param {real} _time Duration of the flash effect in seconds
/// @param {real} _intensity Alpha intensity of the flash (0-1)
function FlashEffect(_time, _intensity) constructor {
    time = max(0, _time);
    intensity = clamp(_intensity, 0, 1);
    timer = time;

    static update = function() {
        timer -= 1 / room_speed;
        if (timer <= 0) {
            return true; 
        }
        return false; 
    }

    static draw = function() {
        var _alpha = (timer / time) * intensity;
        draw_set_color(c_white);
        draw_set_alpha(_alpha);
        draw_rectangle(0, 0, room_width, room_height, false);
        draw_set_alpha(1);
    }
}




/// @description Screen shake effect constructor - shakes the camera
/// @param {real} _time Duration of the shake effect in seconds  
/// @param {real} _magnitude Intensity of the shake in pixels
function ShakeEffect(_time, _magnitude) constructor {
    duration = max(0, _time);
    magnitude = max(0, _magnitude);
    timer = duration;
    
    var _cam = view_camera[0];
    camera_initial_x = camera_get_view_x(_cam);
    camera_initial_y = camera_get_view_y(_cam);

    static update = function() {
        timer -= 1 / room_speed;
        if (timer <= 0) {
            cleanup();
            return true; 
        }
        
        var _cam = view_camera[0];
        var _x_offset = (random_range(-1, 1) * magnitude);
        var _y_offset = (random_range(-1, 1) * magnitude);
        
        camera_set_view_pos(_cam, camera_initial_x + _x_offset, camera_initial_y + _y_offset);
        
        return false; 
    }

    static cleanup = function() {
        var _cam = view_camera[0];
        camera_set_view_pos(_cam, camera_initial_x, camera_initial_y);
    }
}




/// @description Global spin effect - rotates the entire game view
/// @param {real} _duration Duration of the spin effect in seconds
/// @param {real} _speed Rotation speed in degrees per second
function SpinEffect(_duration, _speed) {
	with(ObjCharterEditor) {
		global_spin_duration_remaining = max(0, _duration);
		global_spin_speed = _speed;
	}
}





/// @description Global zoom effect - zooms the entire game view with easing
/// @param {real} _duration Duration of the zoom effect in seconds
/// @param {real} _zoom Target zoom level (1.0 = normal, >1.0 = zoom in, <1.0 = zoom out)
/// @param {real} _easing Easing function type for zoom interpolation
function ZoomEffect(_duration, _zoom, _easing) {
	with(ObjCharterEditor) {
		global_zoom_start = global_zoom_level; 
		global_zoom_target = max(0.1, _zoom); 
		global_zoom_duration = max(0, _duration);
		global_zoom_timer = 0;
		global_zoom_easing = _easing;
	}
}







/// @description Wave lane effect constructor - creates horizontal wave distortion
/// @param {real} _time Duration of the wave effect in seconds
/// @param {real} _intensity Wave distortion intensity (0-100)
/// @param {real} _frequency Wave frequency for distortion pattern
/// @param {real} _easing Easing function type for intensity interpolation
/// @param {real} _start_intensity Starting intensity value for smooth transitions
function WaveLane(_time, _intensity, _frequency, _easing, _start_intensity) constructor {
    time = max(0, _time);
    base_intensity = max(0, _intensity);
    start_intensity = (_start_intensity != undefined) ? _start_intensity : 0;
    current_intensity = start_intensity; 
    frequency = max(0.1, _frequency); 
    easing_type = _easing;
    timer = 0; 
    wave_offset = 0;
    target_lane = -1; 
    is_finished = false;

    static update = function() {
        timer += 1 / room_speed;
        wave_offset += 5 * (1 / room_speed); 
        
        
        if (timer < time && !is_finished) {
            var _t = clamp(timer / time, 0, 1);
            var _eased_t = other.ease(_t, easing_type);
            current_intensity = start_intensity + (base_intensity - start_intensity) * _eased_t;
        } else if (!is_finished) {
            
            current_intensity = base_intensity;
            is_finished = true;
        }
        
        
        return false;
    }

    
    /// @description Apply method for compatibility (no longer used with shader approach)
    static apply = function() {
    }
}