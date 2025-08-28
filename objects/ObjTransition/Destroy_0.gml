// Clean up the old surface if it exists
if (surface_exists(old_surface)) {
    surface_free(old_surface);
}
application_surface_draw_enable(true);