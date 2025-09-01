cleanup_effect_surfaces();

for (var i = 0; i < array_length(lanes); i++) {
    if (surface_exists(lanes[i].surface)) {
        surface_free(lanes[i].surface);
        lanes[i].surface = -1;
    }
}

if (song_id != -1) {
    audio_stop_sound(song_id);
}