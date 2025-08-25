
if (!surface_exists(waterSurface) || !surface_exists(backgroundSurface) || !surface_exists(outlineSurface) || !surface_exists(tileMaskSurface)) {
    exit;
}


function setCausticsUniforms(speedMultiplier = 1.0, intensityMultiplier = 1.0) {
    shader_set_uniform_f(u_color, causticsColor[0], causticsColor[1], causticsColor[2], causticsColor[3]);
    shader_set_uniform_f(u_caustics_frequency, causticsFrequency * intensityMultiplier);
    shader_set_uniform_f(u_compress, causticsCompress);
    shader_set_uniform_f(u_add_light, causticsAddLight * intensityMultiplier);
    shader_set_uniform_f(u_scale, causticsScale * intensityMultiplier);
    shader_set_uniform_f(u_caustics_speed, causticsSpeed * speedMultiplier);
    shader_set_uniform_f(u_x_angle, causticsXAngle);
    shader_set_uniform_f(u_y_angle, causticsYAngle);
    shader_set_uniform_f(u_refraction_ratio, causticsRefractionRatio * intensityMultiplier);
    shader_set_uniform_f(u_clear, causticsClear * intensityMultiplier);
    shader_set_uniform_f(u_surf_sinpowder, causticsSurfSinpowder);
    shader_set_uniform_f(u_surf_speed, causticsSurfSpeed * speedMultiplier);
    shader_set_uniform_f(u_surf_angle, causticsSurfAngle);
    shader_set_uniform_f(u_surf_magnitude, causticsSurfMagnitude);
    shader_set_uniform_f(u_s11, causticsS11);
    shader_set_uniform_f(u_sinpowder, causticsSinpowder);
    shader_set_uniform_f(u_flow_direction_x, causticsFlowDirectionX);
    shader_set_uniform_f(u_flow_direction_y, causticsFlowDirectionY);
    shader_set_uniform_f(u_flow_speed, causticsFlowSpeed * speedMultiplier);
}


function createTileMask() {
    
    if (tileMaskValid && surface_exists(tileMaskSurface)) {
        return; 
    }
    
    surface_set_target(tileMaskSurface);
    draw_clear_alpha(c_black, 0);
    
    
    shader_set(sh_white);
    
    
    var waterLeft = x;
    var waterTop = y;
    var waterRight = x + surfaceWidth;
    var waterBottom = y + surfaceHeight;
    
    
    with (objDualGridGround) {
        
        var groundLeft = 0;  
        var groundTop = 0;
        var groundRight = world_cols * cell_size;
        var groundBottom = world_rows * cell_size;
        
        if (groundRight <= waterLeft || groundLeft >= waterRight ||
            groundBottom <= waterTop || groundTop >= waterBottom) {
            continue; 
        }
        
        
        var startIX = max(1, floor(waterLeft / cell_size));
        var endIX = min(world_cols - 1, ceil(waterRight / cell_size));
        var startIY = max(1, floor(waterTop / cell_size)); 
        var endIY = min(world_rows - 1, ceil(waterBottom / cell_size));
        
        
        
        for (var ix = startIX; ix <= endIX; ix++) {
            for (var iy = startIY; iy <= endIY; iy++) {
                var idx = display_grid[# ix, iy];
                
                
                var dx = ix * cell_size - cell_half - cell_half;
                var dy = iy * cell_size - cell_half - cell_half;
                
                
                if (dx + cell_size > waterLeft && dx < waterRight && 
                    dy + cell_size > waterTop && dy < waterBottom) {
                    
                    
                    var tileSurfaceX = dx - waterLeft;
                    var tileSurfaceY = dy - waterTop;
                    
                    
                    var col = idx mod sheet_cols;
                    var row = idx div sheet_cols;
                    var sx = col * cell_size;
                    var sy = row * cell_size;
                    
                    
                    draw_sprite_part(
                        SprGrassTile,    
                        0,               
                        sx, sy,          
                        cell_size,       
                        cell_size,       
                        tileSurfaceX,    
                        tileSurfaceY     
                    );
                }
            }
        }
    }
    
    shader_reset();
    surface_reset_target();
    
    
    tileMaskValid = true;
}


var waterLeft = x;
var waterTop  = y;


var camera = view_camera[0];
var cam_x = camera_get_view_x(camera);
var cam_y = camera_get_view_y(camera);


var app_surf = application_surface;
var _appScale = surface_get_height(app_surf) / 213;





surface_set_target(backgroundSurface);
draw_clear_alpha(c_black, 0);
if (surface_exists(app_surf)) {
    var source_x = (waterLeft - cam_x) * _appScale;
    var source_y = (waterTop - cam_y) * _appScale;
    var source_w = surfaceWidth * _appScale;
    var source_h = surfaceHeight * _appScale;

    draw_surface_part_ext(
        app_surf,
        source_x, source_y,
        source_w, source_h,
        0, 0,
        1 / _appScale, 1 / _appScale,
        c_white, 1
    );
}
surface_reset_target();



createTileMask();



surface_set_target(waterSurface);
draw_clear_alpha(c_black, 1);


gpu_set_blendmode(bm_normal);
draw_sprite_ext(
    sprite_index, image_index,
    0, 0,
    abs(image_xscale), abs(image_yscale),
    image_angle,
    c_white, 1
);


gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
draw_surface(tileMaskSurface, 0, 0);


gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
draw_set_alpha(0.5);
draw_set_color(c_black);
draw_rectangle(0, 0, surfaceWidth, surfaceHeight, false);
draw_set_alpha(1);
draw_set_color(c_white);


gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
shader_set(sh_water);


shader_set_uniform_f(sh_water_u_time, shaderTime);
shader_set_uniform_f(sh_water_u_distortion_strength, 0.035); 
shader_set_uniform_f(sh_water_u_frequency, 7);               
shader_set_uniform_f(sh_water_u_speed, 1.8);                 
shader_set_uniform_f(sh_water_u_resolution, surfaceWidth, surfaceHeight);
shader_set_uniform_f(u_world_offset, x, y);


setCausticsUniforms();

draw_surface(backgroundSurface, 0, 0);
shader_reset();


gpu_set_blendmode_ext(bm_zero, bm_src_alpha);
draw_sprite_ext(
    sprite_index, image_index,
    0, 0,
    abs(image_xscale), abs(image_yscale),
    image_angle,
    c_white, 1
);


gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
draw_surface(tileMaskSurface, 0, 0);

gpu_set_blendmode(bm_normal);
surface_reset_target();


draw_surface(waterSurface, waterLeft, waterTop);




if (!surface_exists(distortedTemp)) {
    distortedTemp = surface_create(surfaceWidth, surfaceHeight);
}
if (!surface_exists(waterOverlaySurface)) {
    waterOverlaySurface = surface_create(surfaceWidth, surfaceHeight);
}


surface_set_target(distortedTemp);
draw_clear_alpha(c_black, 0);

shader_set(sh_water);
shader_set_uniform_f(sh_water_u_time, shaderTime);
shader_set_uniform_f(sh_water_u_distortion_strength, 0.008); 
shader_set_uniform_f(sh_water_u_frequency, 32);              
shader_set_uniform_f(sh_water_u_speed, 2.2);                 
shader_set_uniform_f(sh_water_u_resolution, surfaceWidth, surfaceHeight);
shader_set_uniform_f(u_world_offset, x, y);


setCausticsUniforms(1.25, 0.9); 
draw_surface(backgroundSurface, 0, 0);
shader_reset();
surface_reset_target();


surface_set_target(waterOverlaySurface);
draw_clear_alpha(c_black, 0);


gpu_set_blendmode(bm_normal);
draw_sprite_ext(
    sprite_index, image_index,
    0, 0,
    abs(image_xscale), abs(image_yscale),
    image_angle,
    c_white, 1
);


gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
draw_surface(tileMaskSurface, 0, 0);


gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
draw_surface(distortedTemp, 0, 0);


gpu_set_blendmode(bm_normal);
surface_reset_target();


draw_surface(waterOverlaySurface, waterLeft, waterTop);




if (!surface_exists(reflectionTemp)) {
    reflectionTemp = surface_create(surfaceWidth, surfaceHeight);
}
if (!surface_exists(maskedReflection)) {
    maskedReflection = surface_create(surfaceWidth, surfaceHeight);
}


surface_set_target(reflectionTemp);
draw_clear_alpha(c_black, 0);


var reflection_grid = ds_grid_create(2, 0);


with (parReflection) {
    var index = ds_grid_height(reflection_grid);
    ds_grid_resize(reflection_grid, 2, index + 1);
    ds_grid_set(reflection_grid, 0, index, id);
    ds_grid_set(reflection_grid, 1, index, depth);
}


ds_grid_sort(reflection_grid, 1, false);


for (var i = 0; i < ds_grid_height(reflection_grid); i++) {
    var inst_id = reflection_grid[# 0, i];
    with (inst_id) {
        if(sprite_exists(sprite_index)) {
            var use_draw_vars = variable_instance_exists(id, "drawX") && variable_instance_exists(id, "drawY") && variable_instance_exists(id, "facingDirection");
            
            var pCX = (use_draw_vars ? drawX : x) - other.x;
            var pCY = (use_draw_vars ? drawY : y) - other.y;
            var pW  = sprite_get_width(sprite_index);
            var pH  = sprite_get_height(sprite_index);
            var rX  = pCX;
            var rY  = pCY + (pH * abs(image_yscale)) / 2 + 10;
    
            if (rX > -pW*2 && rX < other.surfaceWidth + pW &&
                rY > -pH   && rY < other.surfaceHeight + pH) {
    
                gpu_set_blendmode(bm_normal);
                shader_set(sh_reflection);
                shader_set_uniform_f(other.u_time_reflection, other.shaderTime);
                shader_set_uniform_f(other.u_distortionStrength, other.distortionStrength);
                shader_set_uniform_f(other.u_waveSpeed, other.waveSpeed);
                shader_set_uniform_f(other.u_waveFrequency, other.waveFrequency);
    
                draw_sprite_ext(
                    sprite_index, image_index,
                    rX, rY - 2,
                    use_draw_vars ? image_xscale * facingDirection : image_xscale,
                    -abs(image_yscale),
                    -image_angle,
                    c_white,
                    1.0
                );
    
                shader_reset();
            }
        }
    }
}


ds_grid_destroy(reflection_grid);

surface_reset_target();


surface_set_target(maskedReflection);
draw_clear_alpha(c_black, 0);


gpu_set_blendmode(bm_normal);
draw_sprite_ext(
    sprite_index, image_index,
    0, 0,
    abs(image_xscale), abs(image_yscale),
    image_angle,
    c_white, 1
);


gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
draw_surface(tileMaskSurface, 0, 0);


gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
draw_set_alpha(.5)
draw_surface(reflectionTemp, 0, 0);


gpu_set_blendmode(bm_normal);
surface_reset_target();
draw_set_alpha(1)

draw_surface(maskedReflection, waterLeft, waterTop);



surface_set_target(outlineSurface);
draw_clear_alpha(c_black, 0);


gpu_set_blendmode(bm_normal);
draw_surface(waterSurface, 0, 0);
draw_surface(waterOverlaySurface, 0, 0);  
draw_surface(maskedReflection, 0, 0);

surface_reset_target();


shader_set(sh_outline);
shader_set_uniform_f(u_outline_texture_size, surfaceWidth, surfaceHeight);
shader_set_uniform_f(u_outline_thickness, 1.0); 
draw_surface(outlineSurface, waterLeft, waterTop);
shader_reset();