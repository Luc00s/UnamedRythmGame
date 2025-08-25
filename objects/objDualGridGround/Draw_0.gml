


/// @description Optimized rendering with surface caching, view culling, and shader

function updateRenderedSurface() {
    
    if (!surface_exists(rendered_surface)) {
        rendered_surface = surface_create(surface_width, surface_height);
    }
    
    surface_set_target(rendered_surface);
    draw_clear_alpha(c_black, 0);
    
    
    
    shader_set(shd_world_overlay);
    
    
    texture_set_stage(unf_overlay_sampler, tex_overlay);
    
    
    shader_set_uniform_f(unf_overlay_scale, shader_overlay_scale);
    
    
    
    
    shader_set_uniform_f(unf_camera_pos, 0, 0);
    
    
    gpu_set_tex_repeat(true);
    
    
    for (var ix = 1; ix < world_cols; ix++) {
        for (var iy = 1; iy < world_rows; iy++) {
            var idx = display_grid[# ix, iy];
            
            
            var dx = ix * cell_size - cell_half - cell_half; 
            var dy = iy * cell_size - cell_half - cell_half; 
            
            
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
                dx, dy         
            );
        }
    }
    
    
    
    gpu_set_tex_repeat(false);
    shader_reset();

    
    surface_reset_target();
    surface_valid = true;
}




if (!surface_valid || !surface_exists(rendered_surface)) {
    updateRenderedSurface();
}


var camera = view_camera[0];
var cam_x = camera_get_view_x(camera);
var cam_y = camera_get_view_y(camera);
var cam_w = camera_get_view_width(camera);
var cam_h = camera_get_view_height(camera);


var overlap_left = max(0, cam_x);
var overlap_top = max(0, cam_y);
var overlap_right = min(surface_width, cam_x + cam_w);
var overlap_bottom = min(surface_height, cam_y + cam_h);

var overlap_width = overlap_right - overlap_left;
var overlap_height = overlap_bottom - overlap_top;


if (overlap_width > 0 && overlap_height > 0) {
    
    
    draw_surface_part(
        rendered_surface,
        overlap_left, overlap_top,    
        overlap_width, overlap_height, 
        overlap_left, overlap_top     
    );
}