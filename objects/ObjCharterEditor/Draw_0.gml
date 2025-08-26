




draw_set_font(fn1);


switch (editor_mode) {
    
    
    
    
    case EEditorMode.EDIT:
        var _c_background = UI_COLOR_BACKGROUND;
        var _c_lane_dark = UI_COLOR_LANE_DARK;
        var _c_lane_light = UI_COLOR_LANE_LIGHT;
        var _c_beat_line = UI_COLOR_BEAT_LINE;
        var _c_sub_beat_line = UI_COLOR_SUB_BEAT_LINE;
        var _c_sub_beat_line = UI_COLOR_SUB_BEAT_LINE;
        var _c_playhead = UI_COLOR_PLAYHEAD;
        var _c_text = UI_COLOR_TEXT;
        var _c_text_dim = UI_COLOR_TEXT_DIM;
        var _c_highlight = UI_COLOR_HIGHLIGHT;
        var _c_panel_bg = UI_COLOR_PANEL_BG;
        var _c_selection = UI_COLOR_SELECTION;
        var _c_repel = UI_COLOR_REPEL;
        var _c_move = UI_COLOR_MOVE;
        if (editor_view == EEditorView.NORMAL) {
            draw_set_color(_c_background);
            draw_rectangle(0, 0, room_width, room_height, false);
            var _lane_width = UI_LANE_WIDTH;
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
            var _lanes_start_x = lanes[0].current_x - (_lane_width / 2);
            var _lanes_end_x = lanes[array_length(lanes) - 1].current_x + (_lane_width / 2);
            var _playhead_y = get_playhead_y();
            var _start_beat = floor((current_chart_position / sec_per_beat) - (_playhead_y / (pixels_per_second * sec_per_beat)));
            var _end_beat = ceil((current_chart_position / sec_per_beat) + ((room_height - _playhead_y) / (pixels_per_second * sec_per_beat)));
            for (var b = _start_beat; b <= _end_beat; b += 1 / snap_division) {
                if (b < 0) continue;
                var _beat_time = b * sec_per_beat;
                var _draw_y = _playhead_y + (_beat_time - current_chart_position) * pixels_per_second;
                if (b == floor(b)) { draw_set_color(_c_beat_line); }
                else { draw_set_color(_c_sub_beat_line); }
                draw_line(_lanes_start_x, _draw_y, _lanes_end_x, _draw_y);
            }
        
            for (var i = 0; i < array_length(hold_note_previews); i++) {
                var _preview = hold_note_previews[i];
                if (is_struct(_preview)) {
                    var _lane_data = lanes[i];
                    var _draw_x = _lane_data.current_x;
                    var _start_y = _playhead_y + (_preview.start_time - current_chart_position) * pixels_per_second;
                    var _end_y = _start_y + (_preview.duration * pixels_per_second);
                    var _preview_color = c_white;
                    if (note_placement_type == ENotePlacementType.REPEL) _preview_color = _c_repel;
                    if (note_placement_type == ENotePlacementType.MOVE) _preview_color = _c_move;
if (note_placement_type == ENotePlacementType.SCALE) _preview_color = UI_COLOR_SCALE;
if (note_placement_type == ENotePlacementType.SCRIPT) _preview_color = UI_COLOR_SCRIPT;
                    var _preview_alpha = 0.5;
                    var _body_height_px = _end_y - _start_y;
                    if (_body_height_px > 0) {
                        var _tex = sprite_get_texture(SprNoteHold, _lane_data.hold_body_index);
                        var _uvs = sprite_get_uvs(SprNoteHold, _lane_data.hold_body_index);
                        var _w = 17;
                        draw_primitive_begin_texture(pr_trianglestrip, _tex);
                        draw_vertex_texture_color(_draw_x + 0.5 - _w/2, _start_y, _uvs[0], _uvs[1], _preview_color, _preview_alpha);
                        draw_vertex_texture_color(_draw_x + 0.5 + _w/2, _start_y, _uvs[2], _uvs[1], _preview_color, _preview_alpha);
                        draw_vertex_texture_color(_draw_x + 0.5 - _w/2, _end_y,   _uvs[0], _uvs[3], _preview_color, _preview_alpha);
                        draw_vertex_texture_color(_draw_x + 0.5 + _w/2, _end_y,   _uvs[2], _uvs[3], _preview_color, _preview_alpha);
                        draw_primitive_end();
                    }
                    draw_sprite_ext(SprNoteHold, _lane_data.hold_tail_index, _draw_x, _end_y, 1, 1, 0, _preview_color, _preview_alpha);
                    draw_sprite_ext(SprNote, _lane_data.sprite_index, _draw_x, _start_y, 1, 1, 0, _preview_color, _preview_alpha);
                }
            }
        
            var _notes_array = chart_data.notes;
        
            
            for (var i = 0; i < array_length(_notes_array); i++) {
                var _note = _notes_array[i];
                if (_note.type == 2 && variable_struct_exists(_note, "next_repel_note_uid") && _note.next_repel_note_uid != -1) {
                    var _next_note_index = get_note_index_by_uid(_note.next_repel_note_uid);
                    if (_next_note_index != -1) {
                        var _next_note = _notes_array[_next_note_index];
                        var _start_x = _note.visual_x;
                        var _start_y = _playhead_y + (_note.visual_timestamp - current_chart_position) * pixels_per_second;
                        var _end_x = _next_note.visual_x;
                        var _end_y = _playhead_y + (_next_note.visual_timestamp - current_chart_position) * pixels_per_second;
                        draw_set_color(_c_repel);
                        draw_set_alpha(0.6);
                        draw_line_width_color(_start_x, _start_y, _end_x, _end_y, 2, _c_repel, c_white);
                        draw_set_alpha(1);
                    }
                }
            }
            if (linking_note_from_uid != -1) {
                var _from_note_index = get_note_index_by_uid(linking_note_from_uid);
                if (_from_note_index != -1) {
                    var _from_note = _notes_array[_from_note_index];
                    var _start_x = _from_note.visual_x;
                    var _start_y = _playhead_y + (_from_note.visual_timestamp - current_chart_position) * pixels_per_second;
                    draw_set_color(c_white);
                    draw_line_width(_start_x, _start_y, mouse_x, mouse_y, 2);
                }
            }
        
            for (var i = 0; i < array_length(_notes_array); i++) {
                var _note = _notes_array[i];
                if (_note.type == 3) continue;
                var _lane_data = lanes[_note.lane];
                var _draw_x = _note.visual_x;
                var _start_y = _playhead_y + (_note.visual_timestamp - current_chart_position) * pixels_per_second;
            
                var _note_color = c_white;
                if (_note.type == 2) _note_color = _c_repel;
                if (_note.type == 3) _note_color = _c_move;
if (_note.type == 4) _note_color = UI_COLOR_SCALE;
if (_note.type == 5) _note_color = UI_COLOR_SCRIPT;
if (_note.type == 6) _note_color = UI_COLOR_RESET;
                if (array_contains(selected_notes, i)) _note_color = _c_selection;
                if (variable_struct_exists(_note, "uid") && _note.uid == linking_note_from_uid) _note_color = c_lime;
                if (variable_struct_exists(_note, "uid") && _note.uid == linking_note_from_uid) _note_color = c_lime;
            
                if (_note.type == 0 || _note.type == 2 || _note.type == 3) {
                    var _draw_scale = (i == hovered_note_index || array_contains(selected_notes, i)) ? 1.2 : 1.0;
                    if (_start_y > -20 && _start_y < room_height + 20) {
                        draw_sprite_ext(SprNote, _lane_data.sprite_index, _draw_x, _start_y, _draw_scale, _draw_scale, 0, _note_color, 1);
                    }
                } 
                else if (_note.type == 1) { 
                    var _end_y = _start_y + _note.duration * pixels_per_second;
                    if (_end_y > -20 && _start_y < room_height + 20) {
                        var _is_hovered = (i == hovered_note_index);
                        var _is_selected = array_contains(selected_notes, i);
                        var _is_dragged = (i == dragged_note_index);
                        var _head_scale = (_is_hovered && hovered_part == "head") || (_is_dragged && dragged_part == "head") || _is_selected ? 1.2 : 1.0;
                        var _body_color = _note_color;
                        var _head_color = _note_color;
                        if (_is_dragged && dragged_part == "head") _head_color = _c_highlight;
                    
                        var _body_height_px = _end_y - _start_y;
                        if (_body_height_px > 0) {
                            var _tex = sprite_get_texture(SprNoteHold, _lane_data.hold_body_index);
                            var _uvs = sprite_get_uvs(SprNoteHold, _lane_data.hold_body_index);
                            var _w = 17;
                            draw_primitive_begin_texture(pr_trianglestrip, _tex);
                            draw_vertex_texture_color(_draw_x + 0.5 - _w/2, _start_y, _uvs[0], _uvs[1], _body_color, 1);
                            draw_vertex_texture_color(_draw_x + 0.5 + _w/2, _start_y, _uvs[2], _uvs[1], _body_color, 1);
                            draw_vertex_texture_color(_draw_x + 0.5 - _w/2, _end_y,   _uvs[0], _uvs[3], _body_color, 1);
                            draw_vertex_texture_color(_draw_x + 0.5 + _w/2, _end_y,   _uvs[2], _uvs[3], _body_color, 1);
                            draw_primitive_end();
                        }
                    
                        var is_tail_active = (_is_hovered && hovered_part == "tail") || (_is_dragged && dragged_part == "tail");
                        draw_sprite_ext(SprNoteHold, _lane_data.hold_tail_index, _draw_x, _end_y, 1, 1, 0, is_tail_active ? _c_highlight : _body_color, 1);
                        draw_sprite_ext(SprNote, _lane_data.sprite_index, _draw_x, _start_y, _head_scale, _head_scale, 0, _head_color, 1);
                    }
                }
            }
        } else { 
            
            
            
            
            draw_set_color(_c_background);
            draw_rectangle(0, 0, room_width, room_height, false);
            var _lane_width = UI_LANE_WIDTH;
            for (var i = 0; i < array_length(lanes); i++) {
                var _lane = lanes[i];
                var _lane_x1 = _lane.current_x - (_lane_width / 2);
                var _lane_x2 = _lane.current_x + (_lane_width / 2);
                
                var _lane_bg_color = (i % 2 == 0) ? make_color_rgb(30, 25, 25) : make_color_rgb(38, 32, 32);
                draw_set_color(_lane_bg_color);
                draw_rectangle(_lane_x1, 0, _lane_x2, room_height, false);
            }

            
            var _lanes_start_x = lanes[0].current_x - (_lane_width / 2);
            var _lanes_end_x = lanes[array_length(lanes) - 1].current_x + (_lane_width / 2);
            var _playhead_y = get_playhead_y();
            var _start_beat = floor((current_chart_position / sec_per_beat) - (_playhead_y / (pixels_per_second * sec_per_beat)));
            var _end_beat = ceil((current_chart_position / sec_per_beat) + ((room_height - _playhead_y) / (pixels_per_second * sec_per_beat)));
            for (var b = _start_beat; b <= _end_beat; b += 1 / snap_division) {
                if (b < 0) continue;
                var _beat_time = b * sec_per_beat;
                var _draw_y = _playhead_y + (_beat_time - current_chart_position) * pixels_per_second;
                if (b == floor(b)) { draw_set_color(_c_beat_line); }
                else { draw_set_color(_c_sub_beat_line); }
                draw_line(_lanes_start_x, _draw_y, _lanes_end_x, _draw_y);
            }

            
            var _notes_array = chart_data.notes;
            for (var i = 0; i < array_length(_notes_array); i++) {
                var _note = _notes_array[i];
                if (_note.type != 3 && _note.type != 4 && _note.type != 5 && _note.type != 6) continue; 

                var _lane_data = lanes[_note.lane];
                var _draw_x = _note.visual_x; 
                var _start_y = _playhead_y + (_note.visual_timestamp - current_chart_position) * pixels_per_second;
            
                var _note_color = _c_move;
if (_note.type == 4) _note_color = UI_COLOR_SCALE;
if (_note.type == 5) _note_color = UI_COLOR_SCRIPT;
if (_note.type == 6) _note_color = UI_COLOR_RESET;
                if (array_contains(selected_notes, i)) _note_color = _c_selection;
            
                var _draw_scale = (i == hovered_note_index || array_contains(selected_notes, i)) ? 1.2 : 1.0;
                if (_start_y > -20 && _start_y < room_height + 20) {
                    draw_sprite_ext(SprNote, _lane_data.sprite_index, _draw_x, _start_y, _draw_scale, _draw_scale, 0, _note_color, 1);
                }
            }
        }
        
        if (array_length(selected_notes) > 0 && !is_box_selecting) {
            var _min_x = room_width, _max_x = 0;
            var _min_y = room_height, _max_y = 0;
            var _note_half_w = 17 / 2;
            var _note_half_h = 17 / 2;

            for(var i=0; i < array_length(selected_notes); i++) {
                var _note = _notes_array[selected_notes[i]];
                var _draw_x = _note.visual_x;
                var _start_y = get_playhead_y() + (_note.visual_timestamp - current_chart_position) * pixels_per_second;
                var _end_y = _start_y + ((_note.type == 1) ? _note.duration * pixels_per_second : 0);
                
                _min_x = min(_min_x, _draw_x - _note_half_w);
                _max_x = max(_max_x, _draw_x + _note_half_w);
                _min_y = min(_min_y, _start_y - _note_half_h);
                _max_y = max(_max_y, _end_y + _note_half_h);
            }
            
            draw_set_color(_c_selection);
            draw_set_alpha(0.4);
            var _pad = 4;
            draw_rectangle(_min_x - _pad, _min_y - _pad, _max_x + _pad, _max_y + _pad, true);
            draw_set_alpha(1.0);
        }

        draw_set_alpha(0.3);
        draw_set_color(c_black);
        draw_rectangle(0, _playhead_y, room_width, room_height, false);
        draw_set_alpha(1);
        draw_set_color(_c_playhead);
        draw_line_width(0, _playhead_y, room_width, _playhead_y, 2);
        
        if (is_box_selecting) {
            draw_set_color(_c_selection);
            draw_set_alpha(0.2);
            var _draw_y1 = get_playhead_y() + (box_select_y1_chart - current_chart_position) * pixels_per_second;
            draw_rectangle(box_select_x1, _draw_y1, mouse_x, mouse_y, false);
            draw_set_alpha(1);
            draw_rectangle(box_select_x1, _draw_y1, mouse_x, mouse_y, true);
        }

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        for (var i = 0; i < array_length(lanes); i++) {
            var _lane = lanes[i];
            draw_set_color(lanes[i].highlight_alpha > 0 ? c_white : _c_text_dim);
            draw_text(_lane.current_x, _playhead_y + 25, chr(_lane.key));
        }
        var _bar_h = 24;
        var _text_scale = 0.5;
        var _padding = 15;
        draw_set_color(_c_panel_bg);
        draw_set_alpha(0.7);
        draw_rectangle(0, 0, room_width, _bar_h, false);
        draw_set_alpha(1);
        var _ty = _bar_h / 2;
        draw_set_valign(fa_middle);
        draw_set_halign(fa_left);
        var _note_type_str = "NORMAL";
        if (note_placement_type == ENotePlacementType.REPEL) _note_type_str = "REPEL";
        if (note_placement_type == ENotePlacementType.MOVE) _note_type_str = "MOVE";
        if (note_placement_type == ENotePlacementType.SCALE) _note_type_str = "SCALE";
if (note_placement_type == ENotePlacementType.SCRIPT) _note_type_str = "SCRIPT";
if (note_placement_type == ENotePlacementType.RESET) _note_type_str = "RESET";
        var _status_str = "[EDIT MODE] Note Type: " + _note_type_str;
        draw_set_color(_c_highlight);
        draw_text_transformed(_padding, _ty, _status_str, _text_scale, _text_scale, 0);
        draw_set_halign(fa_center);
        draw_set_color(_c_text_dim);
        var _time_str = string_format(current_chart_position, 1, 2) + "/" + string_format(song_length, 1, 1) + "s";
        var _bpm_str = string(bpm) + " BPM";
        var _notes_str = "Notes: " + string(array_length(chart_data.notes));
        var _center_info = _time_str + "     |     " + _bpm_str + "     |     " + _notes_str;
        draw_text_transformed(room_width / 2, _ty, _center_info, _text_scale, _text_scale, 0);
        draw_set_halign(fa_right);
        var _snap_str = "1/" + string(snap_division);
        if (snap_division == 12) _snap_str = "1/8T";
        _snap_str = "Snap: " + _snap_str;
        draw_set_color(_c_highlight);
        draw_text_transformed(room_width - _padding, _ty, _snap_str, _text_scale, _text_scale, 0);

        
        var _scrubber_track_color = c_dkgray;
        var _scrubber_handle_color = c_gray;
        var _mouse_over_scrubber = point_in_rectangle(mouse_x, mouse_y, scrubber_x - 5, scrubber_handle_y, scrubber_x + 5, scrubber_handle_y + scrubber_handle_height);

        if (_mouse_over_scrubber || is_scrubbing) {
            _scrubber_handle_color = c_white;
        }

        draw_set_color(_scrubber_track_color);
        draw_line_width(scrubber_x, scrubber_y_start, scrubber_x, scrubber_y_start + scrubber_height, 2);

        draw_set_color(_scrubber_handle_color);
        draw_rectangle(scrubber_x - 5, scrubber_handle_y, scrubber_x + 5, scrubber_handle_y + scrubber_handle_height, false);
        
        
        draw_sprite_ext(SprArrow, 0, gui_arrow_current_x, gui_arrow_current_y, 1, 1, gui_anim_progress * 180, c_white, 1);

        if (gui_anim_progress > 0.01) {
            var _field_names = variable_struct_get_names(input_fields);
            var _max_delay = 0;
            for (var i = 0; i < array_length(_field_names); i++) {
                _max_delay = max(_max_delay, input_fields[$ _field_names[i]].delay);
            }
            
            for (var i = 0; i < array_length(_field_names); i++) {
                var _name = _field_names[i];
                var _field = input_fields[$ _name];
                var _rect = _field.rect;
                var _delay = _field.delay;
                
                var _item_progress;
                if (gui_anim_target == 1) {
                    _item_progress = clamp((gui_anim_progress - _delay) / (1.0 - _delay), 0, 1);
                } else {
                    var _reverse_delay = _max_delay - _delay;
                    var _hide_progress = 1.0 - gui_anim_progress;
                    _item_progress = 1.0 - clamp((_hide_progress - _reverse_delay) / (1.0 - _reverse_delay), 0, 1);
                }
                
                var _ease_progress = ease_out_back(_item_progress);
                if (_ease_progress < 0.01) continue;
            
                var _offscreen_x = -100;
                var _current_x1 = lerp(_offscreen_x, _rect[0], _ease_progress);
                var _current_x2 = lerp(_offscreen_x + (_rect[2] - _rect[0]), _rect[2], _ease_progress);
                var _anim_rect = [_current_x1, _rect[1], _current_x2, _rect[3]];
            
                var _is_active = (active_input == _field);
            
                
                draw_set_color(_is_active ? c_white : c_gray);
                draw_rectangle(_anim_rect[0], _anim_rect[1], _anim_rect[2], _anim_rect[3], true);
                draw_set_color(c_black);
                draw_rectangle(_anim_rect[0]+1, _anim_rect[1]+1, _anim_rect[2]-1, _anim_rect[3]-1, false);
            
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_bottom);
                draw_set_color(c_dkgray);
                draw_text_transformed(_anim_rect[0], _anim_rect[1] - 2, _field.label, 0.5, 0.5, 0);
            
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_middle);
                draw_set_color(c_white);
            
                var _text_scale = 0.5;
                var _draw_x = _anim_rect[0] + 5;
                var _draw_y = (_anim_rect[1] + _anim_rect[3]) / 2;

                if (_is_active) {
                    var _display_text = input_buffer;
                    var _cursor_text = (floor(input_cursor_blink / 30) % 2 == 0) ? "|" : "";

                    if (input_fx_char_index > 0 && input_fx_char_index <= string_length(_display_text)) {
                        var part1 = string_copy(_display_text, 1, input_fx_char_index - 1);
                        var pop_char = string_char_at(_display_text, input_fx_char_index);
                        var part2 = string_copy(_display_text, input_fx_char_index + 1, 999);

                        draw_text_transformed(_draw_x, _draw_y, part1, _text_scale, _text_scale, 0);
                        _draw_x += string_width_ext(part1, -1, -1) * _text_scale;

                        var pop_scale = _text_scale * input_fx_scale;
                        draw_text_transformed(_draw_x, _draw_y, pop_char, pop_scale, pop_scale, 0);
                        _draw_x += string_width_ext(pop_char, -1, -1) * pop_scale;

                        draw_text_transformed(_draw_x, _draw_y, part2, _text_scale, _text_scale, 0);
                        _draw_x += string_width_ext(part2, -1, -1) * _text_scale;
            
                        draw_text_transformed(_draw_x, _draw_y, _cursor_text, _text_scale, _text_scale, 0);
                    } else {
                        draw_text_transformed(_draw_x, _draw_y, _display_text + _cursor_text, _text_scale, _text_scale, 0);
                    }
                } else {
                    var _display_text = string_format(_field.get_value(), 1, 3);
                    draw_text_transformed(_draw_x, _draw_y, _display_text, _text_scale, _text_scale, 0);
                }
            }
        }
                                                                        draw_set_color(c_white); 
        
        
        if (song_list_anim_progress > 0.01) {
            var _panel_ease = ease_out_back(song_list_anim_progress);
            var _arrow_ease = ease_out_cubic(song_list_anim_progress);
            var _song_list_w = 88;
            var _song_list_start_x = room_width;
            var _song_list_end_x = room_width - _song_list_w;
            var _song_list_current_x = lerp(_song_list_start_x, _song_list_end_x, _panel_ease);
            
            var _song_list_y = (room_height - song_list_view_height) / 2;
            var _surf_w = _song_list_w * song_list_surface_scale;
            var _surf_h = song_list_view_height * song_list_surface_scale;

            if (!surface_exists(song_list_surface)) {
                song_list_surface = surface_create(_surf_w, _surf_h);
            }

            surface_set_target(song_list_surface);
            draw_clear_alpha(c_black, 0);

            var _scrollbar_w = 2;
            var _scrollbar_x_on_surf = 0; 

            var _total_song_list_height = array_length(song_list) * song_list_item_height;
            if (_total_song_list_height > song_list_view_height) {
                draw_set_color(c_black);
                draw_set_alpha(0.5);
                draw_rectangle_color(_scrollbar_x_on_surf * song_list_surface_scale, 0, (_scrollbar_x_on_surf + _scrollbar_w) * song_list_surface_scale, song_list_view_height * song_list_surface_scale, c_black, c_black, c_black, c_black, false);
                draw_set_alpha(1.0);
                
                var _handle_h = max(20, song_list_view_height * (song_list_view_height / _total_song_list_height));
                var _scroll_ratio = (_total_song_list_height > song_list_view_height) ? song_list_scroll_y / (_total_song_list_height - song_list_view_height) : 0;
                var _handle_y = (song_list_view_height - _handle_h) * _scroll_ratio;
                
                draw_set_color(c_white);
                draw_set_alpha(is_dragging_scrollbar ? 1.0 : 0.5);
                draw_rectangle_color(_scrollbar_x_on_surf * song_list_surface_scale, _handle_y * song_list_surface_scale, (_scrollbar_x_on_surf + _scrollbar_w) * song_list_surface_scale, (_handle_y + _handle_h) * song_list_surface_scale, c_white, c_white, c_white, c_white, false);
                draw_set_alpha(1.0);
            }

            draw_set_halign(fa_right);
            draw_set_valign(fa_top);
            draw_set_font(fn1);

            for (var i = 0; i < array_length(song_list); i++) {
                var _song = song_list[i];
                var _draw_y = (i * song_list_item_height - song_list_scroll_y) * song_list_surface_scale;
                var _color = (i == selected_song_index) ? c_yellow : c_white;
                
                draw_set_color(_color);
                draw_text_transformed((_song_list_w - 8) * song_list_surface_scale, _draw_y, _song.name, 0.5 * song_list_surface_scale, 0.5 * song_list_surface_scale, 0);
            }

            surface_reset_target();
            draw_surface_ext(song_list_surface, _song_list_current_x, _song_list_y, 1 / song_list_surface_scale, 1 / song_list_surface_scale, 0, c_white, 1);
        }
        
        var _arrow_start_x = room_width - 8;
        var _arrow_end_x = (room_width - 88) - 12;
        var _arrow_x = lerp(_arrow_start_x, _arrow_end_x, ease_out_cubic(song_list_anim_progress));
        draw_sprite_ext(SprArrow, 0, _arrow_x, room_height / 2, -1, 1, song_list_anim_progress * 180, c_white, 1);

                if (move_note_menu_anim_progress > 0) {
            var _ease_progress = ease_out_cubic(move_note_menu_anim_progress);
            var _alpha = _ease_progress;
            var _scale = 0.8 + 0.2 * _ease_progress;

            draw_set_color(c_black);
            draw_set_alpha(0.7 * _alpha);
            draw_rectangle(0, 0, room_width, room_height, false);

            var menu_w = 220 * _scale;
            var menu_h = 120 * _scale;
            var menu_x = room_width / 2;
            var menu_y = room_height / 2;
            var menu_x1 = menu_x - menu_w / 2;
            var menu_y1 = menu_y - menu_h / 2;
            
            draw_set_color(c_dkgray);
            draw_set_alpha(_alpha);
            draw_rectangle(menu_x1, menu_y1, menu_x1 + menu_w, menu_y1 + menu_h, false);

            
            var _padding = 10 * _scale;
            var _spacing = 8 * _scale;
            var _item_w = (menu_w - _padding * 2 - _spacing) / 2;
            var _item_h = (menu_h - _padding * 2 - _spacing * 2) / 3;

            var _col0_x = menu_x1 + _padding;
            var _col1_x = _col0_x + _item_w + _spacing;
            var _row0_y = menu_y1 + _padding;
            var _row1_y = _row0_y + _item_h + _spacing;
            var _row2_y = _row1_y + _item_h + _spacing;
            
            
            var _rects = {
                lane_x_movement:  [_col0_x, _row0_y, _col0_x + _item_w, _row0_y + _item_h],
                lane_y_movement:  [_col1_x, _row0_y, _col1_x + _item_w, _row0_y + _item_h],
                movement_duration: [_col0_x, _row1_y, _col0_x + _item_w, _row1_y + _item_h],
                easing_function:  [_col1_x, _row1_y, _col1_x + _item_w, _row1_y + _item_h],
                wave_effect:      [_col0_x, _row2_y, _col0_x + _item_w, _row2_y + _item_h],
                apply_to_all_lanes:[_col1_x, _row2_y, _col1_x + _item_w, _row2_y + _item_h]
            };

            
            var _field_names = variable_struct_get_names(move_note_menu_fields);
            for (var i = 0; i < array_length(_field_names); i++) {
                var _name = _field_names[i];
                var _field = move_note_menu_fields[$ _name];
                var _rect = _rects[$ _name];
                var _is_active = (active_move_menu_input == _field);
                
                draw_set_color(_is_active ? c_white : c_gray);
                draw_rectangle(_rect[0], _rect[1], _rect[2], _rect[3], true);
                draw_set_color(c_black);
                draw_rectangle(_rect[0]+1, _rect[1]+1, _rect[2]-1, _rect[3]-1, false);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_bottom);
                draw_set_color(c_ltgray);
                draw_text_transformed(_rect[0], _rect[1] - 2, _field.label, 0.5 * _scale, 0.5 * _scale, 0);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_middle);
                draw_set_color(c_white);
                
                var _text_scale = 0.5 * _scale;
                var _draw_x = _rect[0] + (5 * _scale);
                var _draw_y = (_rect[1] + _rect[3]) / 2;

                if (_is_active) {
                    var _display_text = input_buffer;
                    var _cursor_text = (floor(input_cursor_blink / 30) % 2 == 0) ? "|" : "";
                    draw_text_transformed(_draw_x, _draw_y, _display_text + _cursor_text, _text_scale, _text_scale, 0);
                } else {
                    var _display_text = string_format(_field.get_value(), 1, 3);
                    draw_text_transformed(_draw_x, _draw_y, _display_text, _text_scale, _text_scale, 0);
                }
            }
            
            
            var _easing_button_rect = _rects.easing_function;
            var _mouse_over_ease_button = point_in_rectangle(mouse_x, mouse_y, _easing_button_rect[0], _easing_button_rect[1], _easing_button_rect[2], _easing_button_rect[3]);

            draw_set_color(_mouse_over_ease_button ? c_white : c_gray);
            draw_rectangle(_easing_button_rect[0], _easing_button_rect[1], _easing_button_rect[2], _easing_button_rect[3], true);
            draw_set_color(c_black);
            draw_rectangle(_easing_button_rect[0]+1, _easing_button_rect[1]+1, _easing_button_rect[2]-1, _easing_button_rect[3]-1, false);

            draw_set_halign(fa_left);
            draw_set_valign(fa_bottom);
            draw_set_color(c_ltgray);
            draw_text_transformed(_easing_button_rect[0], _easing_button_rect[1] - 2, "Easing Function", 0.5 * _scale, 0.5 * _scale, 0);

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);
        
            var _current_ease_index = get_move_note_value("easing_function", 0);
            var _display_text = easing_function_names[clamp(_current_ease_index, 0, array_length(easing_function_names) - 1)];
            draw_text_transformed((_easing_button_rect[0] + _easing_button_rect[2]) / 2, (_easing_button_rect[1] + _easing_button_rect[3]) / 2, _display_text, 0.5 * _scale, 0.5 * _scale, 0);

            
            var _wave_button_rect = _rects.wave_effect;
            var _mouse_over_wave_button = point_in_rectangle(mouse_x, mouse_y, _wave_button_rect[0], _wave_button_rect[1], _wave_button_rect[2], _wave_button_rect[3]);

            draw_set_color(_mouse_over_wave_button ? c_white : c_gray);
            draw_rectangle(_wave_button_rect[0], _wave_button_rect[1], _wave_button_rect[2], _wave_button_rect[3], true);
            draw_set_color(c_black);
            draw_rectangle(_wave_button_rect[0]+1, _wave_button_rect[1]+1, _wave_button_rect[2]-1, _wave_button_rect[3]-1, false);

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);

            var _wave_effect_index = get_move_note_value("wave_effect", 0);
            var _wave_text = "Wave: ";
            switch (_wave_effect_index) {
                case 0: _wave_text += "None"; break;
                case 1: _wave_text += "Sine"; break;
                case 2: _wave_text += "Cosine"; break;
            }
            draw_text_transformed((_wave_button_rect[0] + _wave_button_rect[2]) / 2, (_wave_button_rect[1] + _wave_button_rect[3]) / 2, _wave_text, 0.5 * _scale, 0.5 * _scale, 0);


            
            var _apply_to_button_rect = _rects.apply_to_all_lanes;
            var _mouse_over_apply_button = point_in_rectangle(mouse_x, mouse_y, _apply_to_button_rect[0], _apply_to_button_rect[1], _apply_to_button_rect[2], _apply_to_button_rect[3]);

            draw_set_color(_mouse_over_apply_button ? c_white : c_gray);
            draw_rectangle(_apply_to_button_rect[0], _apply_to_button_rect[1], _apply_to_button_rect[2], _apply_to_button_rect[3], true);
            draw_set_color(c_black);
            draw_rectangle(_apply_to_button_rect[0]+1, _apply_to_button_rect[1]+1, _apply_to_button_rect[2]-1, _apply_to_button_rect[3]-1, false);

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);

            var _apply_to_all = get_move_note_value("apply_to_all_lanes", 0);
            var _apply_text = "Apply: " + (_apply_to_all ? "All Lanes" : "Single Lane");
            draw_text_transformed((_apply_to_button_rect[0] + _apply_to_button_rect[2]) / 2, (_apply_to_button_rect[1] + _apply_to_button_rect[3]) / 2, _apply_text, 0.5 * _scale, 0.5 * _scale, 0);


            var button_w = 50 * _scale;
            var button_h = 20 * _scale;
            var button_x = menu_x;
            var button_y = menu_y1 + menu_h + (15 * _scale);
            var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];
            
            var _mouse_over_button = point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3]);
            
            draw_set_color(_mouse_over_button ? c_white : c_gray);
            draw_rectangle(button_rect[0], button_rect[1], button_rect[2], button_rect[3], false);
            
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(button_x, button_y, "Exit", _scale, _scale, 0);

            draw_set_alpha(1.0);
        }

        if (is_script_note_menu_open || script_note_menu_anim_progress > 0) {
            var _ease_progress = ease_out_cubic(script_note_menu_anim_progress);
            var _alpha = _ease_progress;
            var _scale = 0.8 + 0.2 * _ease_progress;

            draw_set_color(c_black);
            draw_set_alpha(0.7 * _alpha);
            draw_rectangle(0, 0, room_width, room_height, false);

            var menu_w = 220 * _scale;
            var menu_h = 120 * _scale;
            var menu_x = room_width / 2;
            var menu_y = room_height / 2;
            var menu_x1 = menu_x - menu_w / 2;
            var menu_y1 = menu_y - menu_h / 2;
            
            draw_set_color(c_dkgray);
            draw_set_alpha(_alpha);
            draw_rectangle(menu_x1, menu_y1, menu_x1 + menu_w, menu_y1 + menu_h, false);

            
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
            draw_set_alpha(_alpha);
            draw_text_transformed(menu_x, menu_y1 + (10 * _scale), "Script Note", 0.7 * _scale, 0.7 * _scale, 0);

            
            var _padding = 10 * _scale;
            var _spacing = 8 * _scale;
            var _item_w = (menu_w - _padding * 2 - _spacing) / 2;
            var _item_h = (menu_h - _padding * 2 - _spacing * 2) / 3;
            var _col0_x = menu_x1 + _padding;
            var _row0_y = menu_y1 + _padding + (20 * _scale);

            
            var _easing_button_rect = [_col0_x, _row0_y, _col0_x + _item_w, _row0_y + _item_h];
            var _mouse_over_ease_button = point_in_rectangle(mouse_x, mouse_y, _easing_button_rect[0], _easing_button_rect[1], _easing_button_rect[2], _easing_button_rect[3]);
            draw_set_color(_mouse_over_ease_button ? c_white : c_gray);
            draw_rectangle(_easing_button_rect[0], _easing_button_rect[1], _easing_button_rect[2], _easing_button_rect[3], true);
            draw_set_color(c_black);
            draw_rectangle(_easing_button_rect[0]+1, _easing_button_rect[1]+1, _easing_button_rect[2]-1, _easing_button_rect[3]-1, false);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);
            var _current_ease_index = get_script_note_value("easing", 0);
            var _display_text = easing_function_names[clamp(_current_ease_index, 0, array_length(easing_function_names) - 1)];
            draw_text_transformed((_easing_button_rect[0] + _easing_button_rect[2]) / 2, (_easing_button_rect[1] + _easing_button_rect[3]) / 2, _display_text, 0.5 * _scale, 0.5 * _scale, 0);

            
            var _list = script_note_menu_scroll_list;
            var _list_x = menu_x1 + _item_w + _spacing + (10 * _scale);
            var _list_y = _row0_y;
            var _list_w = _item_w - (20 * _scale);
            var _list_h = _list.view_height;
            var _surf_w = _list_w * _list.surface_scale;
            var _surf_h = _list_h * _list.surface_scale;

            if (!surface_exists(_list.surface)) {
                _list.surface = surface_create(_surf_w, _surf_h);
            }

            surface_set_target(_list.surface);
            draw_clear_alpha(c_black, 0);
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_font(fn1);

            for (var i = 0; i < array_length(_list.items); i++) {
                var _item_y = (i * _list.item_height) - _list.scroll_y;
                var _draw_y_on_surf = _item_y * _list.surface_scale;
                
                if (_item_y + _list.item_height < 0 || _item_y > _list_h) continue;

                var _color = (i == _list.selected_index) ? c_yellow : c_white;
                draw_set_color(_color);
                draw_text_transformed((_list_w / 2) * _list.surface_scale, _draw_y_on_surf + (_list.item_height / 2 * _list.surface_scale), _list.items[i], 0.5 * _list.surface_scale, 0.5 * _list.surface_scale, 0);
            }

            surface_reset_target();
            
            draw_set_alpha(_alpha);
            draw_surface_ext(_list.surface, _list_x, _list_y, 1 / _list.surface_scale, 1 / _list.surface_scale, 0, c_white, 1);
            draw_set_color(c_white);
            draw_rectangle(_list_x, _list_y, _list_x + _list_w, _list_y + _list_h, true);
            draw_set_alpha(1.0);

            
            var button_w = 50 * _scale;
            var button_h = 20 * _scale;
            var button_x = menu_x;
            var button_y = menu_y1 + menu_h + (15 * _scale);
            var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];
            var _mouse_over_button = point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3]);
            
            draw_set_alpha(_alpha);
            draw_set_color(_mouse_over_button ? c_white : c_gray);
            draw_rectangle(button_rect[0], button_rect[1], button_rect[2], button_rect[3], false);
            
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(button_x, button_y, "Exit", _scale, _scale, 0);

            draw_set_alpha(1.0);
        }

        if (is_flash_effect_menu_open || flash_effect_menu_anim_progress > 0) {
            var _ease_progress = ease_out_cubic(flash_effect_menu_anim_progress);
            var _alpha = _ease_progress;
            var _scale = 0.8 + 0.2 * _ease_progress;

            draw_set_color(c_black);
            draw_set_alpha(0.7 * _alpha);
            draw_rectangle(0, 0, room_width, room_height, false);

            var menu_w = 220 * _scale;
            var menu_h = 120 * _scale;
            var menu_x = room_width / 2;
            var menu_y = room_height / 2;
            var menu_x1 = menu_x - menu_w / 2;
            var menu_y1 = menu_y - menu_h / 2;
            
            draw_set_color(c_dkgray);
            draw_set_alpha(_alpha);
            draw_rectangle(menu_x1, menu_y1, menu_x1 + menu_w, menu_y1 + menu_h, false);

            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
            draw_text_transformed(menu_x, menu_y1 + (10 * _scale), "Flash Effect", 0.7 * _scale, 0.7 * _scale, 0);

            var _field_names = variable_struct_get_names(flash_effect_menu_fields);
            for (var i = 0; i < array_length(_field_names); i++) {
                var _name = _field_names[i];
                var _field = flash_effect_menu_fields[$ _name];
                var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
                var _is_active = (active_input == _field);
                
                draw_set_color(_is_active ? c_white : c_gray);
                draw_rectangle(_rect[0], _rect[1], _rect[2], _rect[3], true);
                draw_set_color(c_black);
                draw_rectangle(_rect[0]+1, _rect[1]+1, _rect[2]-1, _rect[3]-1, false);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_bottom);
                draw_set_color(c_ltgray);
                draw_text_transformed(_rect[0], _rect[1] - 2, _field.label, 0.5 * _scale, 0.5 * _scale, 0);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_middle);
                draw_set_color(c_white);
                
                var _text_scale = 0.5 * _scale;
                var _draw_x = _rect[0] + (5 * _scale);
                var _draw_y = (_rect[1] + _rect[3]) / 2;

                if (_is_active) {
                    var _display_text = input_buffer;
                    var _cursor_text = (floor(input_cursor_blink / 30) % 2 == 0) ? "|" : "";
                    draw_text_transformed(_draw_x, _draw_y, _display_text + _cursor_text, _text_scale, _text_scale, 0);
                } else {
                    var _display_text = string_format(_field.get_value(), 1, 3);
                    draw_text_transformed(_draw_x, _draw_y, _display_text, _text_scale, _text_scale, 0);
                }
            }

            var button_w = 50 * _scale;
            var button_h = 20 * _scale;
            var button_x = menu_x;
            var button_y = menu_y1 + menu_h + (15 * _scale);
            var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];
            
            var _mouse_over_button = point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3]);
            
            draw_set_color(_mouse_over_button ? c_white : c_gray);
            draw_rectangle(button_rect[0], button_rect[1], button_rect[2], button_rect[3], false);
            
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(button_x, button_y, "Exit", _scale, _scale, 0);

            draw_set_alpha(1.0);
        }

        if (is_shake_effect_menu_open || shake_effect_menu_anim_progress > 0) {
            var _ease_progress = ease_out_cubic(shake_effect_menu_anim_progress);
            var _alpha = _ease_progress;
            var _scale = 0.8 + 0.2 * _ease_progress;

            draw_set_color(c_black);
            draw_set_alpha(0.7 * _alpha);
            draw_rectangle(0, 0, room_width, room_height, false);

            var menu_w = 220 * _scale;
            var menu_h = 120 * _scale;
            var menu_x = room_width / 2;
            var menu_y = room_height / 2;
            var menu_x1 = menu_x - menu_w / 2;
            var menu_y1 = menu_y - menu_h / 2;
            
            draw_set_color(c_dkgray);
            draw_set_alpha(_alpha);
            draw_rectangle(menu_x1, menu_y1, menu_x1 + menu_w, menu_y1 + menu_h, false);

            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
            draw_text_transformed(menu_x, menu_y1 + (10 * _scale), "Shake Effect", 0.7 * _scale, 0.7 * _scale, 0);

            var _field_names = variable_struct_get_names(shake_effect_menu_fields);
            for (var i = 0; i < array_length(_field_names); i++) {
                var _name = _field_names[i];
                var _field = shake_effect_menu_fields[$ _name];
                var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
                var _is_active = (active_input == _field);
                
                draw_set_color(_is_active ? c_white : c_gray);
                draw_rectangle(_rect[0], _rect[1], _rect[2], _rect[3], true);
                draw_set_color(c_black);
                draw_rectangle(_rect[0]+1, _rect[1]+1, _rect[2]-1, _rect[3]-1, false);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_bottom);
                draw_set_color(c_ltgray);
                draw_text_transformed(_rect[0], _rect[1] - 2, _field.label, 0.5 * _scale, 0.5 * _scale, 0);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_middle);
                draw_set_color(c_white);
                
                var _text_scale = 0.5 * _scale;
                var _draw_x = _rect[0] + (5 * _scale);
                var _draw_y = (_rect[1] + _rect[3]) / 2;

                if (_is_active) {
                    var _display_text = input_buffer;
                    var _cursor_text = (floor(input_cursor_blink / 30) % 2 == 0) ? "|" : "";
                    draw_text_transformed(_draw_x, _draw_y, _display_text + _cursor_text, _text_scale, _text_scale, 0);
                } else {
                    var _display_text = string_format(_field.get_value(), 1, 3);
                    draw_text_transformed(_draw_x, _draw_y, _display_text, _text_scale, _text_scale, 0);
                }
            }

            var button_w = 50 * _scale;
            var button_h = 20 * _scale;
            var button_x = menu_x;
            var button_y = menu_y1 + menu_h + (15 * _scale);
            var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];
            
            var _mouse_over_button = point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3]);
            
            draw_set_color(_mouse_over_button ? c_white : c_gray);
            draw_rectangle(button_rect[0], button_rect[1], button_rect[2], button_rect[3], false);
            
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(button_x, button_y, "Exit", _scale, _scale, 0);

            draw_set_alpha(1.0);
        }

        if (is_spin_effect_menu_open || spin_effect_menu_anim_progress > 0) {
            var _ease_progress = ease_out_cubic(spin_effect_menu_anim_progress);
            var _alpha = _ease_progress;
            var _scale = 0.8 + 0.2 * _ease_progress;

            draw_set_color(c_black);
            draw_set_alpha(0.7 * _alpha);
            draw_rectangle(0, 0, room_width, room_height, false);

            var menu_w = 220 * _scale;
            var menu_h = 120 * _scale;
            var menu_x = room_width / 2;
            var menu_y = room_height / 2;
            var menu_x1 = menu_x - menu_w / 2;
            var menu_y1 = menu_y - menu_h / 2;
            
            draw_set_color(c_dkgray);
            draw_set_alpha(_alpha);
            draw_rectangle(menu_x1, menu_y1, menu_x1 + menu_w, menu_y1 + menu_h, false);

            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
            draw_text_transformed(menu_x, menu_y1 + (10 * _scale), "Spin Effect", 0.7 * _scale, 0.7 * _scale, 0);

            var _field_names = variable_struct_get_names(spin_effect_menu_fields);
            for (var i = 0; i < array_length(_field_names); i++) {
                var _name = _field_names[i];
                var _field = spin_effect_menu_fields[$ _name];
                var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
                var _is_active = (active_input == _field);
                
                draw_set_color(_is_active ? c_white : c_gray);
                draw_rectangle(_rect[0], _rect[1], _rect[2], _rect[3], true);
                draw_set_color(c_black);
                draw_rectangle(_rect[0]+1, _rect[1]+1, _rect[2]-1, _rect[3]-1, false);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_bottom);
                draw_set_color(c_ltgray);
                draw_text_transformed(_rect[0], _rect[1] - 2, _field.label, 0.5 * _scale, 0.5 * _scale, 0);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_middle);
                draw_set_color(c_white);
                
                var _text_scale = 0.5 * _scale;
                var _draw_x = _rect[0] + (5 * _scale);
                var _draw_y = (_rect[1] + _rect[3]) / 2;

                if (_is_active) {
                    var _display_text = input_buffer;
                    var _cursor_text = (floor(input_cursor_blink / 30) % 2 == 0) ? "|" : "";
                    draw_text_transformed(_draw_x, _draw_y, _display_text + _cursor_text, _text_scale, _text_scale, 0);
                } else {
                    var _display_text = string_format(_field.get_value(), 1, 3);
                    draw_text_transformed(_draw_x, _draw_y, _display_text, _text_scale, _text_scale, 0);
                }
            }

            var button_w = 50 * _scale;
            var button_h = 20 * _scale;
            var button_x = menu_x;
            var button_y = menu_y1 + menu_h + (15 * _scale);
            var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];
            
            var _mouse_over_button = point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3]);
            
            draw_set_color(_mouse_over_button ? c_white : c_gray);
            draw_rectangle(button_rect[0], button_rect[1], button_rect[2], button_rect[3], false);
            
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(button_x, button_y, "Exit", _scale, _scale, 0);

            draw_set_alpha(1.0);
        }

        if (is_wave_lane_menu_open || wave_lane_menu_anim_progress > 0) {
            var _ease_progress = ease_out_cubic(wave_lane_menu_anim_progress);
            var _alpha = _ease_progress;
            var _scale = 0.8 + 0.2 * _ease_progress;

            draw_set_color(c_black);
            draw_set_alpha(0.7 * _alpha);
            draw_rectangle(0, 0, room_width, room_height, false);

            var menu_w = 220 * _scale;
            var menu_h = 120 * _scale;
            var menu_x = room_width / 2;
            var menu_y = room_height / 2;
            var menu_x1 = menu_x - menu_w / 2;
            var menu_y1 = menu_y - menu_h / 2;
            
            draw_set_color(c_dkgray);
            draw_set_alpha(_alpha);
            draw_rectangle(menu_x1, menu_y1, menu_x1 + menu_w, menu_y1 + menu_h, false);

            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
            draw_text_transformed(menu_x, menu_y1 + (10 * _scale), "Wave Lane", 0.7 * _scale, 0.7 * _scale, 0);

            var _field_names = variable_struct_get_names(wave_lane_menu_fields);
            for (var i = 0; i < array_length(_field_names); i++) {
                var _name = _field_names[i];
                var _field = wave_lane_menu_fields[$ _name];
                var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
                var _is_active = (active_input == _field);
                
                draw_set_color(_is_active ? c_white : c_gray);
                draw_rectangle(_rect[0], _rect[1], _rect[2], _rect[3], true);
                draw_set_color(c_black);
                draw_rectangle(_rect[0]+1, _rect[1]+1, _rect[2]-1, _rect[3]-1, false);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_bottom);
                draw_set_color(c_ltgray);
                draw_text_transformed(_rect[0], _rect[1] - 2, _field.label, 0.5 * _scale, 0.5 * _scale, 0);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_middle);
                draw_set_color(c_white);
                
                var _text_scale = 0.5 * _scale;
                var _draw_x = _rect[0] + (5 * _scale);
                var _draw_y = (_rect[1] + _rect[3]) / 2;

                if (_is_active) {
                    var _display_text = input_buffer;
                    var _cursor_text = (floor(input_cursor_blink / 30) % 2 == 0) ? "|" : "";
                    draw_text_transformed(_draw_x, _draw_y, _display_text + _cursor_text, _text_scale, _text_scale, 0);
                } else {
                    var _display_text = string_format(_field.get_value(), 1, 3);
                    draw_text_transformed(_draw_x, _draw_y, _display_text, _text_scale, _text_scale, 0);
                }
            }

            var button_w = 50 * _scale;
            var button_h = 20 * _scale;
            var button_x = menu_x;
            var button_y = menu_y1 + menu_h + (15 * _scale);
            var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];
            
            var _mouse_over_button = point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3]);
            
            draw_set_color(_mouse_over_button ? c_white : c_gray);
            draw_rectangle(button_rect[0], button_rect[1], button_rect[2], button_rect[3], false);
            
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(button_x, button_y, "Exit", _scale, _scale, 0);

            draw_set_alpha(1.0);
        }

        if (is_zoom_effect_menu_open || zoom_effect_menu_anim_progress > 0) {
            var _ease_progress = ease_out_cubic(zoom_effect_menu_anim_progress);
            var _alpha = _ease_progress;
            var _scale = 0.8 + 0.2 * _ease_progress;

            draw_set_color(c_black);
            draw_set_alpha(0.7 * _alpha);
            draw_rectangle(0, 0, room_width, room_height, false);

            var menu_w = 220 * _scale;
            var menu_h = 120 * _scale;
            var menu_x = room_width / 2;
            var menu_y = room_height / 2;
            var menu_x1 = menu_x - menu_w / 2;
            var menu_y1 = menu_y - menu_h / 2;
            
            draw_set_color(c_dkgray);
            draw_set_alpha(_alpha);
            draw_rectangle(menu_x1, menu_y1, menu_x1 + menu_w, menu_y1 + menu_h, false);

            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
            draw_text_transformed(menu_x, menu_y1 + (10 * _scale), "Zoom Effect", 0.7 * _scale, 0.7 * _scale, 0);

            var _field_names = variable_struct_get_names(zoom_effect_menu_fields);
            for (var i = 0; i < array_length(_field_names); i++) {
                var _name = _field_names[i];
                var _field = zoom_effect_menu_fields[$ _name];
                var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
                var _is_active = (active_input == _field);
                
                draw_set_color(_is_active ? c_white : c_gray);
                draw_rectangle(_rect[0], _rect[1], _rect[2], _rect[3], true);
                draw_set_color(c_black);
                draw_rectangle(_rect[0]+1, _rect[1]+1, _rect[2]-1, _rect[3]-1, false);
                
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_bottom);
                draw_set_color(c_ltgray);
                draw_text_transformed(_rect[0], _rect[1] - 2, _field.label, 0.5 * _scale, 0.5 * _scale, 0);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_bottom);
                draw_set_color(c_white);
                var _text_scale = 0.5 * _scale;
                var _draw_x = _rect[0] + (5 * _scale);
                var _draw_y = (_rect[1] + _rect[3]) / 2;

                if (_is_active) {
                    var _display_text = input_buffer;
                    var _cursor_text = (floor(input_cursor_blink / 30) % 2 == 0) ? "|" : "";
                    draw_text_transformed(_draw_x, _draw_y, _display_text + _cursor_text, _text_scale, _text_scale, 0);
                } else {
                    var _display_text = string_format(_field.get_value(), 1, 3);
                    draw_text_transformed(_draw_x, _draw_y, _display_text, _text_scale, _text_scale, 0);
                }
            }

            var button_w = 50 * _scale;
            var button_h = 20 * _scale;
            var button_x = menu_x;
            var button_y = menu_y1 + menu_h + (15 * _scale);
            var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];
            
            var _mouse_over_button = point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3]);
            
            draw_set_color(_mouse_over_button ? c_white : c_gray);
            draw_rectangle(button_rect[0], button_rect[1], button_rect[2], button_rect[3], false);
            
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(button_x, button_y, "Exit", _scale, _scale, 0);

            draw_set_alpha(1.0);
        }

        if (is_threed_effect_menu_open || threed_effect_menu_anim_progress > 0) {
            var _ease_progress = ease_out_cubic(threed_effect_menu_anim_progress);
            var _alpha = _ease_progress;
            var _scale = 0.8 + 0.2 * _ease_progress;

            draw_set_color(c_black);
            draw_set_alpha(0.7 * _alpha);
            draw_rectangle(0, 0, room_width, room_height, false);
            
            var menu_w = 220 * _scale;
            var menu_h = 160 * _scale;
            var menu_x = room_width / 2;
            var menu_y = room_height / 2;
            var menu_x1 = menu_x - menu_w / 2;
            var menu_y1 = menu_y - menu_h / 2;
            
            draw_set_color(c_dkgray);
            draw_set_alpha(_alpha);
            draw_rectangle(menu_x1, menu_y1, menu_x1 + menu_w, menu_y1 + menu_h, false);

            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
            draw_text_transformed(menu_x, menu_y1 + (10 * _scale), "3D Effect", 0.7 * _scale, 0.7 * _scale, 0);

            var _field_names = variable_struct_get_names(threed_effect_menu_fields);
            for (var i = 0; i < array_length(_field_names); i++) {
                var _name = _field_names[i];
                var _field = threed_effect_menu_fields[$ _name];
                var _rect = [menu_x1 + 10, menu_y1 + 30 + i * 30, menu_x1 + menu_w - 10, menu_y1 + 50 + i * 30];
                var _is_active = (active_input == _field);
                
                draw_set_color(_is_active ? c_white : c_gray);
                draw_rectangle(_rect[0], _rect[1], _rect[2], _rect[3], true);
                draw_set_color(c_black);
                draw_rectangle(_rect[0]+1, _rect[1]+1, _rect[2]-1, _rect[3]-1, false);
                
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_bottom);
                draw_set_color(c_ltgray);
                draw_text_transformed(_rect[0], _rect[1] - 2, _field.label, 0.5 * _scale, 0.5 * _scale, 0);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_middle);
                draw_set_color(c_white);
                var _text_scale = 0.5 * _scale;
                var _draw_x = _rect[0] + (5 * _scale);
                var _draw_y = (_rect[1] + _rect[3]) / 2;

                if (_is_active) {
                    var _display_text = input_buffer;
                    var _cursor_text = (floor(input_cursor_blink / 30) % 2 == 0) ? "|" : "";
                    draw_text_transformed(_draw_x, _draw_y, _display_text + _cursor_text, _text_scale, _text_scale, 0);
                } else {
                    var _display_text = string_format(_field.get_value(), 1, 3);
                    draw_text_transformed(_draw_x, _draw_y, _display_text, _text_scale, _text_scale, 0);
                }
            }

            var button_w = 50 * _scale;
            var button_h = 20 * _scale;
            var button_x = menu_x;
            var button_y = menu_y1 + menu_h + (15 * _scale);
            var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];
            
            var _mouse_over_button = point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3]);
            
            draw_set_color(_mouse_over_button ? c_white : c_gray);
            draw_rectangle(button_rect[0], button_rect[1], button_rect[2], button_rect[3], false);
            
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(button_x, button_y, "Exit", _scale, _scale, 0);

            draw_set_alpha(1.0);
        }

        if (is_scale_note_menu_open || scale_note_menu_anim_progress > 0) {
            var _ease_progress = ease_out_cubic(scale_note_menu_anim_progress);
            var _alpha = _ease_progress;
            var _scale = 0.8 + 0.2 * _ease_progress;

            draw_set_color(c_black);
            draw_set_alpha(0.7 * _alpha);
            draw_rectangle(0, 0, room_width, room_height, false);

            var menu_w = 220 * _scale;
            var menu_h = 120 * _scale;
            var menu_x = room_width / 2;
            var menu_y = room_height / 2;
            var menu_x1 = menu_x - menu_w / 2;
            var menu_y1 = menu_y - menu_h / 2;
            
            draw_set_color(c_dkgray);
            draw_set_alpha(_alpha);
            draw_rectangle(menu_x1, menu_y1, menu_x1 + menu_w, menu_y1 + menu_h, false);

            
            var _padding = 10 * _scale;
            var _spacing = 8 * _scale;
            var _item_w = (menu_w - _padding * 2 - _spacing) / 2;
            var _item_h = (menu_h - _padding * 2 - _spacing * 2) / 3;

            var _col0_x = menu_x1 + _padding;
            var _col1_x = _col0_x + _item_w + _spacing;
            var _row0_y = menu_y1 + _padding;
            var _row1_y = _row0_y + _item_h + _spacing;
            var _row2_y = _row1_y + _item_h + _spacing;
            
            
            var _rects = {
                x_scale:          [_col0_x, _row0_y, _col0_x + _item_w, _row0_y + _item_h],
                y_scale:          [_col1_x, _row0_y, _col1_x + _item_w, _row0_y + _item_h],
                scale_duration:   [_col0_x, _row1_y, _col0_x + _item_w, _row1_y + _item_h],
                scale_easing:     [_col1_x, _row1_y, _col1_x + _item_w, _row1_y + _item_h],
                spin:             [_col0_x, _row2_y, _col0_x + _item_w, _row2_y + _item_h],
                angle:            [_col1_x, _row2_y, _col1_x + _item_w, _row2_y + _item_h]
            };

            
            var _field_names = ["x_scale", "y_scale", "scale_duration", "angle"];
            for (var i = 0; i < array_length(_field_names); i++) {
                var _name = _field_names[i];
                                var _field = scale_note_menu_fields[$ _name];
                var _rect = _rects[$ _name];
                var _is_active = (active_scale_menu_input == _field);
                
                draw_set_color(_is_active ? c_white : c_gray);
                draw_rectangle(_rect[0], _rect[1], _rect[2], _rect[3], true);
                draw_set_color(c_black);
                draw_rectangle(_rect[0]+1, _rect[1]+1, _rect[2]-1, _rect[3]-1, false);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_bottom);
                draw_set_color(c_ltgray);
                draw_text_transformed(_rect[0], _rect[1] - 2, _field.label, 0.5 * _scale, 0.5 * _scale, 0);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_middle);
                draw_set_color(c_white);
                
                var _text_scale = 0.5 * _scale;
                var _draw_x = _rect[0] + (5 * _scale);
                var _draw_y = (_rect[1] + _rect[3]) / 2;

                if (_is_active) {
                    var _display_text = input_buffer;
                    var _cursor_text = (floor(input_cursor_blink / 30) % 2 == 0) ? "|" : "";
                    draw_text_transformed(_draw_x, _draw_y, _display_text + _cursor_text, _text_scale, _text_scale, 0);
                } else {
                    var _display_text = string_format(_field.get_value(), 1, 3);
                    draw_text_transformed(_draw_x, _draw_y, _display_text, _text_scale, _text_scale, 0);
                }
            }
            
            
            var _easing_button_rect = _rects.scale_easing;
            var _mouse_over_ease_button = point_in_rectangle(mouse_x, mouse_y, _easing_button_rect[0], _easing_button_rect[1], _easing_button_rect[2], _easing_button_rect[3]);

            draw_set_color(_mouse_over_ease_button ? c_white : c_gray);
            draw_rectangle(_easing_button_rect[0], _easing_button_rect[1], _easing_button_rect[2], _easing_button_rect[3], true);
            draw_set_color(c_black);
            draw_rectangle(_easing_button_rect[0]+1, _easing_button_rect[1]+1, _easing_button_rect[2]-1, _easing_button_rect[3]-1, false);

            draw_set_halign(fa_left);
            draw_set_valign(fa_bottom);
            draw_set_color(c_ltgray);
            draw_text_transformed(_easing_button_rect[0], _easing_button_rect[1] - 2, "Easing", 0.5 * _scale, 0.5 * _scale, 0);

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);
        
            var _current_ease_index = get_scale_note_value("scale_easing", 0);
            var _display_text = easing_function_names[clamp(_current_ease_index, 0, array_length(easing_function_names) - 1)];
            draw_text_transformed((_easing_button_rect[0] + _easing_button_rect[2]) / 2, (_easing_button_rect[1] + _easing_button_rect[3]) / 2, _display_text, 0.5 * _scale, 0.5 * _scale, 0);

            
            var _spin_button_rect = _rects.spin;
            var _mouse_over_spin_button = point_in_rectangle(mouse_x, mouse_y, _spin_button_rect[0], _spin_button_rect[1], _spin_button_rect[2], _spin_button_rect[3]);

            draw_set_color(_mouse_over_spin_button ? c_white : c_gray);
            draw_rectangle(_spin_button_rect[0], _spin_button_rect[1], _spin_button_rect[2], _spin_button_rect[3], true);
            draw_set_color(c_black);
            draw_rectangle(_spin_button_rect[0]+1, _spin_button_rect[1]+1, _spin_button_rect[2]-1, _spin_button_rect[3]-1, false);

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);

            var _spin_on = get_scale_note_value("spin", 0) > 0;
            var _spin_text = "Spin: " + (_spin_on ? "On" : "Off");
            draw_text_transformed((_spin_button_rect[0] + _spin_button_rect[2]) / 2, (_spin_button_rect[1] + _spin_button_rect[3]) / 2, _spin_text, 0.5 * _scale, 0.5 * _scale, 0);

            var button_w = 50 * _scale;
            var button_h = 20 * _scale;
            var button_x = menu_x;
            var button_y = menu_y1 + menu_h + (15 * _scale);
            var button_rect = [button_x - button_w/2, button_y - button_h/2, button_x + button_w/2, button_y + button_h/2];
            
            var _mouse_over_button = point_in_rectangle(mouse_x, mouse_y, button_rect[0], button_rect[1], button_rect[2], button_rect[3]);
            
            draw_set_color(_mouse_over_button ? c_white : c_gray);
            draw_rectangle(button_rect[0], button_rect[1], button_rect[2], button_rect[3], false);
            
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(button_x, button_y, "Exit", _scale, _scale, 0);

            draw_set_alpha(1.0);
        }

        if (is_reset_note_menu_open || reset_note_menu_anim_progress > 0) {
            var _ease_progress = ease_out_cubic(reset_note_menu_anim_progress);
            var _alpha = _ease_progress;
            var _scale = 0.8 + 0.2 * _ease_progress;

            draw_set_color(c_black);
            draw_set_alpha(0.7 * _alpha);
            draw_rectangle(0, 0, room_width, room_height, false);

            var menu_w = 220 * _scale;
            var menu_h = 120 * _scale;
            var menu_x = room_width / 2;
            var menu_y = room_height / 2;
            var menu_x1 = menu_x - menu_w / 2;
            var menu_y1 = menu_y - menu_h / 2;
            
            draw_set_color(c_dkgray);
            draw_set_alpha(_alpha);
            draw_rectangle(menu_x1, menu_y1, menu_x1 + menu_w, menu_y1 + menu_h, false);

            
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
            draw_text_transformed(menu_x, menu_y1 + (10 * _scale), "Reset Note", 0.7 * _scale, 0.7 * _scale, 0);

            
            var _button_w = 80 * _scale;
            var _button_h = 20 * _scale;
            var _button_y = menu_y1 + 40 * _scale;

            
            var _reset_button_x = menu_x - 50 * _scale;
            var _reset_button_rect = [_reset_button_x - _button_w/2, _button_y - _button_h/2, _reset_button_x + _button_w/2, _button_y + _button_h/2];
            var _reset_on = get_reset_note_value("reset", 0);
            var _reset_text = "Reset: " + (_reset_on ? "On" : "Off");
            draw_set_color(get_reset_note_value("reset", 0) ? c_lime : c_gray);
            draw_rectangle(_reset_button_rect[0], _reset_button_rect[1], _reset_button_rect[2], _reset_button_rect[3], false);
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(_reset_button_x, _button_y, _reset_text, 0.5 * _scale, 0.5 * _scale, 0);

            
            var _stop_button_x = menu_x + 50 * _scale;
            var _stop_button_rect = [_stop_button_x - _button_w/2, _button_y - _button_h/2, _stop_button_x + _button_w/2, _button_y + _button_h/2];
            var _stop_on = get_reset_note_value("stop", 0);
            var _stop_text = "Stop: " + (_stop_on ? "On" : "Off");
            draw_set_color(get_reset_note_value("stop", 0) ? c_lime : c_gray);
            draw_rectangle(_stop_button_rect[0], _stop_button_rect[1], _stop_button_rect[2], _stop_button_rect[3], false);
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(_stop_button_x, _button_y, _stop_text, 0.5 * _scale, 0.5 * _scale, 0);

            
            var _exit_button_y = menu_y1 + menu_h - 20 * _scale;
            var _exit_button_rect = [menu_x - 30 * _scale, _exit_button_y - 10 * _scale, menu_x + 30 * _scale, _exit_button_y + 10 * _scale];
            draw_set_color(c_gray);
            draw_rectangle(_exit_button_rect[0], _exit_button_rect[1], _exit_button_rect[2], _exit_button_rect[3], false);
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(menu_x, _exit_button_y, "Exit", 0.5 * _scale, 0.5 * _scale, 0);

            draw_set_alpha(1.0);
        }
    break;
        
    case EEditorMode.TEST:
        var _c_background_test = make_color_rgb(18, 18, 22);
        var _c_lane_dark_test = make_color_rgb(25, 25, 30);
        var _c_lane_light_test = make_color_rgb(32, 32, 38);
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
            draw_set_color(_lane_bg_color);
            draw_rectangle(32, 0, 64, room_height, false); 

            var _time_at_top = current_chart_position - ((_playhead_y_test - _lane.current_y) / pixels_per_second);
            var _time_at_bottom = current_chart_position - ((_playhead_y_test - room_height - _lane.current_y) / pixels_per_second);

            var _start_beat = floor(_time_at_bottom / sec_per_beat);
            var _end_beat = ceil(_time_at_top / sec_per_beat);

            for (var b = _start_beat; b <= _end_beat; b += 1 / snap_division) {
                if (b < 0) continue;
                var _beat_time = b * sec_per_beat;
                var _draw_y = _playhead_y_test - (_beat_time - current_chart_position) * pixels_per_second;
                
                if (b == floor(b)) { draw_set_color(make_color_rgb(60, 60, 60)); }
                else { draw_set_color(make_color_rgb(45, 45, 45)); }
                draw_line(32, _draw_y, 64, _draw_y); 
            }

            var _receptor_scale = _lane.receptor_scale;
            draw_sprite_ext(SprNote, _lane.sprite_index, 48, _playhead_y_test, _receptor_scale, _receptor_scale, 0, c_white, 0.25); 
            if (_lane.highlight_alpha > 0) {
                draw_sprite_ext(SprNote, _lane.sprite_index, 48, _playhead_y_test, _receptor_scale, _receptor_scale, 0, c_white, _lane.highlight_alpha);
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
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        draw_text(20, 20, "Score: " + string(gameplay_score));
        draw_set_halign(fa_right);
        var _combo_scale = gameplay_combo_scale;
        draw_text_transformed(room_width - 20, 20, "Combo: " + string(gameplay_combo), _combo_scale, _combo_scale, 0);
        
        if (judgement_alpha > 0) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            draw_set_color(judgement_color);
            draw_set_alpha(judgement_alpha);
            draw_text_transformed(room_width/2, room_height/2 - 20, judgement_text, judgement_scale, judgement_scale, 0);
            
            if (judgement_text != "MISS") {
                var _offset_str = string_format(judgement_offset_ms, 1, 0) + "ms";
                var _offset_color = (judgement_offset_ms < 0) ? c_aqua : c_orange;
                draw_set_color(_offset_color);
                draw_text_transformed(room_width/2, room_height/2 + 20, _offset_str, judgement_scale * 0.7, judgement_scale * 0.7, 0);
            }
            
            draw_set_alpha(1);
        }
        
        if (countdown > 0) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            var _countdown_scale = 1 + (ceil(countdown) - countdown);
            var _text = string(ceil(countdown));
            if (ceil(countdown) <= 0) _text = "GO!";
            draw_text_transformed(room_width/2, room_height/2, _text, _countdown_scale, _countdown_scale, 0);
        }
    break;
}

