// Battle Enemy Draw Event

// Only draw if not dead or still playing death animation
if (!isDead) {
    // Draw the enemy sprite
    if (sprite_exists(sprite_index)) {
        var alpha = isDead ? 0.5 : 1.0;
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, alpha);
    }
    
    // Draw selection indicator if selected
    if (isSelected) {
        draw_set_color(c_yellow);
        draw_circle(x, y - sprite_height/2 - 10, 5, false);
        draw_set_color(c_white);
    }
}