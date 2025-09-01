window_set_fullscreen(1);
window_center();

bpm = 153.0; 
sec_per_beat = 60.0 / bpm;
audio_offset = 0.0;
chart_offset = 0.025;
repel_offset = 0; 
load_offset_from_file = true;

current_chart_position = 0; 
target_chart_position = 0;  
last_chart_position = 0;  

song_to_play = OstSpongeBob;
song_asset_name = "aud_MusicTrack"; 
song_id = audio_play_sound(song_to_play, 1, false);
audio_pause_sound(song_id);
song_length = audio_sound_length(song_to_play);
is_paused = true;
main_volume = 1;

note_uid_counter = 0;
chart_data = { bpm: bpm, audio_offset: audio_offset, notes: [] };
chart_filename = "my_chart.json";

window_perfect = 0.04;
window_great = 0.08;
window_meh = 0.12;
judgement_text = "";
judgement_offset_ms = 0;
judgement_color = c_white;
judgement_alpha = 0;
judgement_scale = 1;

pixels_per_second = 320;
var _num_lanes = 4;
var _lane_width = UI_LANE_WIDTH;
var _spacing = 2;
var _total_width = (_num_lanes * _lane_width) + ((_num_lanes - 1) * _spacing);
var _start_x = (room_width - _total_width) / 2;

lanes = [
    { key: ord("D"), x: _start_x + (_lane_width/2),                      sprite_index: 0, hold_body_index: 0, hold_tail_index: 4, highlight_alpha: 0, receptor_scale: 1, is_pressed: false, current_x: _start_x + (_lane_width/2), current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2), settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
    { key: ord("F"), x: _start_x + (_lane_width/2) + _lane_width + _spacing, sprite_index: 1, hold_body_index: 1, hold_tail_index: 5, highlight_alpha: 0, receptor_scale: 1, is_pressed: false, current_x: _start_x + (_lane_width/2) + _lane_width + _spacing, current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2) + _lane_width + _spacing, settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
    { key: ord("J"), x: _start_x + (_lane_width/2) + 2*(_lane_width + _spacing), sprite_index: 2, hold_body_index: 2, hold_tail_index: 6, highlight_alpha: 0, receptor_scale: 1, is_pressed: false, current_x: _start_x + (_lane_width/2) + 2*(_lane_width + _spacing), current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2) + 2*(_lane_width + _spacing), settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
    { key: ord("K"), x: _start_x + (_lane_width/2) + 3*(_lane_width + _spacing), sprite_index: 3, hold_body_index: 3, hold_tail_index: 7, highlight_alpha: 0, receptor_scale: 1, is_pressed: false, current_x: _start_x + (_lane_width/2) + 3*(_lane_width + _spacing), current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2) + 3*(_lane_width + _spacing), settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
];

var _surface_width = 32;
var _surface_height = room_height;
for (var i = 0; i < array_length(lanes); i++) {
    if (!surface_exists(lanes[i].surface)) {
        lanes[i].surface = surface_create(_surface_width, _surface_height);
    }
}

ease = function(t, type) {
    switch (type) {
        case 0: 
            return t;
        case 1: 
            return 1 - cos((t * pi) / 2);
        case 2: 
            return sin((t * pi) / 2);
        case 3: 
            return -(cos(pi * t) - 1) / 2;
        case 4: 
            return t * t;
        case 5: 
            return 1 - (1 - t) * (1 - t);
        case 6: 
            return t < 0.5 ? 2 * t * t : 1 - power(-2 * t + 2, 2) / 2;
        case 7: 
            return t * t * t;
        case 8: 
            return 1 - power(1 - t, 3);
        case 9: 
            return t < 0.5 ? 4 * t * t * t : 1 - power(-2 * t + 2, 3) / 2;
        case 10: 
            var c1 = 1.70158;
            var c3 = c1 + 1;
            return c3 * t * t * t - c1 * t * t;
        case 11: 
            var c1 = 1.70158;
            var c3 = c1 + 1;
            return 1 + c3 * power(t - 1, 3) + c1 * power(t - 1, 2);
        case 12: 
            return 1 - sqrt(1 - power(t, 2));
        case 13: 
            return sqrt(1 - power(t - 1, 2));
        default:
            return t; 
    }
}

song_list = [
    { name: "OstArt", asset_index: OstArt },
    { name: "OstFabi", asset_index: OstFabi },
    { name: "OstFriendInsideDeltarune", asset_index: OstFriendInsideDeltarune },
    { name: "OstSpongeBob", asset_index: OstSpongeBob },
	{ name: "OstCircusSky", asset_index: OstCircusSky },
	{ name: "OstFinalStrat", asset_index: OstFinalStrat },
	{ name: "OstSmartRace", asset_index: OstSmartRace },
	{ name: "OstMagenta", asset_index: OstMagenta },
	{ name: "OstAmbrosia", asset_index: OstAmbrosia },
	{ name: "OstJeba", asset_index: OstJeba }
];

for (var i = array_length(song_list); i < 200; i++) {
    array_push(song_list, { name: "Song " + string(i + 1), asset_index: -1 });
}
selected_song_index = 0;
for (var i = 0; i < array_length(song_list); i++) {
    if (song_list[i].asset_index != -1 && song_list[i].asset_index == song_to_play) {
        selected_song_index = i;
        break;
    }
}

gameplay_score = 0;
gameplay_combo = 0;
gameplay_combo_scale = 1;
countdown = 3;
test_start_time = 0;
countdown_start_realtime = 0;
song_start_realtime = 0;
song_start_chart_position = 0;

wave_frequency = 15; 

global_spin_speed = 0;
global_spin_duration_remaining = 0;
global_spin_angle = 0;
note_spin_speed = 0;
note_spin_duration_remaining = 0;
note_spin_angle = 0;

global_zoom_level = 1.0;           
global_zoom_target = 1.0;          
global_zoom_start = 1.0;           
global_zoom_duration = 0;          
global_zoom_timer = 0;             
global_zoom_easing = 0;            

effect_surfaces = array_create(2, -1);  
effect_surfaces_width = 0;
effect_surfaces_height = 0;

cleanup_effect_surfaces = function() {
    for (var i = 0; i < array_length(effect_surfaces); i++) {
        if (surface_exists(effect_surfaces[i])) {
            surface_free(effect_surfaces[i]);
            effect_surfaces[i] = -1;
        }
    }
}

ensure_effect_surfaces = function(_width, _height) {
    if (effect_surfaces_width != _width || effect_surfaces_height != _height) {
        cleanup_effect_surfaces();
        effect_surfaces_width = _width;
        effect_surfaces_height = _height;
    }
    
    for (var i = 0; i < array_length(effect_surfaces); i++) {
        if (!surface_exists(effect_surfaces[i])) {
            effect_surfaces[i] = surface_create(_width, _height);
        }
    }
}

break_repel_chain = function(_start_note_uid) {
    var _note_index = get_note_index_by_uid(_start_note_uid);
    if (_note_index == -1) return;
    
    var _current_note = chart_data.notes[_note_index];
    var _current_uid = variable_struct_exists(_current_note, "next_repel_note_uid") ? _current_note.next_repel_note_uid : -1;

    while (_current_uid != -1) {
        var _next_note_index = get_note_index_by_uid(_current_uid);
        if (_next_note_index == -1) break;

        var _note_to_break = chart_data.notes[_next_note_index];
        _note_to_break.hit_state = ENoteState.CHAIN_BROKEN;

        if (variable_struct_exists(_note_to_break, "next_repel_note_uid")) {
            _current_uid = _note_to_break.next_repel_note_uid;
        } else {
            _current_uid = -1;
        }
    }
}

ease_out_back = function(t) {
    var c1 = 1.70158;
    var c3 = c1 + 1;
    return 1 + c3 * power(t - 1, 3) + c1 * power(t - 1, 2);
}

ease_out_cubic = function(t) {
    return 1 - power(1 - t, 3);
}

ensure_note_properties = function() {
    for (var i = 0; i < array_length(chart_data.notes); i++) {
        var _note = chart_data.notes[i];
        if (!variable_struct_exists(_note, "visual_x")) {
             _note.visual_x = lanes[_note.lane].x;
        }
		if (!variable_struct_exists(_note, "angle")) {
			_note.angle = 0;
		}
		if (!variable_struct_exists(_note, "spin_speed")) {
			_note.spin_speed = 0;
		}
		if (!variable_struct_exists(_note, "spin_duration_remaining")) {
			_note.spin_duration_remaining = 0;
		}
    }
}

get_note_index_by_uid = function(_uid) {
	if (_uid == -1) return -1;
	for (var i = 0; i < array_length(chart_data.notes); i++) {
		if (variable_struct_exists(chart_data.notes[i], "uid") && chart_data.notes[i].uid == _uid) {
			return i;
		}
	}
	return -1;
}

get_playhead_y = function() {
    return room_height * 0.9;
}

get_lane_index = function(_key_code) {
    for (var i = 0; i < array_length(lanes); i++) {
        if (lanes[i].key == _key_code) return i;
    }
    return -1;
}

show_judgement = function(_text, _offset_ms, _color) {
    judgement_text = _text;
    judgement_offset_ms = _offset_ms;
    judgement_color = _color;
    judgement_alpha = 1.5;
    judgement_scale = 1.5;
}

display_reset(0,1);

start_play_mode = function() {
    is_paused = false;
    test_start_time = 0;
    countdown = 3;
    countdown_start_realtime = get_timer(); 
    song_start_realtime = 0; 
    current_chart_position = test_start_time - countdown;
    gameplay_score = 0;
    gameplay_combo = 0;
    judgement_alpha = 0;
    
    var _cam = view_camera[0];
    camera_set_view_angle(_cam, 0);
    global_spin_angle = 0;
    
    global_zoom_level = 1.0;
    global_zoom_target = 1.0;
    global_zoom_start = 1.0;
    global_zoom_duration = 0;
    global_zoom_timer = 0;
    global_zoom_easing = 0;
	
	cleanup_effect_surfaces();
	
	for (var i = 0; i < array_length(lanes); i++) {
	    var _lane = lanes[i];
	    _lane.current_x = _lane.x;
	    _lane.current_y = 0;
		_lane.active_effects = [];
		_lane.settled_x = _lane.x;
		_lane.settled_y = 0;
		_lane.surface_scale_x = 1;
		_lane.surface_scale_y = 1;
		_lane.surface_angle = 0;
		
		_lane.pitch = 0;
		_lane.yaw = 0;
		_lane.roll = 0;
		_lane.start_pitch = 0;
		_lane.start_yaw = 0;
		_lane.start_roll = 0;
		_lane.target_pitch = 0;
		_lane.target_yaw = 0;
		_lane.target_roll = 0;
		_lane.threed_progress = -1;
	}
	
	var chained_uids = ds_map_create();
	for (var i = 0; i < array_length(chart_data.notes); i++) {
	    var _note = chart_data.notes[i];
	    if (variable_struct_exists(_note, "next_repel_note_uid") && _note.next_repel_note_uid != -1) {
	        chained_uids[? _note.next_repel_note_uid] = true;
	    }
	}

	for (var i = 0; i < array_length(chart_data.notes); i++) {
	    var _note = chart_data.notes[i];
	    
	    _note.is_culled = (_note.timestamp < test_start_time);
	    _note.hit_state = ENoteState.WAITING;
	    
	    if (variable_struct_exists(_note, "type") && _note.type == 2) {
	        _note.is_repel_chain_start = !ds_map_exists(chained_uids, _note.uid);
	        
	        if (!_note.is_repel_chain_start) {
	            _note.hit_state = ENoteState.INACTIVE_REPULSE;
	        }
	        
	        if (_note.is_repel_chain_start && _note.is_culled) {
	            var _current_note_in_chain = _note;
	            while (_current_note_in_chain != undefined) {
	                _current_note_in_chain.is_culled = true;
	                
	                var _next_uid = variable_struct_exists(_current_note_in_chain, "next_repel_note_uid") ? _current_note_in_chain.next_repel_note_uid : -1;
	                if (_next_uid != -1) {
	                    var _next_idx = get_note_index_by_uid(_next_uid);
	                    _current_note_in_chain = (_next_idx != -1) ? chart_data.notes[_next_idx] : undefined;
	                } else {
	                    _current_note_in_chain = undefined;
	                }
	            }
	        }
	        
	        _note.visual_y = 0;
	        _note.repel_anim_progress = -1;
	    }
	}
	ds_map_destroy(chained_uids);
	
    audio_sound_set_track_position(song_id, 0);
    audio_pause_sound(song_id);
}

load_chart_and_play = function(_filename) {
    if (file_exists(_filename)) {
        var _buffer = buffer_load(_filename);
        var _json_string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _loaded_struct = json_parse(_json_string);
        
        if (is_struct(_loaded_struct) && variable_struct_exists(_loaded_struct, "notes")) {
            chart_data = _loaded_struct;
            
            bpm = variable_struct_get(chart_data, "bpm") ?? 120;
            sec_per_beat = 60.0 / bpm;
            audio_offset = variable_struct_get(chart_data, "audio_offset") ?? 0;
            
            var _song_name = variable_struct_get(chart_data, "song") ?? "OstSpongeBob";
            for (var i = 0; i < array_length(song_list); i++) {
                if (song_list[i].name == _song_name && song_list[i].asset_index != -1) {
                    selected_song_index = i;
                    song_to_play = song_list[i].asset_index;
                    break;
                }
            }
            
            if (song_id != -1) {
                audio_stop_sound(song_id);
            }
            song_id = audio_play_sound(song_to_play, 1, false);
            audio_pause_sound(song_id);
            song_length = audio_sound_length(song_to_play);
            
            ensure_note_properties();
            
            show_debug_message("Chart loaded: " + _filename);
            start_play_mode();
        } else {
            show_debug_message("Failed to load chart: " + _filename);
        }
    } else {
        show_debug_message("Chart file does not exist: " + _filename);
    }
}

prompt_and_load_chart_for_play = function() {
    var _filename = get_open_filename("Chart File|*.json", "");
    
    if (_filename != "") {
        load_chart_and_play(_filename);
    }
}

apply_spin_effect = function(_duration, _speed) {
    global_spin_duration_remaining = max(0, _duration);
    global_spin_speed = _speed;
}

apply_zoom_effect = function(_duration, _zoom, _easing) {
    global_zoom_start = global_zoom_level; 
    global_zoom_target = max(0.1, _zoom); 
    global_zoom_duration = max(0, _duration);
    global_zoom_timer = 0;
    global_zoom_easing = _easing;
}

// Only start when a chart is loaded via F6