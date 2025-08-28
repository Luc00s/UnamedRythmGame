if (transition_active && erase_amount < 1) {
    erase_amount += erase_speed;
    if (erase_amount >= 1) {
        erase_amount = 1;

        if (surface_exists(old_surface)) {
            surface_free(old_surface);
            old_surface = -1;
        }
		instance_destroy()
        transition_active = false;
    }
}