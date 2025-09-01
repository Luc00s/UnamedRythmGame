// ObjRythmPlay Step_0 - Exact duplication of charter editor's TEST mode logic

// Handle pause/reset controls
if (keyboard_check_pressed(vk_space)) {
    if (!game_started) {
        // Start the game
        game_started = true;
        game_paused = false;
        test_start_time = 0;
        countdown = 3;
        countdown_start_realtime = get_timer();
        song_start_realtime = 0;
        current_chart_position = test_start_time - countdown;
        gameplay_score = 0;
        gameplay_combo = 0;
        judgement_alpha = 0;
        
        // Reset camera and effects
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
        
        // Reset lanes
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
        
        // Initialize notes for gameplay (exact copy from charter editor's enter_test_mode)
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
    } else {
        // Toggle pause
        game_paused = !game_paused;
        if (game_paused) {
            audio_pause_sound(song_id);
        } else {
            audio_resume_sound(song_id);
        }
    }
}

if (keyboard_check_pressed(vk_escape)) {
    // Reset the game
    game_started = false;
    game_paused = false;
    audio_pause_sound(song_id);
    audio_sound_set_track_position(song_id, 0);
    gameplay_score = 0;
    gameplay_combo = 0;
    countdown = 3;
    current_chart_position = 0;
    
    // Reset effects
    global_spin_speed = 0;
    global_spin_duration_remaining = 0;
    global_spin_angle = 0;
    
    global_zoom_level = 1.0;
    global_zoom_target = 1.0;
    global_zoom_start = 1.0;
    global_zoom_duration = 0;
    global_zoom_timer = 0;
    global_zoom_easing = 0;
    
    cleanup_effect_surfaces();
    
    var _cam = view_camera[0];
    camera_set_view_angle(_cam, 0);
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
}

if (keyboard_check_pressed(vk_f5)) {
    var _filename = get_open_filename("Chart File|*.json", "");
    if (_filename != "") {
        load_rhythm_chart(_filename);
    }
}

// Only run gameplay logic if game has started
if (!game_started) exit;

// Pause handling
if (game_paused) exit;

// EXACT TEST MODE LOGIC FROM CHARTER EDITOR (lines 2137-2710)

// Lane effects processing (exact copy)
for (var i = 0; i < array_length(lanes); i++) {
    var _lane = lanes[i];
    var _total_x_offset = 0;
    var _total_y_offset = 0;

    // Scale animations
    if (_lane.scale_progress != -1) {
        _lane.scale_progress += (1 / room_speed);
        var _t = min(1.0, _lane.scale_progress / _lane.scale_duration);
        var _eased_t = ease(_t, _lane.scale_easing_function);

        _lane.surface_scale_x = lerp(_lane.start_scale_x, _lane.target_scale_x, _eased_t);
        _lane.surface_scale_y = lerp(_lane.start_scale_y, _lane.target_scale_y, _eased_t);

        if (_t >= 1.0) {
            _lane.scale_progress = -1;
            _lane.surface_scale_x = _lane.target_scale_x;
            _lane.surface_scale_y = _lane.target_scale_y;
        }
    }

    // Angle animations
    if (_lane.angle_progress != -1) {
        _lane.angle_progress += (1 / room_speed);
        var _t = min(1.0, _lane.angle_progress / _lane.angle_duration);
        var _eased_t = ease(_t, _lane.angle_easing_function);

        _lane.surface_angle = lerp(_lane.start_angle, _lane.target_angle, _eased_t);

        if (_t >= 1.0) {
            _lane.angle_progress = -1;
            _lane.surface_angle = _lane.target_angle;
        }
    }

    // 3D transformations
    if (_lane.threed_progress != -1) {
        _lane.threed_progress += (1 / room_speed);
        var _t = min(1.0, _lane.threed_progress / _lane.threed_duration);
        var _eased_t = ease(_t, _lane.threed_easing_function);

        _lane.pitch = lerp(_lane.start_pitch, _lane.target_pitch, _eased_t);
        _lane.yaw = lerp(_lane.start_yaw, _lane.target_yaw, _eased_t);
        _lane.roll = lerp(_lane.start_roll, _lane.target_roll, _eased_t);

        if (_t >= 1.0) {
            _lane.threed_progress = -1;
            _lane.pitch = _lane.target_pitch;
            _lane.yaw = _lane.target_yaw;
            _lane.roll = _lane.target_roll;
        }
    }

    // Active effects processing (exact copy)
    for (var j = array_length(_lane.active_effects) - 1; j >= 0; j--) {
        var _effect = _lane.active_effects[j];

        if (variable_struct_exists(_effect, "update") && is_method(_effect.update)) {
            var _is_finished = _effect.update();
            if (_is_finished) {
                array_delete(_lane.active_effects, j, 1);
            }
            continue;
        }
        
        if (!variable_struct_exists(_effect, "type")) {
            continue;
        }
        
        if (_effect.type == "move") {
            if (_effect.duration <= 0) {
                _lane.settled_x += _effect.move_x;
                _lane.settled_y += _effect.move_y;
                array_delete(_lane.active_effects, j, 1);
                continue;
            }

            _effect.progress += (1 / room_speed);
            var is_finished = (_effect.progress >= _effect.duration);

            var _t = min(1.0, _effect.progress / _effect.duration);
            var _eased_t = ease(_t, _effect.easing);
            _total_x_offset += lerp(0, _effect.move_x, _eased_t);
            _total_y_offset += lerp(0, _effect.move_y, _eased_t);
        
            if (is_finished) {
                _lane.settled_x += _effect.move_x;
                _lane.settled_y += _effect.move_y;
                _total_x_offset -= _effect.move_x;
                _total_y_offset -= _effect.move_y;
                array_delete(_lane.active_effects, j, 1);
            }
        } 
        else if (_effect.type == "wave") {
            _effect.progress += (1 / room_speed);
            var is_finished = (_effect.progress >= _effect.duration);
            var cycle = _effect.progress * wave_frequency;
            cycle += i * (pi / 2);
            var wave_val = (_effect.wave_type == 1) ? sin(cycle) : cos(cycle);
            
            var fade_duration = 0.25;
            var fade_multiplier = 1.0;
            
            if (_effect.progress < fade_duration) {
                fade_multiplier = ease(_effect.progress / fade_duration, 2);
            }
            else if ((_effect.duration - _effect.progress) < fade_duration) {
                fade_multiplier = ease((_effect.duration - _effect.progress) / fade_duration, 1);
            }
            
            _total_x_offset += _effect.amplitude_x * wave_val * fade_multiplier;
            _total_y_offset += _effect.amplitude_y * wave_val * fade_multiplier;
        
            if (is_finished) {
                array_delete(_lane.active_effects, j, 1);
            }
        }
    }

    _lane.current_x = _lane.settled_x + _total_x_offset;
    _lane.current_y = _lane.settled_y + _total_y_offset;
}

// Countdown and timing logic (exact copy)
var is_counting_down = (song_start_realtime == 0);

if (is_counting_down) {
    var elapsed_realtime = (get_timer() - countdown_start_realtime) / 1000000.0;
    
    if (elapsed_realtime >= 3.0) {
        countdown = 0;
        song_start_realtime = get_timer();
        song_start_chart_position = test_start_time;
        current_chart_position = test_start_time;
        
        audio_sound_set_track_position(song_id, test_start_time - audio_offset);
        audio_resume_sound(song_id);
    } else {
        countdown = 3.0 - elapsed_realtime;
        current_chart_position = test_start_time - countdown;
    }
} else {
    var elapsed_since_song_start = (get_timer() - song_start_realtime) / 1000000.0;
    current_chart_position = min(song_start_chart_position + elapsed_since_song_start, song_length);
}

// Global spin effect (exact copy)
if (global_spin_duration_remaining > 0) {
    global_spin_angle += global_spin_speed * (1 / room_speed);
    global_spin_duration_remaining -= (1 / room_speed);
    if (global_spin_duration_remaining <= 0) {
        global_spin_speed = 0;
    }
} else {
    if (global_spin_angle != 0) {
        var _angle_diff = angle_difference(0, global_spin_angle);
        if (abs(_angle_diff) < 0.01) {
            global_spin_angle = 0;
        } else {
            global_spin_angle += _angle_diff * 0.1;
        }
    }
}

// Note spin effect (exact copy)
if (note_spin_duration_remaining > 0) {
    note_spin_angle += note_spin_speed * (1 / room_speed);
    note_spin_duration_remaining -= (1 / room_speed);
    if (note_spin_duration_remaining <= 0) {
        note_spin_speed = 0;
    }
} else {
    if (note_spin_angle != 0) {
        var _angle_diff = angle_difference(0, note_spin_angle);
        if (abs(_angle_diff) < 0.01) {
            note_spin_angle = 0;
        } else {
            note_spin_angle += _angle_diff * 0.1;
        }
    }
}

// Global zoom effect (exact copy)
if (global_zoom_duration > 0) {
    global_zoom_timer += (1 / room_speed);
    var _t = clamp(global_zoom_timer / global_zoom_duration, 0, 1);
    var _eased_t = ease(_t, global_zoom_easing);
    global_zoom_level = global_zoom_start + (global_zoom_target - global_zoom_start) * _eased_t;
    
    if (_t >= 1.0) {
        global_zoom_level = global_zoom_target;
        global_zoom_duration = 0;
        global_zoom_timer = 0;
    }
}

var _notes_array_test = chart_data.notes;

// Process effect notes (type 3, 4, 5, 6) - exact copy
for (var i = 0; i < array_length(_notes_array_test); i++) {
    var _note = _notes_array_test[i];
    if ((_note.type == 3 || _note.type == 4 || _note.type == 5 || _note.type == 6) && _note.hit_state == ENoteState.WAITING && current_chart_position >= _note.timestamp) {
        _note.hit_state = ENoteState.HIT;
        
        if (_note.type == 3) {
            // Move notes (exact copy)
            var _wave_type = variable_struct_exists(_note, "wave_effect") ? _note.wave_effect : 0;
            var _move_x = variable_struct_exists(_note, "lane_x_movement") ? _note.lane_x_movement : 0;
            var _move_y = variable_struct_exists(_note, "lane_y_movement") ? _note.lane_y_movement : 0;
            var _move_dur = variable_struct_exists(_note, "movement_duration") ? _note.movement_duration : 0;
            var _easing = variable_struct_exists(_note, "easing_function") ? _note.easing_function : 0;
            var _apply_to_all = variable_struct_exists(_note, "apply_to_all_lanes") ? _note.apply_to_all_lanes : 0;
        
            var lanes_to_affect = _apply_to_all ? [0, 1, 2, 3] : [_note.lane];

            for (var j = 0; j < array_length(lanes_to_affect); j++) {
                var _lane = lanes[lanes_to_affect[j]];
                var _effect_struct;
        
                if (_wave_type > 0) {
                    _effect_struct = {
                        type: "wave",
                        progress: 0,
                        duration: _move_dur,
                        amplitude_x: _move_x,
                        amplitude_y: _move_y,
                        wave_type: _wave_type
                    };
                } else {
                    _effect_struct = {
                        type: "move",
                        progress: 0,
                        duration: _move_dur,
                        move_x: _move_x,
                        move_y: _move_y,
                        easing: _easing
                    };
                }
                array_push(_lane.active_effects, _effect_struct);
            }
        } else if (_note.type == 4) {
            // Scale notes (exact copy)
            var _target_lane_index = _note.lane;
            var _lane_to_scale = lanes[_target_lane_index];

            var _target_x_scale = variable_struct_exists(_note, "x_scale") ? _note.x_scale : 1.0;
            var _target_y_scale = variable_struct_exists(_note, "y_scale") ? _note.y_scale : 1.0;
            var _duration = variable_struct_exists(_note, "scale_duration") ? _note.scale_duration : 0;
            var _easing = variable_struct_exists(_note, "scale_easing") ? _note.scale_easing : 0;
            var _spin_speed = variable_struct_exists(_note, "spin") ? _note.spin : 0;
            var _target_angle = variable_struct_exists(_note, "angle") ? _note.angle : 0;

            if (_spin_speed != 0 && _duration > 0) {
                note_spin_speed = _spin_speed;
                note_spin_duration_remaining = _duration;
            }

            if (_duration > 0) {
                _lane_to_scale.start_scale_x = _lane_to_scale.surface_scale_x;
                _lane_to_scale.start_scale_y = _lane_to_scale.surface_scale_y;
                _lane_to_scale.target_scale_x = _target_x_scale;
                _lane_to_scale.target_scale_y = _target_y_scale;
                _lane_to_scale.scale_duration = _duration;
                _lane_to_scale.scale_easing_function = _easing;
                _lane_to_scale.scale_progress = 0;

                _lane_to_scale.start_angle = _lane_to_scale.surface_angle;
                _lane_to_scale.target_angle = _target_angle;
                _lane_to_scale.angle_duration = _duration;
                _lane_to_scale.angle_easing_function = _easing;
                _lane_to_scale.angle_progress = 0;
            } else {
                _lane_to_scale.surface_scale_x = _target_x_scale;
                _lane_to_scale.surface_scale_y = _target_y_scale;
                _lane_to_scale.surface_angle = _target_angle;
            }
        } else if (_note.type == 5) {
            // Script notes (exact copy)
            var _script_name = variable_struct_exists(_note, "script_name") ? _note.script_name : "";
            if (_script_name == "FlashEffect") {
                var _time = variable_struct_exists(_note, "time") ? _note.time : 1;
                var _intensity = variable_struct_exists(_note, "intensity") ? _note.intensity : 1;
                with(instance_create_layer(0,0,"Instances", ObjFlash)) {
                    flash = new FlashEffect(_time, _intensity);
                }
            } else if (_script_name == "ShakeEffect") {
                var _time = variable_struct_exists(_note, "time") ? _note.time : 1;
                var _magnitude = variable_struct_exists(_note, "magnitude") ? _note.magnitude : 5;
                with(instance_create_layer(0,0,"Instances", o_Shake)) {
                    shake = new ShakeEffect(_time, _magnitude);
                }
            } else if (_script_name == "SpinEffect") {
                var _duration = variable_struct_exists(_note, "duration") ? _note.duration : 1;
                var _speed = variable_struct_exists(_note, "speed") ? _note.speed : 360;
                SpinEffect(_duration, _speed);
            } else if (_script_name == "WaveLane") {
                var _time = variable_struct_exists(_note, "time") ? _note.time : 1;
                var _intensity = variable_struct_exists(_note, "intensity") ? _note.intensity : 1;
                var _frequency = variable_struct_exists(_note, "frequency") ? _note.frequency : 10;
                var _easing = variable_struct_exists(_note, "easing") ? _note.easing : 0;
                var _target_lane = floor(_note.lane);
                
                var _current_intensity = 0;
                for (var k = array_length(lanes[_target_lane].active_effects) - 1; k >= 0; k--) {
                    var _existing_effect = lanes[_target_lane].active_effects[k];
                    if (variable_struct_exists(_existing_effect, "wave_offset")) {
                        _current_intensity = _existing_effect.current_intensity;
                        array_delete(lanes[_target_lane].active_effects, k, 1);
                    }
                }
                
                var _wave_effect = new WaveLane(_time, _intensity, _frequency, _easing, _current_intensity);
                _wave_effect.target_lane = _target_lane;
                array_push(lanes[_target_lane].active_effects, _wave_effect);
            } else if (_script_name == "ZoomEffect") {
                var _time = variable_struct_exists(_note, "time") ? _note.time : 1;
                var _zoom = variable_struct_exists(_note, "zoom") ? _note.zoom : 1.5;
                var _easing = variable_struct_exists(_note, "easing") ? _note.easing : 0;
                ZoomEffect(_time, _zoom, _easing);
            } else if (_script_name == "3d") {
                var _xangle = variable_struct_exists(_note, "xangle") ? _note.xangle : 0;
                var _yangle = variable_struct_exists(_note, "yangle") ? _note.yangle : 0;
                var _zangle = variable_struct_exists(_note, "zangle") ? _note.zangle : 0;
                var _time = variable_struct_exists(_note, "time") ? _note.time : 1;
                var _easing = variable_struct_exists(_note, "easing") ? _note.easing : 0;
                var _target_lane = floor(_note.lane);
                
                lanes[_target_lane].start_pitch = lanes[_target_lane].pitch;
                lanes[_target_lane].start_yaw = lanes[_target_lane].yaw;
                lanes[_target_lane].start_roll = lanes[_target_lane].roll;
                lanes[_target_lane].target_pitch = _xangle;
                lanes[_target_lane].target_yaw = _yangle;
                lanes[_target_lane].target_roll = _zangle;
                lanes[_target_lane].threed_progress = 0;
                lanes[_target_lane].threed_duration = _time;
                lanes[_target_lane].threed_easing_function = _easing;
            }
        } else if (_note.type == 6) {
            // Reset notes (exact copy)
            var _target_lane = floor(_note.lane);
            if (variable_struct_get(_note, "reset")) {
                var _lane = lanes[_target_lane];
                _lane.surface_scale_x = 1;
                _lane.surface_scale_y = 1;
                _lane.surface_angle = 0;
                _lane.current_x = _lane.settled_x;
                _lane.current_y = _lane.settled_y;
                _lane.active_effects = [];
                
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
                
                _lane.scale_progress = -1;
                _lane.angle_progress = -1;
            }
            if (variable_struct_get(_note, "stop")) {
                var _lane = lanes[_target_lane];
                
                var _total_x_offset = 0;
                var _total_y_offset = 0;
                for (var k = array_length(_lane.active_effects) - 1; k >= 0; k--) {
                    var _effect = _lane.active_effects[k];
                    if (_effect.type == "move") {
                        var _t = min(1.0, _effect.progress / _effect.duration);
                        var _eased_t = ease(_t, _effect.easing);
                        _total_x_offset += lerp(0, _effect.move_x, _eased_t);
                        _total_y_offset += lerp(0, _effect.move_y, _eased_t);
                    } else if (_effect.type == "wave") {
                        var cycle = _effect.progress * wave_frequency + _target_lane * (pi / 2);
                        var wave_val = (_effect.wave_type == 1) ? sin(cycle) : cos(cycle);
                        var fade_duration = 0.25;
                        var fade_multiplier = 1.0;
                        if (_effect.progress < fade_duration) {
                            fade_multiplier = ease(_effect.progress / fade_duration, 2);
                        } else if ((_effect.duration - _effect.progress) < fade_duration) {
                            fade_multiplier = ease((_effect.duration - _effect.progress) / fade_duration, 1);
                        }
                        _total_x_offset += _effect.amplitude_x * wave_val * fade_multiplier;
                        _total_y_offset += _effect.amplitude_y * wave_val * fade_multiplier;
                    }
                }
                _lane.settled_x += _total_x_offset;
                _lane.settled_y += _total_y_offset;
                _lane.active_effects = [];

                if (_lane.scale_progress != -1) {
                    _lane.target_scale_x = _lane.surface_scale_x;
                    _lane.target_scale_y = _lane.surface_scale_y;
                    _lane.scale_progress = _lane.scale_duration;
                }
                if (_lane.angle_progress != -1) {
                    _lane.target_angle = _lane.surface_angle;
                    _lane.angle_progress = _lane.angle_duration;
                }
                if (_lane.threed_progress != -1) {
                    _lane.start_pitch = _lane.pitch;
                    _lane.start_yaw = _lane.yaw;
                    _lane.start_roll = _lane.roll;
                    _lane.target_pitch = _lane.pitch;
                    _lane.target_yaw = _lane.yaw;
                    _lane.target_roll = _lane.roll;
                    _lane.threed_progress = _lane.threed_duration;
                }
            }
        }
    }
}

// Lane receptor animations and judgement fade
for (var i = 0; i < array_length(lanes); i++) {
    if (keyboard_check(lanes[i].key)) {
        lanes[i].highlight_alpha = 1;
        lanes[i].receptor_scale = 1.2;
    } else {
        lanes[i].highlight_alpha = max(0, lanes[i].highlight_alpha - 0.1);
        lanes[i].receptor_scale = lerp(lanes[i].receptor_scale, 1, 0.2);
    }
}

if (judgement_alpha > 0) {
    judgement_alpha -= 0.02;
    judgement_scale = lerp(judgement_scale, 1, 0.2);
}
gameplay_combo_scale = lerp(gameplay_combo_scale, 1, 0.2);

// Note hit detection and input handling (exact copy from charter editor)
if (!is_counting_down) {
    // Handle repel chains and missed notes (exact copy)
    for (var i = 0; i < array_length(_notes_array_test); i++) {
        var _note = _notes_array_test[i];
        
        var _note_time = _note.timestamp + chart_offset;
        if (_note.type == 2) {
            _note_time += repel_offset;
        }
        
        if (_note.hit_state == ENoteState.REPELLING) {
            var _next_note_uid = _note.next_repel_note_uid;
            var _next_note_index = get_note_index_by_uid(_next_note_uid);
            if (_next_note_index != -1) {
                var _next_note = _notes_array_test[_next_note_index];
                var _anim_duration = _next_note.timestamp - _note.timestamp;
        
                _note.repel_anim_progress = (current_chart_position - _note_time) / _anim_duration;
        
                if (_note.repel_anim_progress >= 1) {
                    _note.hit_state = ENoteState.HIT;
                    _next_note.hit_state = ENoteState.WAITING;
                }
            } else {
                _note.hit_state = ENoteState.HIT;
            }
        }
        
        // Miss window check
        var _miss_window = (_note.type == 2) ? window_meh * 2.0 : window_meh;
        if (!_note.is_culled && _note.type < 3 && _note.hit_state == ENoteState.WAITING && (current_chart_position > _note_time + _miss_window)) {
            _note.hit_state = ENoteState.MISSED;
            gameplay_combo = 0;
            show_judgement("MISS", 0, c_red);
            if (_note.type == 2) {
                break_repel_chain(_note.uid);
            }
        }
    }

    // Input handling (exact copy)
    for (var i = 0; i < array_length(lanes); i++) {
        var _key = lanes[i].key;
        
        if (keyboard_check_pressed(_key)) {
            var _best_note_index = -1;
            var _closest_dist = infinity;

            for (var j = 0; j < array_length(_notes_array_test); j++) {
                var _note = _notes_array_test[j];
                if (!_note.is_culled && _note.type < 3 && _note.lane == i && _note.hit_state == ENoteState.WAITING) {
                    var _note_time = _note.timestamp + chart_offset;
                    if (_note.type == 2) {
                        _note_time += repel_offset;
                    }
                    
                    var _dist = abs(_note_time - current_chart_position);
                    
                    var _max_hittable_dist = (_note.type == 2) ? window_meh * 2.0 : window_meh;

                    if (_dist < _max_hittable_dist && _dist < _closest_dist) {
                        _closest_dist = _dist;
                        _best_note_index = j;
                    }
                }
            }
            
            if (_best_note_index != -1) {
                var _hit_note = _notes_array_test[_best_note_index];
                var _hit_note_time = _hit_note.timestamp + chart_offset;
                if (_hit_note.type == 2) {
                    _hit_note_time += repel_offset;
                }
                var _hit_offset = current_chart_position - _hit_note_time;
                
                with (instance_create_layer(lanes[i].current_x, get_playhead_y() + lanes[i].current_y, "Instances", o_HitParticle)) { color = c_white; }
                
                var _w_perfect = (_hit_note.type == 2) ? window_perfect * 2.0 : window_perfect;
                var _w_great = (_hit_note.type == 2) ? window_great * 2.0 : window_great;

                if (_closest_dist <= _w_perfect) { show_judgement("PERFECT", _hit_offset * 1000, c_yellow); gameplay_score += 300; }
                else if (_closest_dist <= _w_great) { show_judgement("GREAT", _hit_offset * 1000, c_lime); gameplay_score += 200; }
                else { show_judgement("MEH", _hit_offset * 1000, c_aqua); gameplay_score += 100; }
                
                gameplay_combo++;
                gameplay_combo_scale = 1.3;
                
                if (_hit_note.type == 0) { 
                    _hit_note.hit_state = ENoteState.HIT;
                } 
                else if (_hit_note.type == 1) { _hit_note.hit_state = ENoteState.HOLDING; }
                else if (_hit_note.type == 2) {
                    if (variable_struct_exists(_hit_note, "next_repel_note_uid") && _hit_note.next_repel_note_uid != -1) {
                        _hit_note.hit_state = ENoteState.REPELLING;
                        _hit_note.repel_anim_progress = 0;
                    } else {
                        _hit_note.hit_state = ENoteState.HIT;
                    }
                }
            }
        }
        
        if (keyboard_check_released(_key)) {
            for (var j = 0; j < array_length(_notes_array_test); j++) {
                var _note = _notes_array_test[j];
                var _note_time = _note.timestamp + chart_offset;
                if (_note.lane == i && _note.hit_state == ENoteState.HOLDING) {
                    var _end_time = _note_time + _note.duration;
                    var _dist = abs(_end_time - current_chart_position);
                    
                    if (_dist <= window_meh) { _note.hit_state = ENoteState.HIT; gameplay_score += 50; show_judgement("PERFECT", 0, c_yellow); }
                    else { _note.hit_state = ENoteState.MISSED; gameplay_combo = 0; show_judgement("MISS", 0, c_red); }
                    break;
                }
            }
        }
    }
}