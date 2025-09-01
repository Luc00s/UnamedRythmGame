var _c_background_test = make_color_rgb(18, 18, 22);
var _c_lane_dark_test = c_white;
var _c_lane_light_test = c_white;
var _c_repel_test = make_color_rgb(138, 43, 226);
var _c_move_test = c_orange;
var _playhead_y_test = get_playhead_y();
draw_set_color(_c_background_test);
draw_rectangle(0, 0, room_width, room_height, false);
var _lane_width_test = 28;

for (var i = 0; i < array_length(lanes); i++) {
    var _lane = lanes[i];
    if (!surface_exists(_lane.surface)) {
        _lane.surface = surface_create(96, room_height); 
    }

    surface_set_target(_lane.surface);
    
    draw_clear_alpha(c_black, 0);

    var _lane_bg_color = (i % 2 == 0) ? _c_lane_dark_test : _c_lane_light_test;
    var _xscale = 1.75;
    var _yscale = room_height / sprite_get_height(SprLane);
    draw_sprite_ext(SprLane, 0, 48, room_height / 2, _xscale, _yscale, 0, _lane_bg_color, 1);

    var _time_at_top = current_chart_position - ((_playhead_y_test - _lane.current_y) / pixels_per_second);
    var _time_at_bottom = current_chart_position - ((_playhead_y_test - room_height - _lane.current_y) / pixels_per_second);

    var _start_beat = floor(_time_at_bottom / sec_per_beat);
    var _end_beat = ceil(_time_at_top / sec_per_beat);

    for (var b = _start_beat; b <= _end_beat; b += 1 / 4) {
        if (b < 0) continue;
        var _beat_time = b * sec_per_beat;
        var _draw_y = _playhead_y_test - (_beat_time - current_chart_position) * pixels_per_second;
        
        if (b == floor(b)) { draw_set_color(make_color_rgb(60, 60, 60)); }
        else { draw_set_color(make_color_rgb(45, 45, 45)); }
        var _w = sprite_get_width(SprLane) * 1.75;
        draw_line(48 - _w/2, _draw_y, 48 + _w/2, _draw_y); 
    }

    var _receptor_sprite = _lane.is_pressed ? SprNote : SprNoteEmpty;
    draw_sprite_ext(_receptor_sprite, _lane.sprite_index, 48, _playhead_y_test, 1, 1, 0, c_white, 0.25); 
    if (_lane.highlight_alpha > 0) {
        draw_sprite_ext(_receptor_sprite, _lane.sprite_index, 48, _playhead_y_test, 1, 1, 0, c_white, _lane.highlight_alpha);
    }

    var _notes_array_test = chart_data.notes;
    for (var j = 0; j < array_length(_notes_array_test); j++) {
        var _note = _notes_array_test[j];
		if (variable_struct_exists(_note, "is_culled") && _note.is_culled) continue;
        
        var _note_angle = variable_struct_exists(_note, "angle") ? _note.angle : 0;
        
        if (_note.lane != i || _note.hit_state == ENoteState.HIT || _note.hit_state == ENoteState.CHAIN_BROKEN) continue;
        if (_note.type >= 3) continue;
        
        var _draw_x = 48; 
        var _start_y = _playhead_y_test - (_note.timestamp - current_chart_position) * pixels_per_second;
        var _note_color = (_note.hit_state == ENoteState.MISSED) ? c_dkgray : c_white;
		var _draw_alpha = 1.0;

        if (_note.type == 2) 
		{
			_note_color = _c_repel_test;
			if (_note.hit_state == ENoteState.INACTIVE_REPULSE)
			{
				_draw_alpha = 0.3;
			}
		}

        var _draw_y = _start_y;
        
        if (_note.hit_state == ENoteState.REPELLING && _note.repel_anim_progress != -1) {
            var _progress = _note.repel_anim_progress;
            var _repel_dist = 100;
            var _y_offset = -sin(_progress * pi) * _repel_dist;
            _draw_y = _playhead_y_test + _y_offset;
        }

        if (_note.type == 0 || _note.type == 2) {
               if (_draw_y > -20 && _draw_y < room_height + 20) {
                   draw_sprite_ext(SprNote, _lane.sprite_index, _draw_x, _draw_y, 1, 1, _note_angle + note_spin_angle, _note_color, _draw_alpha);
               }
        } else if (_note.type == 1) {
            var _end_y = _start_y - (_note.duration * pixels_per_second);
            var _current_y = _start_y;
            
            if (_note.hit_state == ENoteState.HOLDING) {
                _current_y = _playhead_y_test;
            }
            
               if (_start_y > -20 && _end_y < room_height + 20) {
                   var _body_height_px = _current_y - _end_y;
                   if (_body_height_px > 0) {
                       var _tex = sprite_get_texture(SprNoteHold, _lane.hold_body_index);
                       var _uvs = sprite_get_uvs(SprNoteHold, _lane.hold_body_index);
                       var _w = 17;
                       draw_primitive_begin_texture(pr_trianglestrip, _tex);
                       draw_vertex_texture_color(_draw_x + 0.5 - _w/2, _end_y, _uvs[0], _uvs[1], _note_color, 1);
                       draw_vertex_texture_color(_draw_x + 0.5 + _w/2, _end_y, _uvs[2], _uvs[1], _note_color, 1);
                       draw_vertex_texture_color(_draw_x + 0.5 - _w/2, _current_y,   _uvs[0], _uvs[3], _note_color, 1);
                       draw_vertex_texture_color(_draw_x + 0.5 + _w/2, _current_y,   _uvs[2], _uvs[3], _note_color, 1);
                       draw_primitive_end();
                   }
                   draw_sprite_ext(SprNoteHold, _lane.hold_tail_index, _draw_x, _end_y, 1, -1, 0, _note_color, 1);
                   
                   if (_note.hit_state != ENoteState.HOLDING) {
                       draw_sprite_ext(SprNote, _lane.sprite_index, _draw_x, _start_y, 1, 1, _note_angle + global_spin_angle, _note_color, 1);
                   }
               }
        }
    }
    
    surface_reset_target();
}

for (var i = 0; i < array_length(lanes); i++) {
    var _lane = lanes[i];
    if (surface_exists(_lane.surface)) {
        var _has_wave_effect = false;
        var _wave_time = 0;
        var _wave_intensity = 0;
        var _wave_frequency = 10.0;
        
        for (var j = 0; j < array_length(_lane.active_effects); j++) {
            var _effect = _lane.active_effects[j];
            if (variable_struct_exists(_effect, "wave_offset")) {
                _has_wave_effect = true;
                _wave_time = _effect.wave_offset;
                _wave_intensity = _effect.current_intensity * 0.01; 
                _wave_frequency = _effect.frequency;
                break;
            }
        }
        
        if (_has_wave_effect) {
            shader_set(sh_wave_distortion);
            shader_set_uniform_f(shader_get_uniform(sh_wave_distortion, "u_time"), _wave_time);
            shader_set_uniform_f(shader_get_uniform(sh_wave_distortion, "u_intensity"), _wave_intensity);
            shader_set_uniform_f(shader_get_uniform(sh_wave_distortion, "u_frequency"), _wave_frequency);
        }
        
        var _has_3d_rotation = (_lane.pitch != 0 || _lane.yaw != 0 || _lane.roll != 0);
        
        if (_has_3d_rotation) {
            var _original_matrix = matrix_get(matrix_world);
            
            var _surface_w = surface_get_width(_lane.surface);
            var _surface_h = surface_get_height(_lane.surface);
            
            var _2d_draw_x = _lane.current_x - (48 * _lane.surface_scale_x);
            var _2d_draw_y = _lane.current_y;
            
            var _center_x = _2d_draw_x + (_surface_w * _lane.surface_scale_x) / 2;
            var _center_y = _2d_draw_y + (_surface_h * _lane.surface_scale_y) / 2;
            
            var _mat_rotation = matrix_build(0, 0, 0, _lane.pitch, _lane.yaw, _lane.roll, 1, 1, 1);
            var _mat_translate = matrix_build(_center_x, _center_y, 0, 0, 0, 0, 1, 1, 1);
            var _final_matrix = matrix_multiply(_mat_rotation, _mat_translate);
            
            matrix_set(matrix_world, _final_matrix);
            
            draw_surface_ext(
                _lane.surface,
                -(_surface_w * _lane.surface_scale_x) / 2,
                -(_surface_h * _lane.surface_scale_y) / 2,
                _lane.surface_scale_x,
                _lane.surface_scale_y,
                _lane.surface_angle,  
                c_white,
                1
            );
            
            matrix_set(matrix_world, _original_matrix);
        } else {
            draw_surface_ext(
                _lane.surface, 
                _lane.current_x - (48 * _lane.surface_scale_x), 
                _lane.current_y, 
                _lane.surface_scale_x, 
                _lane.surface_scale_y, 
                _lane.surface_angle, 
                c_white, 
                1
            );
        }
        
        if (_has_wave_effect) {
            shader_reset();
        }
    }
}

if (countdown > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    var _countdown_text = (countdown > 1) ? string(floor(countdown)) : "GO!";
    var _scale = 2 + (3 - countdown) * 0.5;
    draw_text_transformed(room_width / 2, room_height / 2, _countdown_text, _scale, _scale, 0);
}

if (judgement_alpha > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(judgement_color);
    var _judgement_y = room_height / 2 + 80;
    draw_text_transformed(room_width / 2, _judgement_y, judgement_text, judgement_scale, judgement_scale, 0);
    
    if (judgement_offset_ms != 0) {
        var _offset_text = (judgement_offset_ms > 0 ? "+" : "") + string(round(judgement_offset_ms)) + "ms";
        draw_text(room_width / 2, _judgement_y + 40, _offset_text);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);