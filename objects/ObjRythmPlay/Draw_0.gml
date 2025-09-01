// ObjRythmPlay Draw_0 - Exact duplication of charter editor's TEST mode rendering
draw_set_font(fn1);

// Colors (exact copy from charter editor)
var _c_background = make_color_rgb(18, 18, 22);
var _c_lane_dark = make_color_rgb(25, 25, 30);
var _c_lane_light = make_color_rgb(32, 32, 38);
var _c_beat_line = make_color_rgb(60, 60, 60);
var _c_sub_beat_line = make_color_rgb(45, 45, 45);

// Draw background
draw_set_color(_c_background);
draw_rectangle(0, 0, room_width, room_height, false);

// Only render game elements if game has started
if (!game_started) return;

// Get playhead position
var _playhead_y = get_playhead_y();

// Apply global zoom (exact copy from charter editor)
var _original_view_x = camera_get_view_x(view_camera[0]);
var _original_view_y = camera_get_view_y(view_camera[0]);
var _original_view_w = camera_get_view_width(view_camera[0]);
var _original_view_h = camera_get_view_height(view_camera[0]);

if (global_zoom_level != 1.0) {
    var _new_view_w = room_width / global_zoom_level;
    var _new_view_h = room_height / global_zoom_level;
    var _offset_x = (room_width - _new_view_w) / 2;
    var _offset_y = (room_height - _new_view_h) / 2;
    
    camera_set_view_size(view_camera[0], _new_view_w, _new_view_h);
    camera_set_view_pos(view_camera[0], _offset_x, _offset_y);
}

// Apply global spin (exact copy from charter editor)
if (global_spin_angle != 0) {
    camera_set_view_angle(view_camera[0], global_spin_angle);
}

// Draw lanes (exact copy from charter editor)
var _lane_width = 32;
for (var i = 0; i < array_length(lanes); i++) {
    var _lane = lanes[i];
    var _lane_x1 = _lane.current_x - (_lane_width / 2);
    var _lane_x2 = _lane.current_x + (_lane_width / 2);
    var _lane_bg_color = (i % 2 == 0) ? _c_lane_dark : _c_lane_light;
    
    draw_set_color(_lane_bg_color);
    draw_rectangle(_lane_x1, 0, _lane_x2, room_height, false);
    
    if (_lane.highlight_alpha > 0) {
        draw_set_alpha(_lane.highlight_alpha * 0.3);
        draw_set_color(c_white);
        draw_rectangle(_lane_x1, 0, _lane_x2, room_height, false);
        draw_set_alpha(1);
    }
}

// Draw beat lines (exact copy from charter editor)
var _lanes_start_x = lanes[0].current_x - (_lane_width / 2);
var _lanes_end_x = lanes[array_length(lanes) - 1].current_x + (_lane_width / 2);

var _start_beat = floor((current_chart_position / sec_per_beat) - (_playhead_y / (pixels_per_second * sec_per_beat)));
var _end_beat = ceil((current_chart_position / sec_per_beat) + ((room_height - _playhead_y) / (pixels_per_second * sec_per_beat)));

for (var b = _start_beat; b <= _end_beat; b += 0.25) {
    if (b < 0) continue;
    var _beat_time = b * sec_per_beat;
    var _draw_y = _playhead_y + (_beat_time - current_chart_position) * pixels_per_second;
    
    if (b == floor(b)) { 
        draw_set_color(_c_beat_line); 
    } else { 
        draw_set_color(_c_sub_beat_line); 
    }
    draw_line(_lanes_start_x, _draw_y, _lanes_end_x, _draw_y);
}

// Draw notes (exact copy from charter editor)
var _notes_array = chart_data.notes;

for (var i = 0; i < array_length(_notes_array); i++) {
    var _note = _notes_array[i];
    var _note_time = _note.timestamp;
    var _draw_y = _playhead_y + (_note_time - current_chart_position) * pixels_per_second;
    
    // Skip notes that are too far off screen
    if (_draw_y < -100 || _draw_y > room_height + 100) continue;
    
    var _lane_data = lanes[_note.lane];
    var _draw_x = _note.visual_x ?? _lane_data.current_x;
    
    // Note color based on type (exact copy)
    var _note_color = c_white;
    var _note_alpha = 1.0;
    
    if (_note.hit_state == ENoteState.HIT) {
        _note_alpha = 0.3;
    } else if (_note.hit_state == ENoteState.MISSED) {
        _note_color = c_red;
        _note_alpha = 0.5;
    } else if (_note.type == 2) { // Repel notes
        _note_color = make_color_rgb(138, 43, 226); // Purple
    } else if (_note.type == 3) { // Move notes
        _note_color = c_orange;
    } else if (_note.type == 4) { // Scale notes
        _note_color = c_green;
    } else if (_note.type == 5) { // Script notes
        _note_color = c_purple;
    } else if (_note.type == 6) { // Reset notes
        _note_color = c_red;
    }
    
    // Draw note based on type (exact copy)
    if (_note.type == 0) { // Regular note
        var _scale = variable_struct_get(_note, "visual_scale") ?? 1.0;
        var _angle = variable_struct_get(_note, "angle") ?? 0;
        // Add note spin angle if applicable
        _angle += note_spin_angle;
        draw_sprite_ext(SprNote, _lane_data.sprite_index, _draw_x, _draw_y, _scale, _scale, _angle, _note_color, _note_alpha);
        
    } else if (_note.type == 1) { // Hold note
        var _duration = _note.duration;
        var _end_y = _draw_y + (_duration * pixels_per_second);
        var _scale = variable_struct_get(_note, "visual_scale") ?? 1.0;
        
        // Draw hold body
        if (_end_y > _draw_y) {
            var _tex = sprite_get_texture(SprNoteHold, _lane_data.hold_body_index);
            var _uvs = sprite_get_uvs(SprNoteHold, _lane_data.hold_body_index);
            var _w = 17;
            
            draw_primitive_begin_texture(pr_trianglestrip, _tex);
            draw_vertex_texture_color(_draw_x - _w/2, _draw_y, _uvs[0], _uvs[1], _note_color, _note_alpha);
            draw_vertex_texture_color(_draw_x + _w/2, _draw_y, _uvs[2], _uvs[1], _note_color, _note_alpha);
            draw_vertex_texture_color(_draw_x - _w/2, _end_y, _uvs[0], _uvs[3], _note_color, _note_alpha);
            draw_vertex_texture_color(_draw_x + _w/2, _end_y, _uvs[2], _uvs[3], _note_color, _note_alpha);
            draw_primitive_end();
            
            // Draw hold tail
            draw_sprite_ext(SprNoteHold, _lane_data.hold_tail_index, _draw_x, _end_y, _scale, _scale, 0, _note_color, _note_alpha);
        }
        
        // Draw hold head
        var _angle = note_spin_angle;
        draw_sprite_ext(SprNote, _lane_data.sprite_index, _draw_x, _draw_y, _scale, _scale, _angle, _note_color, _note_alpha);
        
    } else { // Other note types (repel, move, scale, script, reset)
        var _scale = variable_struct_get(_note, "visual_scale") ?? 1.0;
        var _angle = variable_struct_get(_note, "angle") ?? 0;
        _angle += note_spin_angle;
        draw_sprite_ext(SprNote, _lane_data.sprite_index, _draw_x, _draw_y, _scale, _scale, _angle, _note_color, _note_alpha);
    }
}

// Draw receptors with lane surfaces if needed (exact copy from charter editor)
for (var i = 0; i < array_length(lanes); i++) {
    var _lane = lanes[i];
    var _receptor_y = _playhead_y + _lane.current_y;
    
    // Check if we need to use surface for transformations
    var _use_surface = (_lane.surface_scale_x != 1 || _lane.surface_scale_y != 1 || _lane.surface_angle != 0 || 
                        _lane.pitch != 0 || _lane.yaw != 0 || _lane.roll != 0);
    
    if (_use_surface && surface_exists(_lane.surface)) {
        surface_set_target(_lane.surface);
        draw_clear_alpha(c_black, 0);
        
        // Draw receptor on surface
        draw_sprite_ext(SprNote, _lane.sprite_index, 16, _receptor_y, 
                       _lane.receptor_scale, _lane.receptor_scale, 0, c_white, 0.25);
        
        surface_reset_target();
        
        // Draw the surface with transformations
        var _draw_x = _lane.current_x - 16;
        var _draw_y = 0;
        
        if (_lane.pitch != 0 || _lane.yaw != 0 || _lane.roll != 0) {
            // 3D transformation would go here - simplified for now
            draw_surface_ext(_lane.surface, _draw_x, _draw_y, _lane.surface_scale_x, _lane.surface_scale_y, 
                           _lane.surface_angle, c_white, 1);
        } else {
            draw_surface_ext(_lane.surface, _draw_x, _draw_y, _lane.surface_scale_x, _lane.surface_scale_y, 
                           _lane.surface_angle, c_white, 1);
        }
    } else {
        // Draw receptor normally
        draw_sprite_ext(SprNote, _lane.sprite_index, _lane.current_x, _receptor_y, 
                       _lane.receptor_scale, _lane.receptor_scale, 0, c_white, 0.25);
    }
}

// Draw playhead line (exact copy from charter editor)
draw_set_color(c_red);
draw_line(_lanes_start_x, _playhead_y, _lanes_end_x, _playhead_y);

// Reset camera transformations (exact copy from charter editor)
camera_set_view_angle(view_camera[0], 0);
if (global_zoom_level != 1.0) {
    camera_set_view_size(view_camera[0], _original_view_w, _original_view_h);
    camera_set_view_pos(view_camera[0], _original_view_x, _original_view_y);
}