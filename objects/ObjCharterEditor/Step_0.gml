


if (keyboard_check_pressed(vk_tab)) {
    if (editor_mode == EEditorMode.EDIT) {
        enter_test_mode();
    } else {
        is_paused = true;
        audio_pause_sound(song_id);
        enter_edit_mode();
    }
}


if (editor_mode == EEditorMode.EDIT) {
    var _mouse_over_scrubber = point_in_rectangle(mouse_x, mouse_y, scrubber_x - 5, scrubber_handle_y, scrubber_x + 5, scrubber_handle_y + scrubber_handle_height);
    if (mouse_check_button_pressed(mb_left) && _mouse_over_scrubber) {
        is_scrubbing = true;
    }

    if (is_scrubbing) {
        var _scrub_progress = (clamp(mouse_y, scrubber_y_start, scrubber_y_start + scrubber_height) - scrubber_y_start) / scrubber_height;
        target_chart_position = _scrub_progress * song_length;
    }

    if (mouse_check_button_released(mb_left)) {
        is_scrubbing = false;
    }

    if (song_length > 0) {
        var _progress = current_chart_position / song_length;
        scrubber_handle_y = scrubber_y_start + (_progress * scrubber_height);
    } else {
        scrubber_handle_y = scrubber_y_start;
    }
}


switch (editor_mode) {
    
    
    
    case EEditorMode.EDIT:
        move_note_menu_anim_progress = lerp(move_note_menu_anim_progress, is_move_note_menu_open ? 1 : 0, 0.25);
        if (abs(move_note_menu_anim_progress - (is_move_note_menu_open ? 1 : 0)) < 0.01) {
            move_note_menu_anim_progress = is_move_note_menu_open ? 1 : 0;
        }

        scale_note_menu_anim_progress = lerp(scale_note_menu_anim_progress, is_scale_note_menu_open ? 1 : 0, 0.25);
script_note_menu_anim_progress = lerp(script_note_menu_anim_progress, is_script_note_menu_open ? 1 : 0, 0.25);
flash_effect_menu_anim_progress = lerp(flash_effect_menu_anim_progress, is_flash_effect_menu_open ? 1 : 0, 0.25);
shake_effect_menu_anim_progress = lerp(shake_effect_menu_anim_progress, is_shake_effect_menu_open ? 1 : 0, 0.25);
spin_effect_menu_anim_progress = lerp(spin_effect_menu_anim_progress, is_spin_effect_menu_open ? 1 : 0, 0.25);
wave_lane_menu_anim_progress = lerp(wave_lane_menu_anim_progress, is_wave_lane_menu_open ? 1 : 0, 0.25);
zoom_effect_menu_anim_progress = lerp(zoom_effect_menu_anim_progress, is_zoom_effect_menu_open ? 1 : 0, 0.25);
threed_effect_menu_anim_progress = lerp(threed_effect_menu_anim_progress, is_threed_effect_menu_open ? 1 : 0, 0.25);
        if (abs(scale_note_menu_anim_progress - (is_scale_note_menu_open ? 1 : 0)) < 0.01) {
    scale_note_menu_anim_progress = is_scale_note_menu_open ? 1 : 0;
}
if (abs(script_note_menu_anim_progress - (is_script_note_menu_open ? 1 : 0)) < 0.01) {
    script_note_menu_anim_progress = is_script_note_menu_open ? 1 : 0;
}
if (abs(flash_effect_menu_anim_progress - (is_flash_effect_menu_open ? 1 : 0)) < 0.01) {
    flash_effect_menu_anim_progress = is_flash_effect_menu_open ? 1 : 0;
}
if (abs(shake_effect_menu_anim_progress - (is_shake_effect_menu_open ? 1 : 0)) < 0.01) {
    shake_effect_menu_anim_progress = is_shake_effect_menu_open ? 1 : 0;
}
if (abs(spin_effect_menu_anim_progress - (is_spin_effect_menu_open ? 1 : 0)) < 0.01) {
    spin_effect_menu_anim_progress = is_spin_effect_menu_open ? 1 : 0;
}
if (abs(wave_lane_menu_anim_progress - (is_wave_lane_menu_open ? 1 : 0)) < 0.01) {
    wave_lane_menu_anim_progress = is_wave_lane_menu_open ? 1 : 0;
}
if (abs(threed_effect_menu_anim_progress - (is_threed_effect_menu_open ? 1 : 0)) < 0.01) {
    threed_effect_menu_anim_progress = is_threed_effect_menu_open ? 1 : 0;
}

reset_note_menu_anim_progress = lerp(reset_note_menu_anim_progress, is_reset_note_menu_open ? 1 : 0, 0.25);
if (abs(reset_note_menu_anim_progress - (is_reset_note_menu_open ? 1 : 0)) < 0.01) {
    reset_note_menu_anim_progress = is_reset_note_menu_open ? 1 : 0;
}

if (is_reset_note_menu_open && keyboard_check_pressed(vk_escape)) {
	is_reset_note_menu_open = false;
}

              if (is_move_note_menu_open || move_note_menu_anim_progress > 0) {
            var _save_active_input = function() {
                if (active_move_menu_input != noone) {
                    if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                        active_move_menu_input.set_value(active_input_original_value);
                    } else {
                        var _val = real(input_buffer);
                        if (is_real(_val)) active_move_menu_input.set_value(_val);
                    }
                    active_move_menu_input = noone;
                    input_buffer = "";
                }
            };

            if (keyboard_check_pressed(vk_escape)) {
                _save_active_input();
                is_move_note_menu_open = false;
            }

            input_cursor_blink++;

            if (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right)) {
                var _is_right_click = mouse_check_button_pressed(mb_right);
                var _clicked_on_field = false;
                
                
                var _ease_progress = ease_out_cubic(move_note_menu_anim_progress);
                var _scale = 0.8 + 0.2 * _ease_progress;
                
                var _menu_w = 220 * _scale;
                var _menu_h = 120 * _scale;
                var _menu_x = room_width / 2;
                var _menu_y = room_height / 2;
                var _menu_x1 = _menu_x - _menu_w / 2;
                var _menu_y1 = _menu_y - _menu_h / 2;

                var _padding = 10 * _scale;
                var _spacing = 8 * _scale;
                var _item_w = (_menu_w - _padding * 2 - _spacing) / 2;
                var _item_h = (_menu_h - _padding * 2 - _spacing * 2) / 3;

                var _col0_x = _menu_x1 + _padding;
                var _col1_x = _col0_x + _item_w + _spacing;
                var _row0_y = _menu_y1 + _padding;
                var _row1_y = _row0_y + _item_h + _spacing;
                var _row2_y = _row1_y + _item_h + _spacing;
                
                var _rects = {
                    lane_x_movement:    [_col0_x, _row0_y, _col0_x + _item_w, _row0_y + _item_h],
                    lane_y_movement:    [_col1_x, _row0_y, _col1_x + _item_w, _row0_y + _item_h],
                    movement_duration:  [_col0_x, _row1_y, _col0_x + _item_w, _row1_y + _item_h],
                    easing_function:    [_col1_x, _row1_y, _col1_x + _item_w, _row1_y + _item_h],
                    wave_effect:        [_col0_x, _row2_y, _col0_x + _item_w, _row2_y + _item_h],
                    apply_to_all_lanes: [_col1_x, _row2_y, _col1_x + _item_w, _row2_y + _item_h]
                };
                
                var button_w = 50 * _scale;
                var button_h = 20 * _scale;
                var button_y = _menu_y1 + _menu_h + (15 * _scale);
                var button_rect = [_menu_x - button_w/2, button_y - button_h/2, _menu_x + button_w/2, button_y + button_h/2];
                
                
                if (point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3]) && !_is_right_click) {
                    _save_active_input();
                    is_move_note_menu_open = false;
                    _clicked_on_field = true;
                }
                
                if (!_is_right_click) {
                    var _field_names = variable_struct_get_names(move_note_menu_fields);
                    for (var i = 0; i < array_length(_field_names); i++) {
                        var _name = _field_names[i];
                        if (point_in_rectangle(mouse_x, mouse_y, _rects[$_name][0], _rects[$_name][1], _rects[$_name][2], _rects[$_name][3])) {
                            var _field = move_note_menu_fields[$_name];
                            if (active_move_menu_input != _field) {
                                _save_active_input();
                                active_move_menu_input = _field;
                                active_input_original_value = _field.get_value();
                                input_buffer = string(active_input_original_value);
                                input_cursor_blink = 0;
                                keyboard_string = "";
                            }
                            _clicked_on_field = true;
                            break;
                        }
                    }
                }
                
                if (point_in_rectangle(mouse_x, mouse_y, _rects.easing_function[0], _rects.easing_function[1], _rects.easing_function[2], _rects.easing_function[3])) {
                    if (move_note_menu_target_note_index != -1) {
                        var _current_ease = get_move_note_value("easing_function", 0);
                        if (_is_right_click) { _current_ease--; if (_current_ease < 0) _current_ease = array_length(easing_function_names) - 1; }
                        else { _current_ease = (_current_ease + 1) % array_length(easing_function_names); }
                        set_move_note_value("easing_function", _current_ease);
                    }
                    _clicked_on_field = true;
                }

                if (point_in_rectangle(mouse_x, mouse_y, _rects.wave_effect[0], _rects.wave_effect[1], _rects.wave_effect[2], _rects.wave_effect[3]) && !_is_right_click) {
                    if (move_note_menu_target_note_index != -1) {
                        var _current_wave = get_move_note_value("wave_effect", 0);
                        _current_wave = (_current_wave + 1) % 3;
                        set_move_note_value("wave_effect", _current_wave);
                    }
                    _clicked_on_field = true;
                }

                if (point_in_rectangle(mouse_x, mouse_y, _rects.apply_to_all_lanes[0], _rects.apply_to_all_lanes[1], _rects.apply_to_all_lanes[2], _rects.apply_to_all_lanes[3]) && !_is_right_click) {
                    if (move_note_menu_target_note_index != -1) {
                        var _current_apply = get_move_note_value("apply_to_all_lanes", 0);
                        _current_apply = 1 - _current_apply;
                        set_move_note_value("apply_to_all_lanes", _current_apply);
                    }
                    _clicked_on_field = true;
                }
                
                if (!_clicked_on_field) {
                     _save_active_input();
                }
            }

            if (active_move_menu_input != noone) {
                var _typed_string = keyboard_string;
                if (_typed_string != "") {
                    var _filtered_string = "";
                    for (var i = 1; i <= string_length(_typed_string); i++) {
                        var _char = string_char_at(_typed_string, i);
                        if (_char == "-") { 
                            if (string_length(input_buffer) == 0) { 
                                _filtered_string += _char; 
                            } 
                        } else if (_char == ".") {
                            if (string_pos(".", input_buffer) == 0) {
                                _filtered_string += _char;
                            }
                        } else if (string_pos(_char, "0123456789")) { 
                            _filtered_string += _char; 
                        }
                    }
                    if (_filtered_string != "" && string_length(input_buffer) + string_length(_filtered_string) <= 15) { 
                        input_buffer += _filtered_string; 
                    }
                    keyboard_string = "";
                }

                if (keyboard_check(vk_backspace)) {
                    backspace_delay--;
                    if (backspace_delay <= 0 && string_length(input_buffer) > 0) {
                        input_buffer = string_copy(input_buffer, 1, string_length(input_buffer) - 1);
                        if (keyboard_check_pressed(vk_backspace)) { backspace_delay = 15; } else { backspace_delay = 3; }
                    }
                } else { backspace_delay = 0; }
            
                if (keyboard_check_pressed(vk_enter)) {
                    _save_active_input();
                }
            } else {
                keyboard_string = "";
            }
        }
        
        else if (is_scale_note_menu_open || scale_note_menu_anim_progress > 0) {
    var _save_active_input = function() {
        if (active_scale_menu_input != noone) {
            if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                active_scale_menu_input.set_value(active_input_original_value);
            } else {
                var _val = real(input_buffer);
                if (is_real(_val)) active_scale_menu_input.set_value(_val);
            }
            active_scale_menu_input = noone;
            input_buffer = "";
        }
    };

    if (keyboard_check_pressed(vk_escape)) {
        _save_active_input();
        is_scale_note_menu_open = false;
    }

    input_cursor_blink++;

    if (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right)) {
        var _is_right_click = mouse_check_button_pressed(mb_right);
        var _clicked_on_field = false;
        
        
        var _ease_progress = ease_out_cubic(scale_note_menu_anim_progress);
        var _scale = 0.8 + 0.2 * _ease_progress;
        
        var _menu_w = 220 * _scale;
        var _menu_h = 120 * _scale;
        var _menu_x = room_width / 2;
        var _menu_y = room_height / 2;
        var _menu_x1 = _menu_x - _menu_w / 2;
        var _menu_y1 = _menu_y - _menu_h / 2;

        var _padding = 10 * _scale;
        var _spacing = 8 * _scale;
        var _item_w = (_menu_w - _padding * 2 - _spacing) / 2;
        var _item_h = (_menu_h - _padding * 2 - _spacing * 2) / 3;

        var _col0_x = _menu_x1 + _padding;
        var _col1_x = _col0_x + _item_w + _spacing;
        var _row0_y = _menu_y1 + _padding;
        var _row1_y = _row0_y + _item_h + _spacing;
        var _row2_y = _row1_y + _item_h + _spacing;
        
        var _rects = {
            x_scale:            [_col0_x, _row0_y, _col0_x + _item_w, _row0_y + _item_h],
            y_scale:            [_col1_x, _row0_y, _col1_x + _item_w, _row0_y + _item_h],
            scale_duration:     [_col0_x, _row1_y, _col0_x + _item_w, _row1_y + _item_h],
            scale_easing:       [_col1_x, _row1_y, _col1_x + _item_w, _row1_y + _item_h],
            spin:               [_col0_x, _row2_y, _col0_x + _item_w, _row2_y + _item_h],
            angle:              [_col1_x, _row2_y, _col1_x + _item_w, _row2_y + _item_h]
        };
        
        var button_w = 50 * _scale;
        var button_h = 20 * _scale;
        var button_y = _menu_y1 + _menu_h + (15 * _scale);
        var button_rect = [_menu_x - button_w/2, button_y - button_h/2, _menu_x + button_w/2, button_y + button_h/2];
        
        
        if (point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3]) && !_is_right_click) {
            _save_active_input();
            is_scale_note_menu_open = false;
            _clicked_on_field = true;
        }
        
        if (!_is_right_click) {
            var _field_names = ["x_scale", "y_scale", "scale_duration", "angle"];
            for (var i = 0; i < array_length(_field_names); i++) {
                var _name = _field_names[i];
                if (variable_struct_exists(_rects, _name) && point_in_rectangle(mouse_x, mouse_y, _rects[$_name][0], _rects[$_name][1], _rects[$_name][2], _rects[$_name][3])) {
                    var _field = scale_note_menu_fields[$_name];
                    if (active_scale_menu_input != _field) {
                        _save_active_input();
                        active_scale_menu_input = _field;
                        active_input_original_value = _field.get_value();
                        input_buffer = string(active_input_original_value);
                        input_cursor_blink = 0;
                        keyboard_string = "";
                    }
                    _clicked_on_field = true;
                    break;
                }
            }
        }
        
        if (point_in_rectangle(mouse_x, mouse_y, _rects.scale_easing[0], _rects.scale_easing[1], _rects.scale_easing[2], _rects.scale_easing[3])) {
            if (scale_note_menu_target_note_index != -1) {
                var _current_ease = get_scale_note_value("scale_easing", 0);
                if (_is_right_click) { _current_ease--; if (_current_ease < 0) _current_ease = array_length(easing_function_names) - 1; }
                else { _current_ease = (_current_ease + 1) % array_length(easing_function_names); }
                set_scale_note_value("scale_easing", _current_ease);
            }
            _clicked_on_field = true;
        } else if (point_in_rectangle(mouse_x, mouse_y, _rects.spin[0], _rects.spin[1], _rects.spin[2], _rects.spin[3])) {
            if (scale_note_menu_target_note_index != -1) {
                var _current_spin = get_scale_note_value("spin", 0);
                set_scale_note_value("spin", _current_spin == 0 ? 360 : 0);
            }
            _clicked_on_field = true;
        }
        
        if (!_clicked_on_field) {
             _save_active_input();
        }
    }

    if (active_scale_menu_input != noone) {
        var _typed_string = keyboard_string;
        if (_typed_string != "") {
            var _filtered_string = "";
            for (var i = 1; i <= string_length(_typed_string); i++) {
                var _char = string_char_at(_typed_string, i);
                if (_char == "-") { 
                    if (string_length(input_buffer) == 0) { 
                        _filtered_string += _char; 
                    } 
                } else if (_char == ".") {
                    if (string_pos(".", input_buffer) == 0) {
                        _filtered_string += _char;
                    }
                } else if (string_pos(_char, "0123456789")) { 
                    _filtered_string += _char; 
                }
            }
            if (_filtered_string != "" && string_length(input_buffer) + string_length(_filtered_string) <= 15) { 
                input_buffer += _filtered_string; 
            }
            keyboard_string = "";
        }

        if (keyboard_check(vk_backspace)) {
            backspace_delay--;
            if (backspace_delay <= 0 && string_length(input_buffer) > 0) {
                input_buffer = string_copy(input_buffer, 1, string_length(input_buffer) - 1);
                if (keyboard_check_pressed(vk_backspace)) { backspace_delay = 15; } else { backspace_delay = 3; }
            }
        } else { backspace_delay = 0; }
    
        if (keyboard_check_pressed(vk_enter)) {
            _save_active_input();
        }
    } else {
        keyboard_string = "";
    }
}else if (is_script_note_menu_open || script_note_menu_anim_progress > 0) {
    if (keyboard_check_pressed(vk_escape)) {
        is_script_note_menu_open = false;
    }

    
    var _ease_progress = ease_out_cubic(script_note_menu_anim_progress);
    var _scale = 0.8 + 0.2 * _ease_progress;
    var menu_w = 220 * _scale;
    var menu_h = 120 * _scale;
    var menu_x = room_width / 2;
    var menu_y = room_height / 2;
    var menu_x1 = menu_x - menu_w / 2;
    var menu_y1 = menu_y - menu_h / 2;
    var _padding = 10 * _scale;
    var _spacing = 8 * _scale;
    var _item_w = (menu_w - _padding * 2 - _spacing) / 2;
    var _item_h = (menu_h - _padding * 2 - _spacing * 2) / 3;
    var _col0_x = menu_x1 + _padding;
    var _row0_y = menu_y1 + _padding + (20 * _scale);

    
    var _easing_button_rect = [_col0_x, _row0_y, _col0_x + _item_w, _row0_y + _item_h];
    var button_w = 50 * _scale;
    var button_h = 20 * _scale;
    var button_x = menu_x;
    var button_y = menu_y1 + menu_h + (15 * _scale);
    var _exit_button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];

    
    var _list = script_note_menu_scroll_list;
    var _list_x = menu_x1 + _item_w + _spacing + (10 * _scale);
    var _list_y = _row0_y;
    var _list_w = _item_w - (20 * _scale);
    var _list_h = _list.view_height;

    
    if (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right)) {
        var _is_right_click = mouse_check_button_pressed(mb_right);

        
        if (point_in_rectangle(mouse_x, mouse_y, _easing_button_rect[0], _easing_button_rect[1], _easing_button_rect[2], _easing_button_rect[3])) {
            if (script_note_menu_target_note_index != -1) {
                var _current_ease = get_script_note_value("easing", 0);
                if (_is_right_click) { _current_ease--; if (_current_ease < 0) _current_ease = array_length(easing_function_names) - 1; }
                else { _current_ease = (_current_ease + 1) % array_length(easing_function_names); }
                set_script_note_value("easing", _current_ease);
            }
        }
        
        else if (point_in_rectangle(mouse_x, mouse_y, _exit_button_rect[0], _exit_button_rect[1], _exit_button_rect[2], _exit_button_rect[3])) {
            is_script_note_menu_open = false;
        }
        
        else if (point_in_rectangle(mouse_x, mouse_y, _list_x, _list_y, _list_x + _list_w, _list_y + _list_h)) {
            var _click_y_in_list = (mouse_y - _list_y) + _list.scroll_y;
            var _clicked_index = floor(_click_y_in_list / _list.item_height);
            if (_clicked_index >= 0 && _clicked_index < array_length(_list.items)) {
                _list.selected_index = _clicked_index;
				var _note = chart_data.notes[script_note_menu_target_note_index];
				_note.script_name = _list.items[_clicked_index];
				commit_action();
                if (_list.items[_clicked_index] == "FlashEffect") {
                    is_flash_effect_menu_open = true;
                    is_script_note_menu_open = false;
                } else if (_list.items[_clicked_index] == "ShakeEffect") {
                    is_shake_effect_menu_open = true;
                    is_script_note_menu_open = false;
                } else if (_list.items[_clicked_index] == "WaveLane") {
                    is_wave_lane_menu_open = true;
                    is_script_note_menu_open = false;
                } else if (_list.items[_clicked_index] == "SpinEffect") {
                    is_spin_effect_menu_open = true;
                    is_script_note_menu_open = false;
                } else if (_list.items[_clicked_index] == "ZoomEffect") {
                    is_zoom_effect_menu_open = true;
                    is_script_note_menu_open = false;
                } else if (_list.items[_clicked_index] == "3d") {
                    is_threed_effect_menu_open = true;
                    is_script_note_menu_open = false;
                }
            }
        }
    }

    
    if (point_in_rectangle(mouse_x, mouse_y, _list_x, _list_y, _list_x + _list_w, _list_y + _list_h)) {
        var _scroll_input = mouse_wheel_down() - mouse_wheel_up();
        if (_scroll_input != 0) {
            _list.target_scroll_y += _scroll_input * _list.item_height * 2;
        }
    }

    var _total_list_height = array_length(_list.items) * _list.item_height;
    if (_total_list_height > _list.view_height) {
        _list.target_scroll_y = clamp(_list.target_scroll_y, 0, _total_list_height - _list.view_height);
    } else {
        _list.target_scroll_y = 0;
    }
    _list.scroll_y = lerp(_list.scroll_y, _list.target_scroll_y, 0.15);
} else if (is_flash_effect_menu_open || flash_effect_menu_anim_progress > 0) {
    var _save_active_input = function() {
        if (active_input != noone) {
            if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                active_input.set_value(active_input_original_value);
            } else {
                var _val = real(input_buffer);
                if (is_real(_val)) active_input.set_value(_val);
            }
            active_input = noone;
            input_buffer = "";
        }
    };

    if (keyboard_check_pressed(vk_escape)) {
        _save_active_input();
        is_flash_effect_menu_open = false;
    }

    input_cursor_blink++;

    if (mouse_check_button_pressed(mb_left)) {
        var _clicked_on_field = false;
        var _ease_progress = ease_out_cubic(flash_effect_menu_anim_progress);
        var _scale = 0.8 + 0.2 * _ease_progress;
        var menu_w = 220 * _scale;
        var menu_h = 120 * _scale;
        var menu_x = room_width / 2;
        var menu_y = room_height / 2;
        var menu_x1 = menu_x - menu_w / 2;
        var menu_y1 = menu_y - menu_h / 2;
        var button_w = 50 * _scale;
        var button_h = 20 * _scale;
        var button_x = menu_x;
        var button_y = menu_y1 + menu_h + (15 * _scale);
        var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];

        if (point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3])) {
            _save_active_input();
            is_flash_effect_menu_open = false;
            _clicked_on_field = true;
        }

        var _field_names = variable_struct_get_names(flash_effect_menu_fields);
        for (var i = 0; i < array_length(_field_names); i++) {
            var _name = _field_names[i];
            var _field = flash_effect_menu_fields[$ _name];
            var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
            if (point_in_rectangle(mouse_x, mouse_y, _rect[0], _rect[1], _rect[2], _rect[3])) {
                if (active_input != _field) {
                    _save_active_input();
                    active_input = _field;
                    active_input_original_value = _field.get_value();
                    input_buffer = string(active_input_original_value);
                    input_cursor_blink = 0;
                    keyboard_string = "";
                }
                _clicked_on_field = true;
                break;
            }
        }

        if (!_clicked_on_field) {
            _save_active_input();
        }
    }

    if (active_input != noone) {
        var _typed_string = keyboard_string;
        if (_typed_string != "") {
            var _filtered_string = "";
            for (var i = 1; i <= string_length(_typed_string); i++) {
                var _char = string_char_at(_typed_string, i);
                if (string_pos(_char, "0123456789.")) {
                    _filtered_string += _char;
                }
            }
            if (_filtered_string != "") {
                input_buffer += _filtered_string;
            }
            keyboard_string = "";
        }

        if (keyboard_check(vk_backspace)) {
            backspace_delay--;
            if (backspace_delay <= 0 && string_length(input_buffer) > 0) {
                input_buffer = string_copy(input_buffer, 1, string_length(input_buffer) - 1);
                if (keyboard_check_pressed(vk_backspace)) {
                    backspace_delay = 15;
                } else {
                    backspace_delay = 3;
                }
            }
        } else {
            backspace_delay = 0;
        }

        if (keyboard_check_pressed(vk_enter)) {
            _save_active_input();
        }
    } else {
        keyboard_string = "";
    }
} else if (is_shake_effect_menu_open || shake_effect_menu_anim_progress > 0) {
    var _save_active_input = function() {
        if (active_input != noone) {
            if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                active_input.set_value(active_input_original_value);
            } else {
                var _val = real(input_buffer);
                if (is_real(_val)) active_input.set_value(_val);
            }
            active_input = noone;
            input_buffer = "";
        }
    };

    if (keyboard_check_pressed(vk_escape)) {
        _save_active_input();
        is_shake_effect_menu_open = false;
    }

    input_cursor_blink++;

    if (mouse_check_button_pressed(mb_left)) {
        var _clicked_on_field = false;
        var _ease_progress = ease_out_cubic(shake_effect_menu_anim_progress);
        var _scale = 0.8 + 0.2 * _ease_progress;
        var menu_w = 220 * _scale;
        var menu_h = 120 * _scale;
        var menu_x = room_width / 2;
        var menu_y = room_height / 2;
        var menu_x1 = menu_x - menu_w / 2;
        var menu_y1 = menu_y - menu_h / 2;
        var button_w = 50 * _scale;
        var button_h = 20 * _scale;
        var button_x = menu_x;
        var button_y = menu_y1 + menu_h + (15 * _scale);
        var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];

        if (point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3])) {
            _save_active_input();
            is_shake_effect_menu_open = false;
            _clicked_on_field = true;
        }

        var _field_names = variable_struct_get_names(shake_effect_menu_fields);
        for (var i = 0; i < array_length(_field_names); i++) {
            var _name = _field_names[i];
            var _field = shake_effect_menu_fields[$_name];
            var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
            if (point_in_rectangle(mouse_x, mouse_y, _rect[0], _rect[1], _rect[2], _rect[3])) {
                if (active_input != _field) {
                    _save_active_input();
                    active_input = _field;
                    active_input_original_value = _field.get_value();
                    input_buffer = string(active_input_original_value);
                    input_cursor_blink = 0;
                    keyboard_string = "";
                }
                _clicked_on_field = true;
                break;
            }
        }

        if (!_clicked_on_field) {
            _save_active_input();
        }
    }

    if (active_input != noone) {
        var _typed_string = keyboard_string;
        if (_typed_string != "") {
            var _filtered_string = "";
            for (var i = 1; i <= string_length(_typed_string); i++) {
                var _char = string_char_at(_typed_string, i);
                if (string_pos(_char, "0123456789.")) {
                    _filtered_string += _char;
                }
            }
            if (_filtered_string != "") {
                input_buffer += _filtered_string;
            }
            keyboard_string = "";
        }

        if (keyboard_check(vk_backspace)) {
            backspace_delay--;
            if (backspace_delay <= 0 && string_length(input_buffer) > 0) {
                input_buffer = string_copy(input_buffer, 1, string_length(input_buffer) - 1);
                if (keyboard_check_pressed(vk_backspace)) {
                    backspace_delay = 15;
                } else {
                    backspace_delay = 3;
                }
            }
        } else {
            backspace_delay = 0;
        }

        if (keyboard_check_pressed(vk_enter)) {
            _save_active_input();
        }
    } else {
        keyboard_string = "";
    }
} else if (is_wave_lane_menu_open || wave_lane_menu_anim_progress > 0) {
    var _save_active_input = function() {
        if (active_input != noone) {
            if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                active_input.set_value(active_input_original_value);
            } else {
                var _val = real(input_buffer);
                if (is_real(_val)) active_input.set_value(_val);
            }
            active_input = noone;
            input_buffer = "";
        }
    };

    if (keyboard_check_pressed(vk_escape)) {
        _save_active_input();
        is_wave_lane_menu_open = false;
    }

    input_cursor_blink++;

    if (mouse_check_button_pressed(mb_left)) {
        var _clicked_on_field = false;
        var _ease_progress = ease_out_cubic(wave_lane_menu_anim_progress);
        var _scale = 0.8 + 0.2 * _ease_progress;
        var menu_w = 220 * _scale;
        var menu_h = 120 * _scale;
        var menu_x = room_width / 2;
        var menu_y = room_height / 2;
        var menu_x1 = menu_x - menu_w / 2;
        var menu_y1 = menu_y - menu_h / 2;
        var button_w = 50 * _scale;
        var button_h = 20 * _scale;
        var button_x = menu_x;
        var button_y = menu_y1 + menu_h + (15 * _scale);
        var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];

        if (point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3])) {
            _save_active_input();
            is_wave_lane_menu_open = false;
            _clicked_on_field = true;
        }

        var _field_names = variable_struct_get_names(wave_lane_menu_fields);
        for (var i = 0; i < array_length(_field_names); i++) {
            var _name = _field_names[i];
            var _field = wave_lane_menu_fields[$ _name];
            var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
            if (point_in_rectangle(mouse_x, mouse_y, _rect[0], _rect[1], _rect[2], _rect[3])) {
                if (active_input != _field) {
                    _save_active_input();
                    active_input = _field;
                    active_input_original_value = _field.get_value();
                    input_buffer = string(_field.get_value());
                }
                _clicked_on_field = true;
                break;
            }
        }

        if (!_clicked_on_field) {
            _save_active_input();
        }
    }

    if (active_input != noone) {
        var _len = string_length(keyboard_string);
        for (var i = 1; i <= _len; i++) {
            var _char = string_char_at(keyboard_string, i);
            if (_char == "." && string_count(".", input_buffer) > 0) continue;
            if (_char == "-" && string_length(input_buffer) > 0) continue;
            if (string_digits(_char) != "" || _char == "." || _char == "-") {
                input_buffer += _char;
            }
        }

        if (keyboard_check_pressed(vk_backspace)) {
            backspace_delay = 20;
        }
        if (keyboard_check(vk_backspace) && backspace_delay <= 0) {
            if (string_length(input_buffer) > 0) {
                input_buffer = string_delete(input_buffer, string_length(input_buffer), 1);
                backspace_delay = 2;
            }
        } else {
            backspace_delay = 0;
        }

        if (keyboard_check_pressed(vk_enter)) {
            _save_active_input();
        }
    }
    
    
    keyboard_string = "";
} else if (is_zoom_effect_menu_open || zoom_effect_menu_anim_progress > 0) {
    var _save_active_input = function() {
        if (active_input != noone) {
            if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                active_input.set_value(active_input_original_value);
            } else {
                var _val = real(input_buffer);
                if (is_real(_val)) active_input.set_value(_val);
            }
            active_input = noone;
            input_buffer = "";
        }
    };

    if (keyboard_check_pressed(vk_escape)) {
        _save_active_input();
        is_zoom_effect_menu_open = false;
    }

    if (mouse_check_button_pressed(mb_left)) {
        var _clicked_on_field = false;
        var _ease_progress = ease_out_cubic(zoom_effect_menu_anim_progress);
        var _scale = 0.8 + 0.2 * _ease_progress;
        var menu_w = 220 * _scale;
        var menu_h = 120 * _scale;
        var menu_x = room_width / 2;
        var menu_y = room_height / 2;
        var menu_x1 = menu_x - menu_w / 2;
        var menu_y1 = menu_y - menu_h / 2;
        var button_w = 50 * _scale;
        var button_h = 20 * _scale;
        var button_x = menu_x;
        var button_y = menu_y1 + menu_h + (15 * _scale);
        var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];

        if (point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3])) {
            _save_active_input();
            is_zoom_effect_menu_open = false;
            _clicked_on_field = true;
        }

        var _field_names = variable_struct_get_names(zoom_effect_menu_fields);
        for (var i = 0; i < array_length(_field_names); i++) {
            var _name = _field_names[i];
            var _field = zoom_effect_menu_fields[$ _name];
            var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
            if (point_in_rectangle(mouse_x, mouse_y, _rect[0], _rect[1], _rect[2], _rect[3])) {
                if (active_input != _field) {
                    _save_active_input();
                    active_input = _field;
                    active_input_original_value = _field.get_value();
                    input_buffer = string(_field.get_value());
                }
                _clicked_on_field = true;
                break;
            }
        }

        if (!_clicked_on_field) {
            _save_active_input();
        }
    }

    if (active_input != noone) {
        var _len = string_length(keyboard_string);
        for (var i = 1; i <= _len; i++) {
            var _char = string_char_at(keyboard_string, i);
            if (_char == "." && string_count(".", input_buffer) > 0) continue;
            if (_char == "-" && string_length(input_buffer) > 0) continue;
            if (string_digits(_char) != "" || _char == "." || _char == "-") {
                input_buffer += _char;
            }
        }

        if (keyboard_check_pressed(vk_backspace)) {
            backspace_delay = 20;
        }
        if (keyboard_check(vk_backspace) && backspace_delay <= 0) {
            if (string_length(input_buffer) > 0) {
                input_buffer = string_delete(input_buffer, string_length(input_buffer), 1);
                backspace_delay = 2;
            }
        } else {
            backspace_delay = 0;
        }

        if (keyboard_check_pressed(vk_enter)) {
            _save_active_input();
        }
    }
    
    keyboard_string = "";
} else if (is_threed_effect_menu_open || threed_effect_menu_anim_progress > 0) {
    var _save_active_input = function() {
        if (active_input != noone) {
            if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                active_input.set_value(active_input_original_value);
            } else {
                var _val = real(input_buffer);
                if (is_real(_val)) active_input.set_value(_val);
            }
            active_input = noone;
            input_buffer = "";
        }
    };

    if (keyboard_check_pressed(vk_escape)) {
        _save_active_input();
        is_threed_effect_menu_open = false;
    }

    if (mouse_check_button_pressed(mb_left)) {
        var _clicked_on_field = false;
        var _ease_progress = ease_out_cubic(threed_effect_menu_anim_progress);
        var _scale = 0.8 + 0.2 * _ease_progress;
        var menu_w = 220 * _scale;
        var menu_h = 160 * _scale;
        var menu_x = room_width / 2;
        var menu_y = room_height / 2;
        var menu_x1 = menu_x - menu_w / 2;
        var menu_y1 = menu_y - menu_h / 2;
        var button_w = 50 * _scale;
        var button_h = 20 * _scale;
        var button_x = menu_x;
        var button_y = menu_y1 + menu_h + (15 * _scale);
        var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];

        if (point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3])) {
            _save_active_input();
            is_threed_effect_menu_open = false;
            _clicked_on_field = true;
        }

        var _field_names = variable_struct_get_names(threed_effect_menu_fields);
        for (var i = 0; i < array_length(_field_names); i++) {
            var _name = _field_names[i];
            var _field = threed_effect_menu_fields[$ _name];
            var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
            if (point_in_rectangle(mouse_x, mouse_y, _rect[0], _rect[1], _rect[2], _rect[3])) {
                if (active_input != _field) {
                    _save_active_input();
                    active_input = _field;
                    active_input_original_value = _field.get_value();
                    input_buffer = string(_field.get_value());
                }
                _clicked_on_field = true;
                break;
            }
        }

        if (!_clicked_on_field) {
            _save_active_input();
        }
    }

    if (active_input != noone) {
        var _len = string_length(keyboard_string);
        for (var i = 1; i <= _len; i++) {
            var _char = string_char_at(keyboard_string, i);
            if (_char == "." && string_count(".", input_buffer) > 0) continue;
            if (_char == "-" && string_length(input_buffer) > 0) continue;
            if (string_digits(_char) != "" || _char == "." || _char == "-") {
                input_buffer += _char;
            }
        }

        if (keyboard_check_pressed(vk_backspace)) {
            backspace_delay = 20;
        }
        if (keyboard_check(vk_backspace) && backspace_delay <= 0) {
            if (string_length(input_buffer) > 0) {
                input_buffer = string_delete(input_buffer, string_length(input_buffer), 1);
                backspace_delay = 2;
            }
        } else {
            backspace_delay = 0;
        }

        if (keyboard_check_pressed(vk_enter)) {
            _save_active_input();
        }
    }
    
    keyboard_string = "";
} else if (is_reset_note_menu_open || reset_note_menu_anim_progress > 0) {
    if (keyboard_check_pressed(vk_escape)) {
        is_reset_note_menu_open = false;
    }

    if (mouse_check_button_pressed(mb_left)) {
        var _ease_progress = ease_out_cubic(reset_note_menu_anim_progress);
        var _scale = 0.8 + 0.2 * _ease_progress;
        var menu_x = room_width / 2;
        var menu_y = room_height / 2;
        var menu_w = 220 * _scale;
        var menu_h = 120 * _scale;
        var menu_x1 = menu_x - menu_w / 2;
        var menu_y1 = menu_y - menu_h / 2;

        var _button_w = 80 * _scale;
        var _button_h = 20 * _scale;
        var _button_y = menu_y1 + 40 * _scale;

        var _reset_button_x = menu_x - 50 * _scale;
        var _reset_button_rect = [_reset_button_x - _button_w/2, _button_y - _button_h/2, _reset_button_x + _button_w/2, _button_y + _button_h/2];

        var _stop_button_x = menu_x + 50 * _scale;
        var _stop_button_rect = [_stop_button_x - _button_w/2, _button_y - _button_h/2, _stop_button_x + _button_w/2, _button_y + _button_h/2];

        var _exit_button_y = menu_y1 + menu_h - 20 * _scale;
        var _exit_button_rect = [menu_x - 30 * _scale, _exit_button_y - 10 * _scale, menu_x + 30 * _scale, _exit_button_y + 10 * _scale];

        if (point_in_rectangle(mouse_x, mouse_y, _reset_button_rect[0], _reset_button_rect[1], _reset_button_rect[2], _reset_button_rect[3])) {
            var _current_val = get_reset_note_value("reset", 0);
            set_reset_note_value("reset", 1 - _current_val);
        } else if (point_in_rectangle(mouse_x, mouse_y, _stop_button_rect[0], _stop_button_rect[1], _stop_button_rect[2], _stop_button_rect[3])) {
            var _current_val = get_reset_note_value("stop", 0);
            set_reset_note_value("stop", 1 - _current_val);
        } else if (point_in_rectangle(mouse_x, mouse_y, _exit_button_rect[0], _exit_button_rect[1], _exit_button_rect[2], _exit_button_rect[3])) {
            is_reset_note_menu_open = false;
        }
    }
} else if (is_spin_effect_menu_open || spin_effect_menu_anim_progress > 0) {
    var _save_active_input = function() {
        if (active_input != noone) {
            if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                active_input.set_value(active_input_original_value);
            } else {
                var _val = real(input_buffer);
                if (is_real(_val)) active_input.set_value(_val);
            }
            active_input = noone;
            input_buffer = "";
        }
    };

    if (keyboard_check_pressed(vk_escape)) {
        _save_active_input();
        is_spin_effect_menu_open = false;
    }

    input_cursor_blink++;

    if (mouse_check_button_pressed(mb_left)) {
        var _clicked_on_field = false;
        var _ease_progress = ease_out_cubic(spin_effect_menu_anim_progress);
        var _scale = 0.8 + 0.2 * _ease_progress;
        var menu_w = 220 * _scale;
        var menu_h = 120 * _scale;
        var menu_x = room_width / 2;
        var menu_y = room_height / 2;
        var menu_x1 = menu_x - menu_w / 2;
        var menu_y1 = menu_y - menu_h / 2;
        var button_w = 50 * _scale;
        var button_h = 20 * _scale;
        var button_x = menu_x;
        var button_y = menu_y1 + menu_h + (15 * _scale);
        var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];

        if (point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3])) {
            _save_active_input();
            is_spin_effect_menu_open = false;
            _clicked_on_field = true;
        }

        var _field_names = variable_struct_get_names(spin_effect_menu_fields);
        for (var i = 0; i < array_length(_field_names); i++) {
            var _name = _field_names[i];
            var _field = spin_effect_menu_fields[$_name];
            var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
            if (point_in_rectangle(mouse_x, mouse_y, _rect[0], _rect[1], _rect[2], _rect[3])) {
                if (active_input != _field) {
                    _save_active_input();
                    active_input = _field;
                    active_input_original_value = _field.get_value();
                    input_buffer = string(active_input_original_value);
                    input_cursor_blink = 0;
                    keyboard_string = "";
                }
                _clicked_on_field = true;
                break;
            }
        }

        if (!_clicked_on_field) {
            _save_active_input();
        }
    }

    if (active_input != noone) {
        var _typed_string = keyboard_string;
        if (_typed_string != "") {
            var _filtered_string = "";
            for (var i = 1; i <= string_length(_typed_string); i++) {
                var _char = string_char_at(_typed_string, i);
                if (string_pos(_char, "0123456789.")) {
                    _filtered_string += _char;
                }
            }
            if (_filtered_string != "") {
                input_buffer += _filtered_string;
            }
            keyboard_string = "";
        }

        if (keyboard_check(vk_backspace)) {
            backspace_delay--;
            if (backspace_delay <= 0 && string_length(input_buffer) > 0) {
                input_buffer = string_copy(input_buffer, 1, string_length(input_buffer) - 1);
                if (keyboard_check_pressed(vk_backspace)) {
                    backspace_delay = 15;
                } else {
                    backspace_delay = 3;
                }
            }
        } else {
            backspace_delay = 0;
        }

        if (keyboard_check_pressed(vk_enter)) {
            _save_active_input();
        }
    } else {
        keyboard_string = "";
    }
} else if (is_shake_effect_menu_open || shake_effect_menu_anim_progress > 0) {
    var _save_active_input = function() {
        if (active_input != noone) {
            if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                active_input.set_value(active_input_original_value);
            } else {
                var _val = real(input_buffer);
                if (is_real(_val)) active_input.set_value(_val);
            }
            active_input = noone;
            input_buffer = "";
        }
    };

    if (keyboard_check_pressed(vk_escape)) {
        _save_active_input();
        is_shake_effect_menu_open = false;
    }

    input_cursor_blink++;

    if (mouse_check_button_pressed(mb_left)) {
        var _clicked_on_field = false;
        var _ease_progress = ease_out_cubic(shake_effect_menu_anim_progress);
        var _scale = 0.8 + 0.2 * _ease_progress;
        var menu_w = 220 * _scale;
        var menu_h = 120 * _scale;
        var menu_x = room_width / 2;
        var menu_y = room_height / 2;
        var menu_x1 = menu_x - menu_w / 2;
        var menu_y1 = menu_y - menu_h / 2;
        var button_w = 50 * _scale;
        var button_h = 20 * _scale;
        var button_x = menu_x;
        var button_y = menu_y1 + menu_h + (15 * _scale);
        var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];

        if (point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3])) {
            _save_active_input();
            is_shake_effect_menu_open = false;
            _clicked_on_field = true;
        }

        var _field_names = variable_struct_get_names(shake_effect_menu_fields);
        for (var i = 0; i < array_length(_field_names); i++) {
            var _name = _field_names[i];
            var _field = shake_effect_menu_fields[$_name];
            var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
            if (point_in_rectangle(mouse_x, mouse_y, _rect[0], _rect[1], _rect[2], _rect[3])) {
                if (active_input != _field) {
                    _save_active_input();
                    active_input = _field;
                    active_input_original_value = _field.get_value();
                    input_buffer = string(active_input_original_value);
                    input_cursor_blink = 0;
                    keyboard_string = "";
                }
                _clicked_on_field = true;
                break;
            }
        }

        if (!_clicked_on_field) {
            _save_active_input();
        }
    }

    if (active_input != noone) {
        var _typed_string = keyboard_string;
        if (_typed_string != "") {
            var _filtered_string = "";
            for (var i = 1; i <= string_length(_typed_string); i++) {
                var _char = string_char_at(_typed_string, i);
                if (string_pos(_char, "0123456789.")) {
                    _filtered_string += _char;
                }
            }
            if (_filtered_string != "") {
                input_buffer += _filtered_string;
            }
            keyboard_string = "";
        }

        if (keyboard_check(vk_backspace)) {
            backspace_delay--;
            if (backspace_delay <= 0 && string_length(input_buffer) > 0) {
                input_buffer = string_copy(input_buffer, 1, string_length(input_buffer) - 1);
                if (keyboard_check_pressed(vk_backspace)) {
                    backspace_delay = 15;
                } else {
                    backspace_delay = 3;
                }
            }
        } else {
            backspace_delay = 0;
        }

        if (keyboard_check_pressed(vk_enter)) {
            _save_active_input();
        }
    } else {
        keyboard_string = "";
    }
} else {
            var _mouse_on_ui = false;
            if (gui_anim_progress > 0.01 && point_in_rectangle(mouse_x, mouse_y, 0, input_fields.bpm.rect[1] - 20, 100, input_fields.pixels_per_second.rect[3] + 10)) {
                _mouse_on_ui = true;
            }
            if (point_in_rectangle(mouse_x, mouse_y, gui_arrow_current_x - 8, gui_arrow_current_y - 8, gui_arrow_current_x + 8, gui_arrow_current_y + 8)) {
                _mouse_on_ui = true;
            }
            var _arrow_x_right = lerp(room_width - 8, (room_width - 88) - 12, ease_out_cubic(song_list_anim_progress));
            if (point_in_rectangle(mouse_x, mouse_y, _arrow_x_right - 8, (room_height / 2) - 8, _arrow_x_right + 8, (room_height / 2) + 8)) {
                _mouse_on_ui = true;
            }
            if (song_list_anim_progress > 0.01 && mouse_x > room_width - 88) {
                _mouse_on_ui = true;
            }
            if (is_dragging_scrollbar) {
                _mouse_on_ui = true;
            }
        
            var _mouse_over_input = false;
        
            
            var _bpm_field = input_fields.bpm;
            var _bpm_rect = _bpm_field.rect;
            var _delay = _bpm_field.delay;

            var _max_delay = 0;
            var _field_names_for_delay = variable_struct_get_names(input_fields);
            for (var i = 0; i < array_length(_field_names_for_delay); i++) {
                _max_delay = max(_max_delay, input_fields[$_field_names_for_delay[i]].delay);
            }

            var _item_progress;
            if (gui_anim_target == 1) { 
                _item_progress = clamp((gui_anim_progress - _delay) / (1.0 - _delay), 0, 1);
            } else { 
                var _reverse_delay = _max_delay - _delay;
                var _hide_progress = 1.0 - gui_anim_progress;
                _item_progress = 1.0 - clamp((_hide_progress - _reverse_delay) / (1.0 - _reverse_delay), 0, 1);
            }
        
            var _ease_progress = ease_out_back(_item_progress);
            var _offscreen_x = -100;

            var _bpm_x1 = lerp(_offscreen_x, _bpm_rect[0], _ease_progress);
            var _bpm_y_center = (_bpm_rect[1] + _bpm_rect[3]) / 2;

            var _arrow_target_x = _bpm_x1 + (88 - 10); 
            gui_arrow_current_x = clamp(_arrow_target_x, 15, room_width - 15);
            gui_arrow_current_y = _bpm_y_center;
    
            
            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, gui_arrow_current_x - 8, gui_arrow_current_y - 8, gui_arrow_current_x + 8, gui_arrow_current_y + 8)) {
                gui_anim_target = 1 - gui_anim_target;
            
                if (gui_anim_target == 0 && active_input != noone) {
                    if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                        active_input.set_value(active_input_original_value);
                    } else {
                        var _val = real(input_buffer);
                        if (is_real(_val)) active_input.set_value(_val);
                    }
                    active_input = noone;
                    input_buffer = "";
                }
            }
        
            gui_anim_progress = lerp(gui_anim_progress, gui_anim_target, 0.15);
            if (abs(gui_anim_progress - gui_anim_target) < 0.01) {
                gui_anim_progress = gui_anim_target;
            }

            
            if (gui_anim_progress > 0.01) {
                input_cursor_blink++;
                if (input_fx_char_index != -1) {
                    input_fx_scale = lerp(input_fx_scale, 1, 0.25);
                    if (abs(input_fx_scale - 1) < 0.01) {
                        input_fx_char_index = -1;
                    }
                }
        
                var _field_names = variable_struct_get_names(input_fields);
                for (var i = 0; i < array_length(_field_names); i++) {
                    var _name = _field_names[i];
                    var _field = input_fields[$_name];
                    var _rect = _field.rect;
                    if (point_in_rectangle(mouse_x, mouse_y, _rect[0], _rect[1], _rect[2], _rect[3])) {
                        _mouse_over_input = true;
                        break;
                    }
                }

                if (mouse_check_button_pressed(mb_left)) {
                    var _clicked_on_field = false;
                    if (_mouse_over_input) {
                        for (var i = 0; i < array_length(_field_names); i++) {
                            var _name = _field_names[i];
                            var _field = input_fields[$_name];
                            var _rect = _field.rect;
                            if (point_in_rectangle(mouse_x, mouse_y, _rect[0], _rect[1], _rect[2], _rect[3])) {
                                if (active_input != _field) {
                                    if (active_input != noone) {
                                        if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                                            active_input.set_value(active_input_original_value);
                                        } else {
                                            var _val = real(input_buffer);
                                            if (is_real(_val)) active_input.set_value(_val);
                                        }
                                    }
                                    active_input = _field;
                                    active_input_original_value = _field.get_value();
                                    input_buffer = string(active_input_original_value);
                                    input_cursor_blink = 0;
                                    keyboard_string = ""; 
                                }
                                _clicked_on_field = true;
                                break;
                            }
                        }
                    }
                
                    if (!_clicked_on_field && active_input != noone) {
                        if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                            active_input.set_value(active_input_original_value);
                        } else {
                            var _val = real(input_buffer);
                            if (is_real(_val)) active_input.set_value(_val);
                        }
                        active_input = noone;
                        input_buffer = "";
                    }
                }

                if (active_input != noone) {
                    var _typed_string = keyboard_string;
                    if (_typed_string != "") {
                        var _filtered_string = "";
                        for (var i = 1; i <= string_length(_typed_string); i++) {
                            var _char = string_char_at(_typed_string, i);
                            if (_char == "-") {
                                if (string_length(input_buffer) == 0) {
                                    _filtered_string += _char;
                                }
                            } else if (_char == ".") {
                                if (string_pos(".", input_buffer) == 0) {
                                    _filtered_string += _char;
                                }
                            } else if (string_pos(_char, "0123456789")) {
                                _filtered_string += _char;
                            }
                        }
                        if (_filtered_string != "" && string_length(input_buffer) + string_length(_filtered_string) <= 15) {
                            input_buffer += _filtered_string;
                            input_fx_scale = 1.5;
                            input_fx_char_index = string_length(input_buffer);
                        }
                        keyboard_string = "";
                    }

                    if (keyboard_check(vk_backspace)) {
                        backspace_delay--;
                        if (backspace_delay <= 0 && string_length(input_buffer) > 0) {
                            input_buffer = string_copy(input_buffer, 1, string_length(input_buffer) - 1);
                            input_fx_scale = 1.5;
                            input_fx_char_index = string_length(input_buffer);
                            if (keyboard_check_pressed(vk_backspace)) {
                                backspace_delay = 15;
                            } else {
                                backspace_delay = 3;
                            }
                        }
                    } else {
                        backspace_delay = 0;
                    }
                
                    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape)) {
                        if (input_buffer == "" || input_buffer == "-" || input_buffer == ".") {
                            active_input.set_value(active_input_original_value);
                        } else {
                            var _val = real(input_buffer);
                            if (is_real(_val)) active_input.set_value(_val);
                        }
                        active_input = noone;
                        input_buffer = "";
                    }
                } else {
                    keyboard_string = "";
                }
            } else {
                if (active_input != noone) {
                    active_input = noone;
                    input_buffer = "";
                }
                keyboard_string = "";
            }
            
        
            
            song_list_anim_progress = lerp(song_list_anim_progress, song_list_anim_target, 0.15);
            var _panel_ease = ease_out_back(song_list_anim_progress);
            var _arrow_ease = ease_out_cubic(song_list_anim_progress);

            var _song_list_w = 88;
            var _song_list_start_x = room_width;
            var _song_list_end_x = room_width - _song_list_w;
            var _song_list_current_x = lerp(_song_list_start_x, _song_list_end_x, _panel_ease);
        
            var _arrow_start_x = room_width - 8;
            var _arrow_end_x = _song_list_end_x - 12;
            var _arrow_x = lerp(_arrow_start_x, _arrow_end_x, _arrow_ease);
            var _arrow_y = room_height / 2;

            if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, _arrow_x - 8, _arrow_y - 8, _arrow_x + 8, _arrow_y + 8)) {
                song_list_anim_target = 1 - song_list_anim_target;
            }

            if (song_list_anim_progress > 0.01) {
                var _total_song_list_height = array_length(song_list) * song_list_item_height;
                var _song_list_y_start = (room_height - song_list_view_height) / 2;
                var _scrollbar_track_x = _song_list_current_x; 
                var _scrollbar_handle_h = max(20, song_list_view_height * (song_list_view_height / _total_song_list_height));
                var _scroll_ratio = (_total_song_list_height > song_list_view_height) ? song_list_scroll_y / (_total_song_list_height - song_list_view_height) : 0;
                var _scrollbar_handle_y = _song_list_y_start + (song_list_view_height - _scrollbar_handle_h) * _scroll_ratio;

                
                if (!is_dragging_scrollbar) {
                    var _scroll_input = mouse_wheel_down() - mouse_wheel_up();
                    if (point_in_rectangle(mouse_x, mouse_y, _song_list_current_x, _song_list_y_start, room_width, _song_list_y_start + song_list_view_height)) {
                        if (_scroll_input != 0) {
                            song_list_target_scroll_y += _scroll_input * song_list_item_height * 2;
                        }
                    }
                }

                
                if (mouse_check_button_pressed(mb_left)) {
                    if (point_in_rectangle(mouse_x, mouse_y, _scrollbar_track_x, _scrollbar_handle_y, _scrollbar_track_x + 2, _scrollbar_handle_y + _scrollbar_handle_h)) {
                        is_dragging_scrollbar = true;
                        scrollbar_drag_start_y = mouse_y;
                        scrollbar_drag_start_scroll_y = song_list_target_scroll_y;
                    }
                }
            
                if (is_dragging_scrollbar) {
                    var _mouse_delta_y = mouse_y - scrollbar_drag_start_y;
                    var _scroll_delta = _mouse_delta_y * (_total_song_list_height / song_list_view_height);
                    song_list_target_scroll_y = scrollbar_drag_start_scroll_y + _scroll_delta;
                }

                if (mouse_check_button_released(mb_left)) {
                    is_dragging_scrollbar = false;
                }
            
                if (_total_song_list_height > song_list_view_height) {
                    song_list_target_scroll_y = clamp(song_list_target_scroll_y, 0, _total_song_list_height - song_list_view_height);
                } else {
                    song_list_target_scroll_y = 0;
                }
                song_list_scroll_y = lerp(song_list_scroll_y, song_list_target_scroll_y, 0.15);

                
                if (!is_dragging_scrollbar) {
                    for (var i = 0; i < array_length(song_list); i++) {
                        var _draw_y_on_screen = _song_list_y_start + (i * song_list_item_height) - song_list_scroll_y;
                        if (point_in_rectangle(mouse_x, mouse_y, _song_list_current_x + 4, _draw_y_on_screen - 6, room_width, _draw_y_on_screen + 6)) {
                            if (mouse_check_button_pressed(mb_left)) {
                                if (selected_song_index != i) {
                                    var _new_song = song_list[i];
                                    if (_new_song.asset_index != -1) {
                                        selected_song_index = i;
                                    
                                        audio_stop_sound(song_id);
                                        song_to_play = _new_song.asset_index;
                                        song_asset_name = _new_song.name;
                                        song_id = audio_play_sound(song_to_play, 1, false);
                                        audio_pause_sound(song_id);
                                        song_length = audio_sound_length(song_to_play);
                                    
                                        target_chart_position = 0;
                                        current_chart_position = 0;
                                        is_paused = true;
                                    }
                                }
                                break;
                            }
                        }
                    }
                }
            }
        
            if (keyboard_check_pressed(ord("T"))) {
                note_placement_type++;
                if (note_placement_type > ENotePlacementType.RESET) {
                    note_placement_type = ENotePlacementType.NORMAL;
                }
                linking_note_from_uid = -1; 
            }
        
            if (keyboard_check_pressed(vk_escape)) {
                linking_note_from_uid = -1;
            }
        
            if (keyboard_check_pressed(vk_shift)) {
                
                if (dragged_note_index != -1) {
                    var _notes_to_process = (drag_mode == "resize_single") ? [dragged_note_index] : selected_notes;
                    for (var i=0; i < array_length(original_drag_positions); i++) {
                        var _note_idx = _notes_to_process[i];
                        var _note = chart_data.notes[_note_idx];
                        var _original_pos = original_drag_positions[i];
                        _note.timestamp = _original_pos.timestamp;
                        _note.lane = _original_pos.lane;
                        if (_note.type == 1) _note.duration = _original_pos.duration;
                    }
                    dragged_note_index = -1;
                    drag_mode = "";
                }

                editor_view = (editor_view == EEditorView.NORMAL) ? EEditorView.EFFECTS : EEditorView.NORMAL;
                selected_notes = []; 
                hovered_note_index = -1; 
                
                hold_note_previews = [-1, -1, -1, -1];
            }
            
            if (keyboard_check(vk_control)) {
                if (keyboard_check_pressed(ord("Z"))) undo();
                if (keyboard_check_pressed(ord("Y"))) redo();
                if (keyboard_check_pressed(ord("C"))) {
                    if (is_array(selected_notes) && array_length(selected_notes) > 0) {
                        clipboard = [];
                        var _valid_notes_to_copy = [];

                        for (var i = 0; i < array_length(selected_notes); i++) {
                            var _note_index = selected_notes[i];
                            if (is_real(_note_index) && _note_index >= 0 && _note_index < array_length(chart_data.notes)) {
                                array_push(_valid_notes_to_copy, chart_data.notes[_note_index]);
                            }
                        }

                        if (array_length(_valid_notes_to_copy) > 0) {
                            var _first_note_time = _valid_notes_to_copy[0].timestamp;
                            for (var i = 1; i < array_length(_valid_notes_to_copy); i++) {
                                if (_valid_notes_to_copy[i].timestamp < _first_note_time) {
                                    _first_note_time = _valid_notes_to_copy[i].timestamp;
                                }
                            }

                            for (var i = 0; i < array_length(_valid_notes_to_copy); i++) {
                                var _note_to_copy = _valid_notes_to_copy[i];
                                var _note_copy_struct = json_parse(json_stringify(_note_to_copy));
                                _note_copy_struct.timestamp -= _first_note_time;
                                array_push(clipboard, _note_copy_struct);
                            }
                        }
                    }
                }
                if (keyboard_check_pressed(ord("V"))) {
                    if (array_length(clipboard) > 0) {
                        var _can_paste = true;
                        var _new_notes = [];
                        var _old_to_new_uid_map = ds_map_create();
                    
                        for (var i = 0; i < array_length(clipboard); i++) {
                            var _clipboard_note = clipboard[i];
                            var _paste_time = target_chart_position + _clipboard_note.timestamp;
                            var _end_time = _paste_time + ((_clipboard_note.type == 1) ? _clipboard_note.duration : 0.001);
                        
                            if (check_collision(_clipboard_note.lane, _paste_time, _end_time, [], _clipboard_note.type)) {
                                _can_paste = false;
                                break;
                            }
                        
                            var _new_note = json_parse(json_stringify(_clipboard_note));
                            _new_note.timestamp = _paste_time;
                        
                            var _old_uid = _new_note.uid;
                            var _new_uid = note_uid_counter++;
                            _new_note.uid = _new_uid;
                            ds_map_add(_old_to_new_uid_map, _old_uid, _new_uid);
                        
                            array_push(_new_notes, _new_note);
                        }
                    
                        if (!_can_paste) {
                            ds_map_destroy(_old_to_new_uid_map);
                        } else {
                            for (var i = 0; i < array_length(_new_notes); i++) {
                                var _note = _new_notes[i];
                                if (variable_struct_exists(_note, "next_repel_note_uid") && _note.next_repel_note_uid != -1) {
                                    if (ds_map_exists(_old_to_new_uid_map, _note.next_repel_note_uid)) {
                                        _note.next_repel_note_uid = _old_to_new_uid_map[? _note.next_repel_note_uid];
                                    } else {
                                        _note.next_repel_note_uid = -1;
                                    }
                                }
                            }
                        
                            for (var i = 0; i < array_length(_new_notes); i++) {
                                array_push(chart_data.notes, _new_notes[i]);
                            }
                        
                            ds_map_destroy(_old_to_new_uid_map);
                            sort_chart();
                            commit_action();
                            selected_notes = [];
                        }
                    }
                }
                if (keyboard_check_pressed(ord("H"))) {
                    if (is_array(selected_notes) && array_length(selected_notes) > 0) {
                        var _can_flip = true;
                        var _total_lanes = array_length(lanes);

                        for (var i = 0; i < array_length(selected_notes); i++) {
                            var _note_index = selected_notes[i];
                            if (!is_real(_note_index) || _note_index < 0 || _note_index >= array_length(chart_data.notes)) continue;

                            var _note = chart_data.notes[_note_index];
                            var _new_lane = (_total_lanes - 1) - _note.lane;
                            var _end_time = _note.timestamp + ((_note.type == 1) ? _note.duration : 0.001);

                            if (check_collision(_new_lane, _note.timestamp, _end_time, selected_notes, _note.type)) {
                                _can_flip = false;
                                break;
                            }
                        }

                        if (_can_flip) {
                            for (var i = 0; i < array_length(selected_notes); i++) {
                                var _note_index = selected_notes[i];
                                if (!is_real(_note_index) || _note_index < 0 || _note_index >= array_length(chart_data.notes)) continue;

                                var _note = chart_data.notes[_note_index];
                                _note.lane = (_total_lanes - 1) - _note.lane;
                            }
                            commit_action();
                        }
                    }
                }
            }

            if (!is_paused) {
                current_chart_position += (1 / room_speed);
                target_chart_position = current_chart_position;
            } else {
                current_chart_position = lerp(current_chart_position, target_chart_position, 0.25);
            }
        
            if (last_chart_position != current_chart_position) {
                if (!is_paused) {
                    var _played_timestamps = ds_map_create();
                    var _notes_array = chart_data.notes;
                    for (var i = 0; i < array_length(_notes_array); i++) {
                        var _note = _notes_array[i];
                        var _note_time = _note.timestamp;

                        if ((_note_time > last_chart_position && _note_time <= current_chart_position) ||
                            (_note_time < last_chart_position && _note_time >= current_chart_position)) {
                            if (!ds_map_exists(_played_timestamps, _note_time)) {
								var _is_note_in_current_view = (editor_view == EEditorView.NORMAL && _note.type < 3) || (editor_view == EEditorView.EFFECTS && _note.type >= 3);
								if (_is_note_in_current_view) {
									audio_play_sound(SndNoteHit, 1, false, 3);
									audio_sound_gain(song_id, main_volume * 0.5, 0); 
									alarm[0] = 5; 
									ds_map_add(_played_timestamps, _note_time, true);
								}
                            }
                        }
                    }
                    ds_map_destroy(_played_timestamps);
                }
            }
            last_chart_position = current_chart_position;
        
            var _notes_array = chart_data.notes;
            for (var i = 0; i < array_length(_notes_array); i++) {
                var _note = _notes_array[i];
                _note.visual_timestamp = lerp(_note.visual_timestamp, _note.timestamp, 0.25);
                if (variable_struct_exists(_note, "visual_x")) {
                    _note.visual_x = lerp(_note.visual_x, lanes[_note.lane].current_x, 0.25);
                } else {
                    _note.visual_x = lanes[_note.lane].current_x;
                }
            }
            for (var i = 0; i < array_length(lanes); i++) {
                lanes[i].highlight_alpha = max(0, lanes[i].highlight_alpha - 0.05);
            }
        
            var _is_dragging_anything = (dragged_note_index != -1 || is_dragging_timeline || is_box_selecting);
            hovered_note_index = -1;
            hovered_part = "";
        
            if (!_is_dragging_anything && !_mouse_on_ui) {
                for (var i = array_length(_notes_array) - 1; i >= 0; i--) {
                    var _note = _notes_array[i];
                    
                    if (editor_view == EEditorView.NORMAL && _note.type >= 3) continue;
                    if (editor_view == EEditorView.EFFECTS && _note.type < 3) continue;
                    
                    var _draw_x = _note.visual_x;
                    var _start_y = get_playhead_y() + (_note.visual_timestamp - current_chart_position) * pixels_per_second;
                    var _note_half_w = 17 / 2;
                    var _note_half_h = 17 / 2;
                
                    if (point_in_rectangle(mouse_x, mouse_y, _draw_x - _note_half_w, _start_y - _note_half_h, _draw_x + _note_half_w, _start_y + _note_half_h)) {
                        hovered_note_index = i; hovered_part = "head"; break;
                    }
                    if (_note.type == 1) {
                        var _end_y = _start_y + _note.duration * pixels_per_second;
                        var _tail_hitbox_height = 8;
                        var _note_visual_bottom = _end_y + _note_half_h;
                        if (point_in_rectangle(mouse_x, mouse_y, _draw_x - _note_half_w, _note_visual_bottom - _tail_hitbox_height, _draw_x + _note_half_w, _note_visual_bottom)) {
                           hovered_note_index = i; hovered_part = "tail"; break;
                        }
                        if (point_in_rectangle(mouse_x, mouse_y, _draw_x - _note_half_w, _start_y + _note_half_h, _draw_x + _note_half_w, _note_visual_bottom - _tail_hitbox_height)) {
                            hovered_note_index = i; hovered_part = "body"; break;
                        }
                    }
                }
            }
        
            if (mouse_check_button_pressed(mb_right) && hovered_note_index != -1 && !_mouse_on_ui) {
                var _note = _notes_array[hovered_note_index];
                var _is_note_in_current_view = (editor_view == EEditorView.NORMAL && _note.type < 3) || (editor_view == EEditorView.EFFECTS && _note.type >= 3);
                
                if (_is_note_in_current_view) {
                    if (_note.type == 2 && variable_struct_exists(_note, "next_repel_note_uid") && _note.next_repel_note_uid != -1) {
                        _note.next_repel_note_uid = -1;
                        commit_action();
                    } else {
                        
                        if (variable_struct_exists(_note, "uid")) {
                            var _deleted_uid = _note.uid;
                            for (var j = 0; j < array_length(_notes_array); j++) {
                                var _other_note = _notes_array[j];
                                if (variable_struct_exists(_other_note, "next_repel_note_uid") && _other_note.next_repel_note_uid == _deleted_uid) {
                                    _other_note.next_repel_note_uid = -1;
                                }
                            }
                        }
            
                        if (array_contains(selected_notes, hovered_note_index)) {
                            array_sort(selected_notes, function(a, b) { return b - a; });
                            for (var i = 0; i < array_length(selected_notes); i++) {
                                array_delete(_notes_array, selected_notes[i], 1);
                            }
                        } else {
                            array_delete(_notes_array, hovered_note_index, 1);
                        }
                        selected_notes = [];
                        commit_action();
                        hovered_note_index = -1;
                    }
                }
            }
        
            if (keyboard_check_pressed(vk_backspace)) {
                if (is_array(selected_notes) && array_length(selected_notes) > 0) {
                    
                    var _notes_to_delete_indices = [];
                    for (var i = 0; i < array_length(selected_notes); i++) {
                        var _note_index = selected_notes[i];
                        if (_note_index >= 0 && _note_index < array_length(_notes_array)) {
                            var _note = _notes_array[_note_index];
                            var _is_note_in_current_view = (editor_view == EEditorView.NORMAL && _note.type < 3) || (editor_view == EEditorView.EFFECTS && _note.type >= 3);
                            if (_is_note_in_current_view) {
                                array_push(_notes_to_delete_indices, _note_index);
                            }
                        }
                    }

                    if (array_length(_notes_to_delete_indices) > 0) {
                        
                        var _uids_to_delete = ds_list_create();
                        for (var i = 0; i < array_length(_notes_to_delete_indices); i++) {
                            var _note_index = _notes_to_delete_indices[i];
                            var _note = _notes_array[_note_index];
                            if (variable_struct_exists(_note, "uid")) {
                                ds_list_add(_uids_to_delete, _note.uid);
                            }
                        }
                        for (var i = 0; i < array_length(_notes_array); i++) {
                            var _note = _notes_array[i];
                            if (variable_struct_exists(_note, "next_repel_note_uid") && ds_list_find_index(_uids_to_delete, _note.next_repel_note_uid) != -1) {
                                _note.next_repel_note_uid = -1;
                            }
                        }
                        ds_list_destroy(_uids_to_delete);

                        
                        array_sort(_notes_to_delete_indices, function(a, b) { return b - a; });
                        for (var i = 0; i < array_length(_notes_to_delete_indices); i++) {
                            array_delete(_notes_array, _notes_to_delete_indices[i], 1);
                        }
                        
                        commit_action();
                    }
                    selected_notes = [];
                }
            }
        
            if (mouse_check_button_pressed(mb_left) && !_mouse_on_ui) {
                if (hovered_note_index != -1) {
                    var _note = _notes_array[hovered_note_index];
                    var _is_note_in_current_view = (editor_view == EEditorView.NORMAL && _note.type < 3) || (editor_view == EEditorView.EFFECTS && _note.type >= 3);

                    if (_is_note_in_current_view) {
                        var _alt_pressed = keyboard_check(vk_alt);

                        if (linking_note_from_uid != -1 && _note.type == 2) {
                            var _from_note_index = get_note_index_by_uid(linking_note_from_uid);
                            if (_from_note_index != -1) {
                                var _from_note = _notes_array[_from_note_index];
                                if (linking_note_from_uid != _note.uid && _note.timestamp > _from_note.timestamp && _note.lane == _from_note.lane && variable_struct_exists(_from_note, "next_repel_note_uid") && _from_note.next_repel_note_uid == -1) {
                                    _from_note.next_repel_note_uid = _note.uid;
                                    commit_action();
                                }
                            }
                            linking_note_from_uid = -1;
                        } else if (_alt_pressed) {
                            
                            if (_note.type == 2) {
                                linking_note_from_uid = _note.uid;
                            }
                            
                            else if (_note.type == 3 && editor_view == EEditorView.EFFECTS) {
                                is_move_note_menu_open = true;
                                move_note_menu_target_note_index = hovered_note_index;
                            }
                            
                            else if (_note.type == 4 && editor_view == EEditorView.EFFECTS) {
    is_scale_note_menu_open = true;
    scale_note_menu_target_note_index = hovered_note_index;
}
else if (_note.type == 5 && editor_view == EEditorView.EFFECTS) {
    is_script_note_menu_open = true;
    script_note_menu_target_note_index = hovered_note_index;
}
else if (_note.type == 6 && editor_view == EEditorView.EFFECTS) {
	is_reset_note_menu_open = true;
    reset_note_menu_target_note_index = hovered_note_index;
}
                        } else {
                            
                            linking_note_from_uid = -1;
                            var _can_drag = true;
                            if (_note.type == 2) {
                                if (!is_note_unlinked(hovered_note_index) && !is_repel_chain_fully_selected(hovered_note_index)) {
                                    _can_drag = false;
                                }
                            }
                            
                            if (_can_drag) {
                                dragged_note_index = hovered_note_index;
                                dragged_part = hovered_part;

                                if (_note.type == 1 && (dragged_part == "tail")) {
                                    drag_mode = "resize_single";
                                    original_drag_positions = [{ timestamp: _note.timestamp, lane: _note.lane, duration: _note.duration }];
                                } else {
                                    if (!array_contains(selected_notes, dragged_note_index)) {
                                        if (!keyboard_check(vk_shift)) {
                                            selected_notes = [];
                                        }
                                        array_push(selected_notes, dragged_note_index);
                                    }
                                    drag_mode = (array_length(selected_notes) > 1) ? "move_group" : "move_single";
                                
                                    original_drag_positions = [];
                                    for (var i=0; i < array_length(selected_notes); i++) {
                                        var _note_to_store = _notes_array[selected_notes[i]];
                                        array_push(original_drag_positions, {
                                            timestamp: _note_to_store.timestamp,
                                            lane: _note_to_store.lane,
                                            duration: (_note_to_store.type == 1) ? _note_to_store.duration : 0
                                        });
                                    }
                                }
                                drag_start_mouse_time = target_chart_position + ((mouse_y - get_playhead_y()) / pixels_per_second);
                                drag_start_mouse_lane = get_lane_at_x(mouse_x);
                            }
                        }
                    }
                } else {
                    var _mouse_over_scrubber = point_in_rectangle(mouse_x, mouse_y, scrubber_x - 5, scrubber_handle_y, scrubber_x + 5, scrubber_handle_y + scrubber_handle_height);
                    if (!_mouse_over_scrubber) {
                        linking_note_from_uid = -1;
                        is_box_selecting = true;
                        box_select_x1 = mouse_x;
                        box_select_y1 = mouse_y;
                        box_select_y1_chart = current_chart_position + ((mouse_y - get_playhead_y()) / pixels_per_second);
                        selected_notes = [];
                    }
                }
            }
        
            if (dragged_note_index != -1) {
                if (!is_paused) { is_paused = true; audio_pause_sound(song_id); }
                var _mouse_time = current_chart_position + ((mouse_y - get_playhead_y()) / pixels_per_second);

                switch(drag_mode) {
                    case "move_group":
                    case "move_single":
                        var min_lane_in_selection = 99;
                        var max_lane_in_selection = -1;
                        for (var i = 0; i < array_length(original_drag_positions); i++) {
                            var original_pos = original_drag_positions[i];
                            min_lane_in_selection = min(min_lane_in_selection, original_pos.lane);
                            max_lane_in_selection = max(max_lane_in_selection, original_pos.lane);
                        }
                    
                        var _current_mouse_lane = get_lane_at_x(mouse_x);
                        var _delta_time = _mouse_time - drag_start_mouse_time;
                        var _delta_lane = _current_mouse_lane - drag_start_mouse_lane;
                    
                        var max_delta_left = -min_lane_in_selection;
                        var max_delta_right = (array_length(lanes) - 1) - max_lane_in_selection;
                        var clamped_delta_lane = clamp(_delta_lane, max_delta_left, max_delta_right);
                    
                        for (var i=0; i < array_length(selected_notes); i++) {
                            var _note = _notes_array[selected_notes[i]];
                            var _original_pos = original_drag_positions[i];
                            _note.timestamp = _original_pos.timestamp + _delta_time;
                            _note.lane = _original_pos.lane + clamped_delta_lane;
                        }
                        break;
            
                    case "resize_single":
                        var _note = _notes_array[dragged_note_index];
                        var _min_duration = sec_per_beat / 8;
                        var _new_end_time = max(_note.timestamp + _min_duration, _mouse_time);
                        _note.duration = _new_end_time - _note.timestamp;
                        break;
                }
            }
        
            if (mouse_check_button_released(mb_left)) {
                if (is_box_selecting) {
                    is_box_selecting = false;
                    var _sel_x1 = min(box_select_x1, mouse_x);
                    var _sel_x2 = max(box_select_x1, mouse_x);
                    var _mouse_y_chart = current_chart_position + ((mouse_y - get_playhead_y()) / pixels_per_second);
                    var _sel_y1_chart = min(box_select_y1_chart, _mouse_y_chart);
                    var _sel_y2_chart = max(box_select_y1_chart, _mouse_y_chart);

                    selected_notes = [];
                    for (var i = 0; i < array_length(_notes_array); i++) {
                        var _note = _notes_array[i];
                        
                        
                        var _is_note_in_current_view = (editor_view == EEditorView.NORMAL && _note.type < 3) || (editor_view == EEditorView.EFFECTS && _note.type >= 3);
                        if (!_is_note_in_current_view) continue;

                        var _note_half_w = 17 / 2;
                        var _note_x1 = _note.visual_x - _note_half_w;
                        var _note_x2 = _note.visual_x + _note_half_w;
                        var _note_y1_chart = _note.visual_timestamp;
                        var _note_y2_chart = _note_y1_chart;
                        if (_note.type == 1) {
                            _note_y2_chart += _note.duration;
                        }

                        if (!(_note_x2 < _sel_x1 || _note_x1 > _sel_x2 || _note_y2_chart < _sel_y1_chart || _note_y1_chart > _sel_y2_chart)) {
                            array_push(selected_notes, i);
                        }
                    }
                }
            
                if (dragged_note_index != -1) {
                    var _had_collision = false;
                    var _notes_to_process = (drag_mode == "resize_single") ? [dragged_note_index] : selected_notes;

                    for (var i = 0; i < array_length(_notes_to_process); i++) {
                        var _note_index = _notes_to_process[i];
                        var _note = _notes_array[_note_index];
                    
                        
                        var _start_beat = round(_note.timestamp * snap_division / sec_per_beat) / snap_division;
                        _note.timestamp = _start_beat * sec_per_beat;
                    
                        if (_note.timestamp < 0) {
                            _had_collision = true;
                            break;
                        }

                        if (_note.type == 1) { 
                            var _end_beat = round((_note.timestamp + _note.duration) * snap_division / sec_per_beat) / snap_division;
                            _note.duration = max(sec_per_beat / snap_division, (_end_beat * sec_per_beat) - _note.timestamp);
                            var _end_time = _note.timestamp + _note.duration;
                            if (check_collision(_note.lane, _note.timestamp, _end_time, _notes_to_process, _note.type)) {
                                _had_collision = true;
                                break;
                            }
                        } else { 
                            if (check_exact_collision(_note.lane, _note.timestamp, _notes_to_process, _note.type)) {
                                _had_collision = true;
                                break;
                            }
                        }
                    }
                
                    if (_had_collision) {
                        for (var i=0; i < array_length(original_drag_positions); i++) {
                            var _note_idx = _notes_to_process[i];
                            var _note = _notes_array[_note_idx];
                            var _original_pos = original_drag_positions[i];
                            _note.timestamp = _original_pos.timestamp;
                            _note.lane = _original_pos.lane;
                            if (_note.type == 1) _note.duration = _original_pos.duration;
                        }
                    } else {
                        sort_chart();
                        commit_action();
                    }
                
                    selected_notes = [];
                    dragged_note_index = -1;
                    drag_mode = "";
                }
                if (is_dragging_timeline) is_dragging_timeline = false;
            }

            if (dragged_note_index == -1 && !is_box_selecting && active_input == noone && !_mouse_on_ui) {
                for (var i = 0; i < array_length(lanes); i++) {
                    var _key = lanes[i].key;
                    if (keyboard_check_pressed(_key)) {
                        lanes[i].highlight_alpha = 1;
                        if (hold_note_previews[i] == -1) {
                            hold_note_previews[i] = { start_time: target_chart_position, duration: 0, real_time_start: get_timer() };
                        }
                    }
                    if (keyboard_check(_key)) {
                        if (hold_note_previews[i] != -1) {
                            hold_note_previews[i].duration = max(0, target_chart_position - hold_note_previews[i].start_time);
                        }
                    }
                    if (keyboard_check_released(_key)) {
                        if (hold_note_previews[i] != -1) {
                            var _preview = hold_note_previews[i];
                            var _held_duration_s = (get_timer() - _preview.real_time_start) / 1000000.0;
                            var _final_duration = _preview.duration;
                            if (_held_duration_s < 0.15) _final_duration = 0;
                        
                            selected_notes = [];
                        
                            var _new_note = create_note_struct(i, _preview.start_time, _preview.start_time + _final_duration, false); 
                            if (_new_note != undefined) {
                                array_push(chart_data.notes, _new_note);
                                sort_chart();
                                commit_action();
                            }
                            hold_note_previews[i] = -1;
                        }
                    }
                }
            }
        
            if (keyboard_check_pressed(vk_space)) {
                is_paused = !is_paused;
                if (is_paused) { 
                    audio_pause_sound(song_id); 
                } else { 
					current_chart_position = target_chart_position; 
                    audio_sound_set_track_position(song_id, target_chart_position - audio_offset); 
                    audio_resume_sound(song_id);
                
                    var _notes_array = chart_data.notes;
                    for (var i = 0; i < array_length(_notes_array); i++) {
                        var _note = _notes_array[i];
                        if (_note.timestamp == target_chart_position) {
							var _is_note_in_current_view = (editor_view == EEditorView.NORMAL && _note.type < 3) || (editor_view == EEditorView.EFFECTS && _note.type >= 3);
							if (_is_note_in_current_view) {
								audio_play_sound(SndNoteHit, 1, false, 3);
								audio_sound_gain(song_id, main_volume * 0.5, 0);
								alarm[0] = 5;
							}
                        }
                    }
                }
            }
        
            var _scroll_input = mouse_wheel_down() - mouse_wheel_up();
            if (_scroll_input != 0 && !is_dragging_timeline && active_input == noone) {
                if (!is_paused) { is_paused = true; audio_pause_sound(song_id); }
                var _current_beat = target_chart_position / sec_per_beat;
                var _current_snap_index = round(_current_beat * snap_division);
                var _next_snap_index = _current_snap_index + _scroll_input;
                var _new_beat = _next_snap_index / snap_division;
                target_chart_position = _new_beat * sec_per_beat;
                target_chart_position = clamp(target_chart_position, 0, song_length);
            }
        
            if (active_input == noone) {
                if (keyboard_check_pressed(ord("1"))) snap_division = 4; 
                if (keyboard_check_pressed(ord("2"))) snap_division = 8;
                if (keyboard_check_pressed(ord("3"))) snap_division = 12; 
                if (keyboard_check_pressed(ord("4"))) snap_division = 16;
                if (keyboard_check_pressed(vk_f5)) prompt_and_save_chart(); 
                if (keyboard_check_pressed(vk_f6)) prompt_and_load_chart();
                if (keyboard_check_pressed(vk_f7)) {
                    var _new_repel_offset = get_string("Enter new Repel Offset (ms):", string(repel_offset * 1000));
                    var _new_repel_offset_val = real(_new_repel_offset);
                    if (is_real(_new_repel_offset_val)) {
                        repel_offset = _new_repel_offset_val / 1000.0;
                    }
                }
            }
        }
    break;
        
    case EEditorMode.TEST:
        
        for (var i = 0; i < array_length(lanes); i++) {
            var _lane = lanes[i];
            var _total_x_offset = 0;
            var _total_y_offset = 0;

            
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

		
		for (var i = 0; i < array_length(_notes_array_test); i++) {
		    var _note = _notes_array_test[i];
		    if ((_note.type == 3 || _note.type == 4 || _note.type == 5 || _note.type == 6) && _note.hit_state == ENoteState.WAITING && current_chart_position >= _note.timestamp) {
		        _note.hit_state = ENoteState.HIT;
		        
		        if (_note.type == 3) {
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

        if (!is_counting_down)
		{
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
    break;
}