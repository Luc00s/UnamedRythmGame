//Suavizando as coordenadas desenhadas (but not during jump)
if (jumpState == "none") {
    drawX = lerp(drawX, x, spriteCatchupFactor);
    drawY = lerp(drawY, y, spriteCatchupFactor);
} else {
    drawX = lerp(drawX, x, spriteCatchupFactor);
    // drawY is controlled by jump physics
}

//Me desenhando
if(sprite_exists(sprite_index)) draw_sprite_ext(sprite_index, image_index, drawX, drawY, image_xscale, image_yscale, image_angle, image_blend, image_alpha);