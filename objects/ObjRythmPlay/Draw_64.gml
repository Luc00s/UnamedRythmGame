// ObjRythmPlay Draw_64 - GUI layer drawing (exact duplication of original)
draw_set_font(fn1);

// Draw countdown if game hasn't started yet
if (!game_started) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    
    var _text = "Press SPACE to start\nPress ESC to reset\n\nControls: D F J K";
    if (chart_filename != "") {
        _text = "Chart: " + filename_name(chart_filename) + "\n\n" + _text;
    }
    
    draw_text(room_width / 2, room_height / 2, _text);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    return;
}

// Draw countdown during game start
if (countdown > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    
    var _countdown_text = "";
    if (countdown > 2) _countdown_text = "3";
    else if (countdown > 1) _countdown_text = "2";  
    else if (countdown > 0) _countdown_text = "1";
    else _countdown_text = "GO!";
    
    var _scale = 2.0;
    draw_text_transformed(room_width / 2, room_height / 2, _countdown_text, _scale, _scale, 0);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Draw score and combo
draw_set_color(c_white);
draw_text(10, 10, "Score: " + string(gameplay_score));
draw_text(10, 30, "Combo: " + string(gameplay_combo));

// Draw BPM and song info
draw_text(10, room_height - 50, "BPM: " + string(bpm));
if (chart_filename != "") {
    draw_text(10, room_height - 30, "Chart: " + filename_name(chart_filename));
}

// Draw pause indicator
if (game_paused) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text(room_width / 2, room_height / 4, "PAUSED\nPress SPACE to resume");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Draw judgement
if (judgement_alpha > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(judgement_color);
    draw_set_alpha(judgement_alpha);
    
    var _judgment_y = room_height / 2 + 100;
    draw_text_transformed(room_width / 2, _judgment_y, judgement_text, judgement_scale, judgement_scale, 0);
    
    // Draw timing offset
    if (abs(judgement_offset_ms) > 0.1) {
        var _offset_text = string_format(judgement_offset_ms, 0, 0) + "ms";
        if (judgement_offset_ms > 0) _offset_text = "+" + _offset_text;
        draw_text(room_width / 2, _judgment_y + 30, _offset_text);
    }
    
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Draw controls help
draw_set_color(c_gray);
draw_text(room_width - 200, 10, "SPACE: Play/Pause");
draw_text(room_width - 200, 30, "ESC: Reset");
draw_text(room_width - 200, 50, "F5: Load Chart");

// Draw song progress bar
if (song_length > 0) {
    var _bar_x = 50;
    var _bar_y = room_height - 20;
    var _bar_width = room_width - 100;
    var _bar_height = 4;
    
    var _progress = current_chart_position / song_length;
    _progress = clamp(_progress, 0, 1);
    
    draw_set_color(c_dkgray);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_height, false);
    
    draw_set_color(c_white);
    draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_width * _progress), _bar_y + _bar_height, false);
    
    // Draw time
    var _current_time = floor(current_chart_position);
    var _total_time = floor(song_length);
    var _time_text = string(_current_time) + " / " + string(_total_time);
    draw_text(_bar_x + _bar_width + 10, _bar_y - 5, _time_text);
}