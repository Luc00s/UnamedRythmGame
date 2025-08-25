shaderTime += 1.0 / room_speed;

var newWidth = sprite_get_width(sprite_index) * abs(image_xscale);
var newHeight = sprite_get_height(sprite_index) * abs(image_yscale);

if (newWidth != surfaceWidth || newHeight != surfaceHeight) {
    surfaceWidth = newWidth;
    surfaceHeight = newHeight;
    createWaterSurface();
    createBackgroundSurface();
    createOutlineSurface();
    createTileMaskSurface();
}

if (!surface_exists(waterSurface)) {
    createWaterSurface();
}
if (!surface_exists(backgroundSurface)) {
    createBackgroundSurface();
}
if (!surface_exists(outlineSurface)) {
    createOutlineSurface();
}
if (!surface_exists(tileMaskSurface)) {
    createTileMaskSurface();
    tileMaskValid = false;
}
if (x != lastWaterX || y != lastWaterY || 
    image_xscale != lastWaterScaleX || image_yscale != lastWaterScaleY) {
    tileMaskValid = false;
    lastWaterX = x;
    lastWaterY = y;
    lastWaterScaleX = image_xscale;
    lastWaterScaleY = image_yscale;
}