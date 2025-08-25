enum EEditorMode {
    EDIT,
    TEST
}
editor_mode = EEditorMode.EDIT;
enum EEditorView {
	NORMAL,
	EFFECTS
}
editor_view = EEditorView.NORMAL;

surface_resize(application_surface, global.data.screen.width*3, global.data.screen.height*3);
window_set_size(global.data.screen.width*3, global.data.screen.height*3);
window_center();

#macro UI_COLOR_BACKGROUND make_color_rgb(18, 18, 22)
#macro UI_COLOR_LANE_DARK make_color_rgb(25, 25, 30)
#macro UI_COLOR_LANE_LIGHT make_color_rgb(32, 32, 38)
#macro UI_COLOR_BEAT_LINE make_color_rgb(60, 60, 60)
#macro UI_COLOR_SUB_BEAT_LINE make_color_rgb(45, 45, 45)
#macro UI_COLOR_PLAYHEAD c_red
#macro UI_COLOR_TEXT c_white
#macro UI_COLOR_TEXT_DIM c_gray
#macro UI_COLOR_HIGHLIGHT c_yellow
#macro UI_COLOR_PANEL_BG make_color_rgb(10, 10, 10)
#macro UI_COLOR_SELECTION c_aqua
#macro UI_COLOR_REPEL make_color_rgb(138, 43, 226)
#macro UI_COLOR_MOVE c_orange
#macro UI_COLOR_SCALE c_green
#macro UI_COLOR_SCRIPT c_purple
#macro UI_COLOR_RESET c_red

#macro UI_LANE_WIDTH 32
#macro UI_MENU_WIDTH 220
#macro UI_MENU_HEIGHT 120
#macro UI_MENU_PADDING 10
#macro UI_MENU_SPACING 8
#macro UI_MENU_FIELD_HEIGHT 20
#macro UI_BUTTON_WIDTH 50
#macro UI_BUTTON_HEIGHT 20


history = [];
history_index = 0;
history_max_size = 200; 


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
snap_division = 4;
hold_note_previews = [-1, -1, -1, -1];
enum ENotePlacementType { NORMAL, REPEL, MOVE, SCALE, SCRIPT, RESET }
note_placement_type = ENotePlacementType.NORMAL;
linking_note_from_uid = -1;


selected_notes = [];
is_box_selecting = false;
box_select_x1 = 0;
box_select_y1 = 0;
box_select_y1_chart = 0;
hovered_note_index = -1;
hovered_part = ""; 
is_move_note_menu_open = false;
is_scale_note_menu_open = false;
is_script_note_menu_open = false;
is_flash_effect_menu_open = false;
is_shake_effect_menu_open = false;
is_spin_effect_menu_open = false;
is_wave_lane_menu_open = false;
is_zoom_effect_menu_open = false;
is_threed_effect_menu_open = false;
is_reset_note_menu_open = false;
move_note_menu_target_note_index = -1;
scale_note_menu_target_note_index = -1;
script_note_menu_target_note_index = -1;
reset_note_menu_target_note_index = -1;
active_move_menu_input = noone;
active_scale_menu_input = noone;
scale_note_menu_fields = {
    x_scale: { 
        label: "XScale",
        get_value: method(self, function() { return get_scale_note_value("x_scale", 1); }),
        set_value: method(self, function(val) { set_scale_note_value("x_scale", val); })
    },
    y_scale: { 
        label: "YScale",
        get_value: method(self, function() { return get_scale_note_value("y_scale", 1); }),
        set_value: method(self, function(val) { set_scale_note_value("y_scale", val); })
    },
    scale_duration: { 
        label: "Time",
        get_value: method(self, function() { return get_scale_note_value("scale_duration", 1); }),
        set_value: method(self, function(val) { set_scale_note_value("scale_duration", val); })
    },
    scale_easing: { 
        label: "Easing",
        get_value: method(self, function() { return get_scale_note_value("scale_easing", 0); }),
        set_value: method(self, function(val) { set_scale_note_value("scale_easing", val); })
    },
    spin: {
        label: "SpinSpeed",
        get_value: method(self, function() { return get_scale_note_value("spin", 360); }),
        set_value: method(self, function(val) { set_scale_note_value("spin", val); })
    },
    angle: {
        label: "Angle",
        get_value: method(self, function() { return get_scale_note_value("angle", 0); }),
        set_value: method(self, function(val) { set_scale_note_value("angle", val); })
    }
};
move_note_menu_fields = {
    lane_x_movement: { 
        label: "Move X",
        get_value: method(self, function() { return get_move_note_value("lane_x_movement", 0); }),
        set_value: method(self, function(val) { set_move_note_value("lane_x_movement", val); })
    },
    lane_y_movement: { 
        label: "Move Y",
        get_value: method(self, function() { return get_move_note_value("lane_y_movement", 0); }),
        set_value: method(self, function(val) { set_move_note_value("lane_y_movement", val); })
    },
    movement_duration: { 
        label: "Time",
        get_value: method(self, function() { return get_move_note_value("movement_duration", 1); }),
        set_value: method(self, function(val) { set_move_note_value("movement_duration", val); })
    }
};
move_note_menu_anim_progress = 0;
scale_note_menu_anim_progress = 0;
script_note_menu_anim_progress = 0;
flash_effect_menu_anim_progress = 0;
shake_effect_menu_anim_progress = 0;
spin_effect_menu_anim_progress = 0;
wave_lane_menu_anim_progress = 0;
zoom_effect_menu_anim_progress = 0;
threed_effect_menu_anim_progress = 0;
reset_note_menu_anim_progress = 0;
script_note_menu_fields = {
    easing: {
        label: "Easing",
        get_value: method(self, function() { return get_script_note_value("easing", 0); }),
        set_value: method(self, function(val) { set_script_note_value("easing", val); })
    }
};

flash_effect_menu_fields = {
    time: {
        label: "Time",
        get_value: method(self, function() { return get_script_note_value("time", 1); }),
        set_value: method(self, function(val) { set_script_note_value("time", val); })
    },
    intensity: {
        label: "Intensity",
        get_value: method(self, function() { return get_script_note_value("intensity", 1); }),
        set_value: method(self, function(val) { set_script_note_value("intensity", val); })
    }
};

shake_effect_menu_fields = {
    time: {
        label: "Time",
        get_value: method(self, function() { return get_script_note_value("time", 1); }),
        set_value: method(self, function(val) { set_script_note_value("time", val); })
    },
    magnitude: {
        label: "Magnitude",
        get_value: method(self, function() { return get_script_note_value("magnitude", 5); }),
        set_value: method(self, function(val) { set_script_note_value("magnitude", val); })
    }
};

spin_effect_menu_fields = {
    duration: {
        label: "Duration",
        get_value: method(self, function() { return get_script_note_value("duration", 1); }),
        set_value: method(self, function(val) { set_script_note_value("duration", val); })
    },
    speed: {
        label: "Speed",
        get_value: method(self, function() { return get_script_note_value("speed", 360); }),
        set_value: method(self, function(val) { set_script_note_value("speed", val); })
    }
};

reset_note_menu_fields = {
    reset: {
        label: "Reset",
        get_value: method(self, function() { return get_reset_note_value("reset", 0); }),
        set_value: method(self, function(val) { set_reset_note_value("reset", val); })
    },
    stop: {
        label: "Stop",
        get_value: method(self, function() { return get_reset_note_value("stop", 0); }),
        set_value: method(self, function(val) { set_reset_note_value("stop", val); })
    }
};

wave_lane_menu_fields = {
    time: {
        label: "Time",
        get_value: method(self, function() { return get_script_note_value("time", 1); }),
        set_value: method(self, function(val) { set_script_note_value("time", val); })
    },
    intensity: {
        label: "Intensity",
        get_value: method(self, function() { return get_script_note_value("intensity", 1); }),
        set_value: method(self, function(val) { set_script_note_value("intensity", val); })
    },
    frequency: {
        label: "Frequency",
        get_value: method(self, function() { return get_script_note_value("frequency", 10); }),
        set_value: method(self, function(val) { set_script_note_value("frequency", val); })
    }
};

zoom_effect_menu_fields = {
    time: {
        label: "Time",
        get_value: method(self, function() { return get_script_note_value("time", 1); }),
        set_value: method(self, function(val) { set_script_note_value("time", val); })
    },
    zoom: {
        label: "Zoom",
        get_value: method(self, function() { return get_script_note_value("zoom", 1.5); }),
        set_value: method(self, function(val) { set_script_note_value("zoom", val); })
    }
};

threed_effect_menu_fields = {
    xangle: {
        label: "XAngle",
        get_value: method(self, function() { return get_script_note_value("xangle", 0); }),
        set_value: method(self, function(val) { set_script_note_value("xangle", val); })
    },
    yangle: {
        label: "YAngle",
        get_value: method(self, function() { return get_script_note_value("yangle", 0); }),
        set_value: method(self, function(val) { set_script_note_value("yangle", val); })
    },
    zangle: {
        label: "ZAngle",
        get_value: method(self, function() { return get_script_note_value("zangle", 0); }),
        set_value: method(self, function(val) { set_script_note_value("zangle", val); })
    },
    time: {
        label: "Time",
        get_value: method(self, function() { return get_script_note_value("time", 1); }),
        set_value: method(self, function(val) { set_script_note_value("time", val); })
    }
};


script_note_menu_scroll_list = {
    surface: -1,
    surface_scale: 2,
    items: [],
    item_height: 12,
    view_height: 80, 
    scroll_y: 0,
    target_scroll_y: 0,
    selected_index: 0,
    is_dragging: false,
    drag_start_y: 0,
    drag_start_scroll_y: 0
};

script_note_menu_scroll_list.items = [];

array_push(script_note_menu_scroll_list.items, "FlashEffect");
array_push(script_note_menu_scroll_list.items, "ShakeEffect");
array_push(script_note_menu_scroll_list.items, "SpinEffect");
array_push(script_note_menu_scroll_list.items, "WaveLane");
array_push(script_note_menu_scroll_list.items, "ZoomEffect");
array_push(script_note_menu_scroll_list.items, "3d");

for (var i = 0; i <= 100; i++) {
    array_push(script_note_menu_scroll_list.items, string(i));
}
dragged_note_index = -1;
dragged_part = "";
drag_mode = "";
original_drag_positions = [];
drag_start_mouse_time = 0;
drag_start_mouse_lane = 0;
clipboard = [];


is_dragging_timeline = false;
drag_start_y = 0;
drag_start_chart_pos = 0; 


pixels_per_second = 320;
var _num_lanes = 4;
var _lane_width = 32;
var _spacing = 0;
var _total_width = (_num_lanes * _lane_width) + ((_num_lanes - 1) * _spacing);
var _start_x = (room_width - _total_width) / 2;


is_scrubbing = false;
scrubber_x = _start_x - 15; 
scrubber_y_start = 50;
scrubber_height = room_height - 100;
scrubber_handle_y = scrubber_y_start;
scrubber_handle_height = 10;

lanes = [
    { key: ord("D"), x: _start_x + (_lane_width/2),                      sprite_index: 0, hold_body_index: 0, hold_tail_index: 4, highlight_alpha: 0, receptor_scale: 1, current_x: _start_x + (_lane_width/2), current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2), settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
    { key: ord("F"), x: _start_x + (_lane_width/2) + _lane_width + _spacing, sprite_index: 1, hold_body_index: 1, hold_tail_index: 5, highlight_alpha: 0, receptor_scale: 1, current_x: _start_x + (_lane_width/2) + _lane_width + _spacing, current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2) + _lane_width + _spacing, settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
    { key: ord("J"), x: _start_x + (_lane_width/2) + 2*(_lane_width + _spacing), sprite_index: 2, hold_body_index: 2, hold_tail_index: 6, highlight_alpha: 0, receptor_scale: 1, current_x: _start_x + (_lane_width/2) + 2*(_lane_width + _spacing), current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2) + 2*(_lane_width + _spacing), settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
    { key: ord("K"), x: _start_x + (_lane_width/2) + 3*(_lane_width + _spacing), sprite_index: 3, hold_body_index: 3, hold_tail_index: 7, highlight_alpha: 0, receptor_scale: 1, current_x: _start_x + (_lane_width/2) + 3*(_lane_width + _spacing), current_y: 0, active_effects: [], settled_x: _start_x + (_lane_width/2) + 3*(_lane_width + _spacing), settled_y: 0, surface: -1, surface_scale_x: 1, surface_scale_y: 1, target_scale_x: 1, target_scale_y: 1, scale_progress: -1, scale_duration: 0, scale_easing_function: 0, surface_angle: 0, start_angle: 0, target_angle: 0, angle_progress: -1, angle_duration: 0, angle_easing_function: 0, pitch: 0, yaw: 0, roll: 0, start_pitch: 0, start_yaw: 0, start_roll: 0, target_pitch: 0, target_yaw: 0, target_roll: 0, threed_progress: -1, threed_duration: 0, threed_easing_function: 0 },
];
effects_lane = { x: _start_x + 4*(_lane_width + _spacing), width: _lane_width };


var _surface_width = 32;
var _surface_height = room_height;
for (var i = 0; i < array_length(lanes); i++) {

    if (!surface_exists(lanes[i].surface)) {

        lanes[i].surface = surface_create(_surface_width, _surface_height);

    }

}
effects_lane = { x: _start_x + 4*(_lane_width + _spacing), width: _lane_width };


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
song_list_scroll_y = 0;
song_list_target_scroll_y = 0;
song_list_item_height = 12;
song_list_view_height = 8 * song_list_item_height;
song_list_surface = -1; 
song_list_surface_scale = 2; 
song_list_anim_target = 0;
song_list_anim_progress = 0;
is_dragging_scrollbar = false;
scrollbar_drag_start_y = 0;
scrollbar_drag_start_scroll_y = 0;


gui_anim_progress = 0;
gui_anim_target = 0;
gui_arrow_current_x = 88;
gui_arrow_current_y = 45;
active_input = noone;
input_buffer = "";
input_cursor_blink = 0;
backspace_delay = 0;
input_fx_scale = 1;
input_fx_char_index = -1;
active_input_original_value = 0;
input_fields = {
    bpm: { 
        rect: [10, 38, 80, 52], 
        label: "BPM", 
		delay: 0.0,
        get_value: method(self, function() { return bpm; }),
        set_value: method(self, function(val) { bpm = val; sec_per_beat = 60.0 / bpm; chart_data.bpm = val; })
    },
    audio_offset: { 
        rect: [10, 73, 80, 87], 
        label: "Audio Offset",
		delay: 0.2,
        get_value: method(self, function() { return audio_offset; }),
        set_value: method(self, function(val) { audio_offset = val; chart_data.audio_offset = val; })
    },
    chart_offset: { 
        rect: [10, 108, 80, 122], 
        label: "Chart Offset",
		delay: 0.4,
        get_value: method(self, function() { return chart_offset; }),
        set_value: method(self, function(val) { chart_offset = val; })
    },
    pixels_per_second: { 
        rect: [10, 143, 80, 157], 
        label: "Scroll Speed",
		delay: 0.6,
        get_value: method(self, function() { return pixels_per_second; }),
        set_value: method(self, function(val) { pixels_per_second = val; })
    }
};

easing_function_names = [
    "Linear", "InSine", "OutSine", "InOutSine",
    "InQuad", "OutQuad", "InOutQuad", "InCubic",
    "OutCubic", "InOutCubic", "InBack", "OutBack",
    "InCirc", "OutCirc"
];


gameplay_score = 0;
gameplay_combo = 0;
gameplay_combo_scale = 1;
countdown = 3;
test_start_time = 0;
countdown_start_realtime = 0;
song_start_realtime = 0;
song_start_chart_position = 0;
enum ENoteState { WAITING, HIT, MISSED, HOLDING, INACTIVE_REPULSE, REPELLING, CHAIN_BROKEN }
window_perfect = 0.04;
window_great = 0.08;
window_meh = 0.12;
judgement_text = "";
judgement_offset_ms = 0;
judgement_color = c_white;
judgement_alpha = 0;
judgement_scale = 1;


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


get_move_note_value = function(field_name, default_val) {
    if (move_note_menu_target_note_index == -1) return default_val;
    var _target_note = chart_data.notes[move_note_menu_target_note_index];
    return variable_struct_exists(_target_note, field_name) ? _target_note[$ field_name] : default_val;
}

set_move_note_value = function(field_name, val) {
    if (move_note_menu_target_note_index == -1) return;
    chart_data.notes[move_note_menu_target_note_index][$ field_name] = val;
    commit_action(); 
}

get_scale_note_value = function(field_name, default_val) {
    if (scale_note_menu_target_note_index == -1) return default_val;
    var _target_note = chart_data.notes[scale_note_menu_target_note_index];
    return variable_struct_exists(_target_note, field_name) ? _target_note[$ field_name] : default_val;
}

set_scale_note_value = function(field_name, val) {
    if (scale_note_menu_target_note_index == -1) return;
    chart_data.notes[scale_note_menu_target_note_index][$ field_name] = val;
    commit_action(); 
}

get_script_note_value = function(field_name, default_val) {
    if (script_note_menu_target_note_index == -1) return default_val;
    var _target_note = chart_data.notes[script_note_menu_target_note_index];
    return variable_struct_exists(_target_note, field_name) ? _target_note[$ field_name] : default_val;
}

set_script_note_value = function(field_name, val) {
    if (script_note_menu_target_note_index == -1) return;
    chart_data.notes[script_note_menu_target_note_index][$ field_name] = val;
    commit_action(); 
}

get_reset_note_value = function(field_name, default_val) {
    if (reset_note_menu_target_note_index == -1) return default_val;
    var _target_note = chart_data.notes[reset_note_menu_target_note_index];
    return variable_struct_exists(_target_note, field_name) ? _target_note[$ field_name] : default_val;
}

set_reset_note_value = function(field_name, val) {
    if (reset_note_menu_target_note_index == -1) return;
    chart_data.notes[reset_note_menu_target_note_index][$ field_name] = val;
    commit_action(); 
}


save_active_input = function() {
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

commit_action = function() {
    if (history_index < array_length(history) - 1) {
        array_resize(history, history_index + 1);
    }
    array_push(history, json_stringify(chart_data));
    history_index++;
    
    if (array_length(history) > history_max_size) {
        array_delete(history, 0, 1);
        history_index--;
    }
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

undo = function() {
    if (history_index > 0) {
        history_index--;
        chart_data = json_parse(history[history_index]);
        bpm = chart_data.bpm;
        audio_offset = chart_data.audio_offset;
        sec_per_beat = 60.0 / bpm;
        ensure_note_properties(); 
        selected_notes = [];
    }
}

redo = function() {
    if (history_index < array_length(history) - 1) {
        history_index++;
        chart_data = json_parse(history[history_index]);
        bpm = chart_data.bpm;
        audio_offset = chart_data.audio_offset;
        sec_per_beat = 60.0 / bpm;
        ensure_note_properties();
        selected_notes = [];
    }
}

history = [json_stringify(chart_data)];

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
    if (editor_mode == EEditorMode.EDIT) {
        return room_height * 0.8;
    } else { 
        return room_height * 0.9;
    }
}

get_lane_at_x = function(_x) {
    var _closest_lane_index = 0;
    var _min_dist = infinity;
    for (var i = 0; i < array_length(lanes); i++) {
        var _dist = abs(_x - lanes[i].x);
        if (_dist < _min_dist) {
            _min_dist = _dist;
            _closest_lane_index = i;
        }
    }
    return _closest_lane_index;
}

get_lane_index = function(_key_code) {
    for (var i = 0; i < array_length(lanes); i++) {
        if (lanes[i].key == _key_code) return i;
    }
    return -1;
}

check_collision = function(_lane, _start_time, _end_time, _exclude_indices, _type) {
    var visual_buffer = (17 / 2) / pixels_per_second;
    var check_interval_start = _start_time - visual_buffer;
    var check_interval_end = _end_time + visual_buffer;

    for (var i = 0; i < array_length(chart_data.notes); i++) {
        if (array_contains(_exclude_indices, i)) continue;
        
        var _other = chart_data.notes[i];
        if (_other.lane != _lane) continue;
        
		var is_placing_in_normal_view = (_type < 3);
		var is_other_in_normal_view = (_other.type < 3);

		if (is_placing_in_normal_view != is_other_in_normal_view) continue; 

        var other_interval_start = _other.timestamp - visual_buffer;
        var other_interval_end = _other.timestamp + ((_other.type == 1) ? _other.duration : 0) + visual_buffer;
        
        if (check_interval_start < other_interval_end && check_interval_end > other_interval_start) {
            return _other;
        }
    }
    return undefined;
}

check_exact_collision = function(_lane, _timestamp, _exclude_indices, _type) {
    var _check_snap_index = round((_timestamp / sec_per_beat) * snap_division);

    for (var i = 0; i < array_length(chart_data.notes); i++) {
        if (array_contains(_exclude_indices, i)) continue;
        
        var _other = chart_data.notes[i];
        if (_other.lane != _lane) continue;
        
				var is_placing_in_normal_view = (_type < 3);
		var is_other_in_normal_view = (_other.type < 3);
		if (is_placing_in_normal_view != is_other_in_normal_view) continue;

        var _other_start_snap_index = round((_other.timestamp / sec_per_beat) * snap_division);

        if (_other.type == 1) { 
            var _other_end_snap_index = round(((_other.timestamp + _other.duration) / sec_per_beat) * snap_division);
            if (_check_snap_index >= _other_start_snap_index && _check_snap_index <= _other_end_snap_index) {
                return _other;
            }
        } else { 
            if (_check_snap_index == _other_start_snap_index) {
                return _other;
            }
        }
    }
    return undefined;
}

create_note_struct = function(_lane_index, _start_time, _end_time, _allow_smart_placement = true) {
    var _duration = _end_time - _start_time;
    
    var _start_beat = _start_time / sec_per_beat;
    var _snapped_start_beat = round(_start_beat * snap_division) / snap_division;
    var _snapped_start_time = _snapped_start_beat * sec_per_beat;
    
    if (_snapped_start_time < 0) {
        return undefined;
    }
    
    var _is_hold = (_duration >= 0.02);
    var _type_to_place;
    
    switch (note_placement_type) {
        case ENotePlacementType.NORMAL: _type_to_place = _is_hold ? 1 : 0; break;
        case ENotePlacementType.REPEL: _type_to_place = 2; break;
        case ENotePlacementType.MOVE: _type_to_place = 3; break;
        case ENotePlacementType.SCALE: _type_to_place = 4; break;
		case ENotePlacementType.SCRIPT: _type_to_place = 5; break;
		case ENotePlacementType.RESET: _type_to_place = 6; break;
        default: _type_to_place = 0; break;
    }

    
    var _original_lane = _lane_index;
    var _found_spot = false;
    
    
    if (!check_exact_collision(_original_lane, _snapped_start_time, [], _type_to_place)) {
        _found_spot = true;
    } else if (_allow_smart_placement) {
        
        for (var i = 0; i < array_length(lanes); i++) {
            if (i == _original_lane) continue; 
            if (!check_exact_collision(i, _snapped_start_time, [], _type_to_place)) {
                _lane_index = i; 
                _found_spot = true;
                break;
            }
        }
    }
    
    if (!_found_spot) {
        return undefined; 
    }
    
    var _new_note;
    
    switch (note_placement_type) {
        case ENotePlacementType.NORMAL:
            if (editor_view != EEditorView.NORMAL) return undefined;
            if (!_is_hold) {
                _new_note = { 
                    type: 0, timestamp: _snapped_start_time, lane: _lane_index,
                    visual_timestamp: _snapped_start_time, visual_scale: 1.5, hit_state: ENoteState.WAITING,
                    visual_x: lanes[_lane_index].x,
                    uid: note_uid_counter++,
                    angle: 0,
                    spin_speed: 0,
                    spin_duration_remaining: 0,
                };
            } else {
                var _end_beat = _end_time / sec_per_beat;
                var _snapped_end_beat = round(_end_beat * snap_division) / snap_division;
                var _snapped_end_time = _snapped_end_beat * sec_per_beat;
                var _snapped_duration = max(sec_per_beat / snap_division, _snapped_end_time - _snapped_start_time);

                if (check_exact_collision(_lane_index, _snapped_start_time + _snapped_duration, [], _type_to_place)) {
                    return undefined; 
                }

                
                var _snapped_duration = max(sec_per_beat / snap_division, _snapped_end_time - _snapped_start_time);

                
                for (var j = 0; j < array_length(chart_data.notes); j++) {
                    var _existing_note = chart_data.notes[j];
                    if (_existing_note.lane == _lane_index && (_existing_note.type == 0 || _existing_note.type == 2)) {
                        if (_existing_note.timestamp > _snapped_start_time && _existing_note.timestamp < _snapped_start_time + _snapped_duration) {
                            return undefined; 
                        }
                    }
                }

                
                for (var j = 0; j < array_length(chart_data.notes); j++) {
                    var _existing_note = chart_data.notes[j];
                    if (_existing_note.lane == _lane_index && (_existing_note.type == 0 || _existing_note.type == 2)) {
                        if (_existing_note.timestamp > _snapped_start_time && _existing_note.timestamp < _snapped_start_time + _snapped_duration) {
                            return undefined; 
                        }
                    }
                }

                _new_note = { 
                    type: 1, timestamp: _snapped_start_time, duration: _snapped_duration, lane: _lane_index,
                    visual_timestamp: _snapped_start_time, visual_scale: 1.2, hit_state: ENoteState.WAITING,
                    visual_x: lanes[_lane_index].x,
                    uid: note_uid_counter++,
                    angle: 0,
                    spin_speed: 0,
                    spin_duration_remaining: 0,
                };
            }
            break;
        case ENotePlacementType.REPEL:
            if (editor_view != EEditorView.NORMAL) return undefined;
            if (_is_hold) return undefined;
            _new_note = {
                type: 2, timestamp: _snapped_start_time, lane: _lane_index,
                visual_timestamp: _snapped_start_time, visual_scale: 1.5, hit_state: ENoteState.WAITING,
                visual_x: lanes[_lane_index].x,
                uid: note_uid_counter++,
                next_repel_note_uid: -1,
                is_repel_chain_start: false,
                
                angle: 0,
                spin_speed: 0,
                spin_duration_remaining: 0,
                
            };
            break;
        case ENotePlacementType.MOVE:
            if (editor_view != EEditorView.EFFECTS) return undefined;
            if (_is_hold) return undefined;
            _new_note = { 
                type: 3, timestamp: _snapped_start_time, lane: _lane_index,
                visual_timestamp: _snapped_start_time, visual_scale: 1.5, hit_state: ENoteState.WAITING,
                visual_x: lanes[_lane_index].x,
                uid: note_uid_counter++,
				movement_duration: 1,
            };
            break;
        case ENotePlacementType.SCALE:
            if (editor_view != EEditorView.EFFECTS) return undefined;
            if (_is_hold) return undefined;
            _new_note = { 
                type: 4, timestamp: _snapped_start_time, lane: _lane_index,
                visual_timestamp: _snapped_start_time, visual_scale: 1.5, hit_state: ENoteState.WAITING,
                visual_x: lanes[_lane_index].x,
                uid: note_uid_counter++,
				x_scale: 1,
				y_scale: 1,
				scale_duration: 1,
				scale_easing: 0,
				spin: 0,
				angle: 0,
            };
            break;
		case ENotePlacementType.SCRIPT:
			if (editor_view != EEditorView.EFFECTS) return undefined;
			if (_is_hold) return undefined;
			_new_note = {
				type: 5, timestamp: _snapped_start_time, lane: _lane_index,
				visual_timestamp: _snapped_start_time, visual_scale: 1.5, hit_state: ENoteState.WAITING,
				visual_x: lanes[_lane_index].x,
				uid: note_uid_counter++,
			};
			break;
		case ENotePlacementType.RESET:
            if (editor_view != EEditorView.EFFECTS) return undefined;
            if (_is_hold) return undefined;
            _new_note = { 
                type: 6, timestamp: _snapped_start_time, lane: _lane_index,
                visual_timestamp: _snapped_start_time, visual_scale: 1.5, hit_state: ENoteState.WAITING,
                visual_x: lanes[_lane_index].x,
                uid: note_uid_counter++,
            };
            break;
    }

    return _new_note;
}

sort_chart = function() {
    array_sort(chart_data.notes, function(note_a, note_b) {
        return note_a.timestamp - note_b.timestamp;
    });
}

enter_edit_mode = function() {
    editor_mode = EEditorMode.EDIT;
    is_paused = true;
    audio_pause_sound(song_id);
    ensure_note_properties();
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

enter_test_mode = function() {
    editor_mode = EEditorMode.TEST;
    is_paused = false;
    test_start_time = target_chart_position;
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

show_judgement = function(_text, _offset_ms, _color) {
    judgement_text = _text;
    judgement_offset_ms = _offset_ms;
    judgement_color = _color;
    judgement_alpha = 1.5;
    judgement_scale = 1.5;
}

display_reset(0,1);

is_note_unlinked = function(_note_index) {
    var _notes = chart_data.notes;
    var _note = _notes[_note_index];
    
    
    if (variable_struct_exists(_note, "next_repel_note_uid") && _note.next_repel_note_uid != -1) {
        return false;
    }
    
    
    var _my_uid = _note.uid;
    for (var i = 0; i < array_length(_notes); i++) {
        if (i == _note_index) continue;
        var _other_note = _notes[i];
        if (variable_struct_exists(_other_note, "next_repel_note_uid") && _other_note.next_repel_note_uid == _my_uid) {
            return false;
        }
    }
    
    return true;
}

is_repel_chain_fully_selected = function(_start_note_index) {
    var _notes = chart_data.notes;
    if (!is_array(selected_notes) || array_length(selected_notes) == 0) {
        return false;
    }
    
    var _start_note = _notes[_start_note_index];
    var _head_uid = _start_note.uid;

    
    var _found_head = false;
    while (!_found_head) {
        var _previous_uid = -1;
        for (var i = 0; i < array_length(_notes); i++) {
            var _note = _notes[i];
            if (variable_struct_exists(_note, "next_repel_note_uid") && _note.next_repel_note_uid == _head_uid) {
                _previous_uid = _note.uid;
                break;
            }
        }
        
        if (_previous_uid != -1) {
            _head_uid = _previous_uid;
        } else {
            _found_head = true;
        }
    }
    
    
    var _current_uid = _head_uid;
    while (_current_uid != -1) {
        var _note_index_in_chain = get_note_index_by_uid(_current_uid);
        
        if (_note_index_in_chain == -1) {
            
            return false; 
        }
        
        if (!array_contains(selected_notes, _note_index_in_chain)) {
            return false; 
        }
        
        var _note_in_chain = _notes[_note_index_in_chain];
        _current_uid = variable_struct_exists(_note_in_chain, "next_repel_note_uid") 
                       ? _note_in_chain.next_repel_note_uid 
                       : -1;
    }
    
    return true; 
}
