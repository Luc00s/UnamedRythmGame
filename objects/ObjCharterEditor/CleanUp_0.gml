
/// @description Clean up all surfaces to prevent memory leaks

if (surface_exists(song_list_surface)) {
    surface_free(song_list_surface);
}

if (surface_exists(script_note_menu_scroll_list.surface)) {
    surface_free(script_note_menu_scroll_list.surface);
}

for (var i = 0; i < array_length(lanes); i++) {
    if (surface_exists(lanes[i].surface)) {
        surface_free(lanes[i].surface);
    }
}

cleanup_effect_surfaces();
