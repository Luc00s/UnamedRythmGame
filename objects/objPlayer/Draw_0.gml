// Suavização das coordenadas de desenho
if (jumpState == "none") {
    drawX = lerp(drawX, x, spriteCatchupFactor);
    drawY = lerp(drawY, y, spriteCatchupFactor);
} else {
    drawX = lerp(drawX, x, spriteCatchupFactor);
}

// Only draw normal sprite when NOT in battle mode OR when fully landed in battle
var shouldDrawNormalSprite = false;

if (instance_exists(objBattleControl) && objBattleControl.battleBoxActive) {
    // In battle mode: only draw normal sprite when landed (not preparing, jumping, or exiting)
    if (jumpState == "landed" || (jumpState == "none" && battleBoxIndex == -1)) {
        shouldDrawNormalSprite = true;
    }
} else {
    // Outside battle mode: always draw normal sprite
    shouldDrawNormalSprite = true;
}

if (shouldDrawNormalSprite && sprite_exists(sprite_index)) {
    draw_sprite_ext(sprite_index, image_index, drawX, drawY, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}