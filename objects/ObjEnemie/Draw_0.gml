if (sprite_exists(sprite_index)) {
    draw_sprite_ext(sprite_index, image_index, drawX, drawY, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

if (debugVision) {
    draw_set_alpha(0.2);
    var visionColor = (playerDetected || followerDetected) ? c_red : c_yellow;
    draw_set_color(visionColor);
    
    var leftAngle = spriteDir - visionAngle / 2;
    var rightAngle = spriteDir + visionAngle / 2;
    
    var leftX = x + lengthdir_x(maxRayDistance, leftAngle);
    var leftY = y + lengthdir_y(maxRayDistance, leftAngle);
    var rightX = x + lengthdir_x(maxRayDistance, rightAngle);
    var rightY = y + lengthdir_y(maxRayDistance, rightAngle);
    
    draw_triangle(x, y, leftX, leftY, rightX, rightY, false);
    
    draw_set_alpha(0.8);
    
    for (var i = 0; i < array_length(raycastResults); i++) {
        var ray = raycastResults[i];
        
        if (ray.hitTarget != noone) {
            draw_set_color(c_red);
        } else if (ray.hitWall) {
            draw_set_color(c_orange);
        } else {
            draw_set_color(c_lime);
        }
        
        draw_line(x, y, ray.endX, ray.endY);
        
        if (ray.hitTarget != noone) {
            draw_set_color(c_red);
            draw_circle(ray.endX, ray.endY, 3, false);
        } else if (ray.hitWall) {
            draw_set_color(c_orange);
            draw_circle(ray.endX, ray.endY, 2, false);
        }
    }
    
    draw_set_alpha(1);
    draw_set_color(c_white);
}