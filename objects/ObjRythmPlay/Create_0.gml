// ObjRythmPlay - Exact duplication of charter editor's TEST mode functionality
window_set_fullscreen(1);
window_center();

// Note: UI color macros are already defined in charter editor

// Game state variables
game_started = false;
game_paused = false;

// Chart and song variables
bpm = 153.0;
sec_per_beat = 60.0 / bpm;
audio_offset = 0.0;
chart_offset = 0.025;
repel_offset = 0;

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

// Chart data
note_uid_counter = 0;
chart_data = { bpm: bpm, audio_offset: audio_offset, notes: [] };
chart_filename = "";

// Lanes setup (exact copy from charter editor)
pixels_per_second = 320;
var _num_lanes = 4;
var _lane_width = 32;
var _spacing = 0;
var _total_width = (_num_lanes * _lane_width) + ((_num_lanes - 1) * _spacing);
var _start_x = (room_width - _total_width) / 2;

lanes = [
    { key: ord("D"), x: _start_x + (_lane_width/2), sprite_index: 0, hold_body_index: 0, hold_tail_index: 4, highlight_alpha: 0, receptor_scale: 1, current_x: _start_x + (_lane_width/2), current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2), settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
    { key: ord("F"), x: _start_x + (_lane_width/2) + _lane_width + _spacing, sprite_index: 1, hold_body_index: 1, hold_tail_index: 5, highlight_alpha: 0, receptor_scale: 1, current_x: _start_x + (_lane_width/2) + _lane_width + _spacing, current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2) + _lane_width + _spacing, settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
    { key: ord("J"), x: _start_x + (_lane_width/2) + 2*(_lane_width + _spacing), sprite_index: 2, hold_body_index: 2, hold_tail_index: 6, highlight_alpha: 0, receptor_scale: 1, current_x: _start_x + (_lane_width/2) + 2*(_lane_width + _spacing), current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2) + 2*(_lane_width + _spacing), settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
    { key: ord("K"), x: _start_x + (_lane_width/2) + 3*(_lane_width + _spacing), sprite_index: 3, hold_body_index: 3, hold_tail_index: 7, highlight_alpha: 0, receptor_scale: 1, current_x: _start_x + (_lane_width/2) + 3*(_lane_width + _spacing), current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2) + 3*(_lane_width + _spacing), settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
];

// Create lane surfaces (exact copy from charter editor)
var _surface_width = 32;
var _surface_height = room_height;
for (var i = 0; i < array_length(lanes); i++) {
    if (!surface_exists(lanes[i].surface)) {
        lanes[i].surface = surface_create(_surface_width, _surface_height);
    }
}

// Easing function (exact copy from charter editor)
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

// Test mode variables (exact copy from charter editor)
gameplay_score = 0;
gameplay_combo = 0;
gameplay_combo_scale = 1;
countdown = 3;
test_start_time = 0;
countdown_start_realtime = 0;
song_start_realtime = 0;
song_start_chart_position = 0;
// Note: ENoteState enum is already defined in charter editor
window_perfect = 0.04;
window_great = 0.08;
window_meh = 0.12;
judgement_text = "";
judgement_offset_ms = 0;
judgement_color = c_white;
judgement_alpha = 0;
judgement_scale = 1;

// Wave effect
wave_frequency = 15;

// Spin effects (exact copy from charter editor)
global_spin_speed = 0;
global_spin_duration_remaining = 0;
global_spin_angle = 0;
note_spin_speed = 0;
note_spin_duration_remaining = 0;
note_spin_angle = 0;

// Zoom effects (exact copy from charter editor)
global_zoom_level = 1.0;
global_zoom_target = 1.0;
global_zoom_start = 1.0;
global_zoom_duration = 0;
global_zoom_timer = 0;
global_zoom_easing = 0;

// Effect surfaces (exact copy from charter editor)
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

// Helper functions (exact copy from charter editor)
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

show_judgement = function(_text, _offset_ms, _color) {
    judgement_text = _text;
    judgement_offset_ms = _offset_ms;
    judgement_color = _color;
    judgement_alpha = 1.5;
    judgement_scale = 1.5;
}

// Chart loading functions
load_rhythm_chart = function(_filename) {
    if (file_exists(_filename)) {
        var _buffer = buffer_load(_filename);
        var _json_string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _loaded_struct = json_parse(_json_string);
        
        if (is_struct(_loaded_struct) && variable_struct_exists(_loaded_struct, "notes")) {
            chart_data = _loaded_struct;
            
            bpm = variable_struct_get(chart_data, "bpm") ?? 120;
            audio_offset = variable_struct_get(chart_data, "audio_offset") ?? 0;
            sec_per_beat = 60.0 / bpm;
            
            note_uid_counter = 0;
            var _notes_array = chart_data.notes;
            for (var i = 0; i < array_length(_notes_array); i++) {
                var _note = _notes_array[i];
                if (!variable_struct_exists(_note, "visual_x")) {
                    var _lane_index = floor(_note.lane);
                    _note.visual_x = lanes[_lane_index].x;
                }
                if (!variable_struct_exists(_note, "uid")) {
                    _note.uid = note_uid_counter;
                }
                note_uid_counter = max(note_uid_counter, _note.uid + 1);
                
                // Apply compatibility defaults for different note types
                switch (_note.type) {
                    case 3: 
                        if (!variable_struct_exists(_note, "wave_effect")) _note.wave_effect = 0;
                        if (!variable_struct_exists(_note, "apply_to_all_lanes")) _note.apply_to_all_lanes = 0;
                        if (!variable_struct_exists(_note, "lane_x_movement")) _note.lane_x_movement = 0;
                        if (!variable_struct_exists(_note, "lane_y_movement")) _note.lane_y_movement = 0;
                        if (!variable_struct_exists(_note, "movement_duration")) _note.movement_duration = 0;
                        if (!variable_struct_exists(_note, "easing_function")) _note.easing_function = 0;
                        break;
                        
                    case 4: 
                        if (!variable_struct_exists(_note, "x_scale")) _note.x_scale = 1;
                        if (!variable_struct_exists(_note, "y_scale")) _note.y_scale = 1;
                        if (!variable_struct_exists(_note, "scale_duration")) _note.scale_duration = 0;
                        if (!variable_struct_exists(_note, "scale_easing")) _note.scale_easing = 0;
                        if (!variable_struct_exists(_note, "spin")) _note.spin = 0;
                        if (!variable_struct_exists(_note, "angle")) _note.angle = 0;
                        break;
                        
                    case 5: 
                        if (!variable_struct_exists(_note, "script_name")) _note.script_name = "";
                        if (!variable_struct_exists(_note, "time")) _note.time = 1;
                        if (!variable_struct_exists(_note, "intensity")) _note.intensity = 1;
                        if (!variable_struct_exists(_note, "magnitude")) _note.magnitude = 5;
                        break;
                        
                    case 6: 
                        if (!variable_struct_exists(_note, "reset")) _note.reset = 0;
                        if (!variable_struct_exists(_note, "stop")) _note.stop = 0;
                        break;
                }
                
                // Ensure note has required properties for visuals and gameplay
                if (!variable_struct_exists(_note, "angle")) _note.angle = 0;
                if (!variable_struct_exists(_note, "spin_speed")) _note.spin_speed = 0;
                if (!variable_struct_exists(_note, "spin_duration_remaining")) _note.spin_duration_remaining = 0;
            }
            
            // Sort notes by timestamp
            array_sort(chart_data.notes, function(note_a, note_b) {
                return note_a.timestamp - note_b.timestamp;
            });
            
            chart_filename = _filename;
            show_debug_message("Chart loaded successfully from " + _filename);
            return true;
        } else {
            show_debug_message("Failed to load: Invalid chart file format.");
            return false;
        }
    } else {
        show_debug_message("Failed to load: File not found - " + _filename);
        return false;
    }
}

// Load a default chart if available
if (file_exists("my_chart.json")) {
    load_rhythm_chart("my_chart.json");
}

display_reset(0, 1);