

/// @description Apply compatibility defaults for note properties
/// @param {struct} _note The note to apply compatibility to
function apply_note_compatibility(_note) {
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
}



/// @function prompt_and_save_chart()
/// @description Opens a system dialog to ask the user where to save the chart file.
function prompt_and_save_chart() {
    var _filename = get_save_filename("Chart File|*.json", "my_chart.json");
    
    if (_filename != "") {
        save_chart(_filename);
    }
}



/// @function prompt_and_load_chart()
/// @description Opens a system dialog to ask the user which chart file to load.
function prompt_and_load_chart() {
    var _filename = get_open_filename("Chart File|*.json", "");
    
    if (_filename != "") {
        load_chart(_filename);
    }
}




/// @function save_chart(filename)
/// @description Updates the chart_data struct and saves it to a JSON file.
/// @param {string} _filename The path to save the file to.
function save_chart(_filename) {
    chart_data.bpm = bpm;
    chart_data.audio_offset = audio_offset;
	chart_data.song = song_list[selected_song_index].name;
    
    var _json_string = json_stringify(chart_data);
    var _buffer = buffer_create(string_length(_json_string) + 1, buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _json_string);
    buffer_save(_buffer, _filename);
    buffer_delete(_buffer);
    show_debug_message("Chart saved to " + _filename);
}




/// @function load_chart(filename)
/// @description Loads a chart from a JSON file and applies its settings.
/// @param {string} _filename The path to load the file from.
function load_chart(_filename) {
    if (file_exists(_filename)) {
        var _buffer = buffer_load(_filename);
        var _json_string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _loaded_struct = json_parse(_json_string);
        
        if (is_struct(_loaded_struct) && variable_struct_exists(_loaded_struct, "notes")) {
            chart_data = _loaded_struct;
            
            bpm = variable_struct_get(chart_data, "bpm") ?? 120;
            
            if (load_offset_from_file) {
                audio_offset = variable_struct_get(chart_data, "audio_offset") ?? 0;
            }
            
            sec_per_beat = 60.0 / bpm;
            
			if (variable_struct_exists(chart_data, "song")) {
				var _song_name = chart_data.song;
				var _found_song = false;
				for (var i = 0; i < array_length(song_list); i++) {
					if (song_list[i].name == _song_name) {
						selected_song_index = i;
						var _new_song = song_list[i];
						
						audio_stop_sound(song_id);
						song_to_play = _new_song.asset_index;
						song_asset_name = _new_song.name;
						song_id = audio_play_sound(song_to_play, 1, false);
						audio_pause_sound(song_id);
						song_length = audio_sound_length(song_to_play);
						
						target_chart_position = 0;
						current_chart_position = 0;
						is_paused = true;
						_found_song = true;
						break;
					}
				}
				if (!_found_song) {
					show_message("Warning: Song '" + _song_name + "' not found in project.");
				}
			}
			
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
				
				apply_note_compatibility(_note);
            }
            history = [json_stringify(chart_data)];
            history_index = 0;
            
            sort_chart();
			target_chart_position = 0;
			current_chart_position = 0;
			is_paused = true;
			audio_pause_sound(song_id);
			audio_sound_set_track_position(song_id, 0);
            show_debug_message("Chart loaded. BPM set to " + string(bpm) + ", Offset to " + string(audio_offset));
        } else {
            show_debug_message("Failed to load: Invalid chart file format.");
        }
    } else {
        show_debug_message("Failed to load: File not found - " + _filename);
    }
}