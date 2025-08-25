//Smooth drawing coordinates
drawX = lerp(drawX, x, spriteCatchupFactor);
drawY = lerp(drawY, y, spriteCatchupFactor);

//Draw the follower
if(sprite_exists(sprite_index)) {
    draw_sprite_ext(sprite_index, image_index, drawX, drawY, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}