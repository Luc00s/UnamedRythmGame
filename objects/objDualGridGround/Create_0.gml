


var layer_id     = layer_get_id("Ground");
tilemap_ground   = layer_tilemap_get_id(layer_id);
if (tilemap_ground == -1) {
    show_error("Tilemap ‘Ground’ not found", false);
}


cell_size        = tilemap_get_tile_width(tilemap_ground);
cell_half        = cell_size * 0.5;


world_cols       = tilemap_get_width(tilemap_ground);
world_rows       = tilemap_get_height(tilemap_ground);


sheet_cols       = sprite_get_width(SprGrassTile) div cell_size;
sheet_rows       = sprite_get_height(SprGrassTile) div cell_size;


world_grid       = ds_grid_create(world_cols,     world_rows);
display_grid     = ds_grid_create(world_cols + 1, world_rows + 1);


for (var cx = 0; cx < world_cols; cx++) {
    for (var cy = 0; cy < world_rows; cy++) {
        var data = tilemap_get(tilemap_ground, cx, cy);
        world_grid[# cx, cy] = tile_get_empty(data) ? 0 : 1;
    }
}


var tile_index_map = array_create(16);
tile_index_map[0]  = 6;
tile_index_map[1]  = 7;
tile_index_map[2]  = 10;
tile_index_map[3]  = 9;
tile_index_map[4]  = 2;
tile_index_map[5]  = 11;
tile_index_map[6]  = 4;
tile_index_map[7]  = 15;
tile_index_map[8]  = 5;
tile_index_map[9]  = 14;
tile_index_map[10] = 1;
tile_index_map[11] = 8;
tile_index_map[12] = 3;
tile_index_map[13] = 0;
tile_index_map[14] = 13;
tile_index_map[15] = 12;


for (var ix = 0; ix <= world_cols; ix++) {
    for (var iy = 0; iy <= world_rows; iy++) {
        var tl = (ix > 0           && iy > 0          ) ? world_grid[# ix-1, iy-1] : 0;
        var tr = (ix < world_cols  && iy > 0          ) ? world_grid[# ix,   iy-1] : 0;
        var bl = (ix > 0           && iy < world_rows ) ? world_grid[# ix-1, iy  ] : 0;
        var br = (ix < world_cols  && iy < world_rows ) ? world_grid[# ix,   iy  ] : 0;
        var raw = tl*8 + tr*4 + bl*2 + br*1;
        var inverted = 15 - raw;
        display_grid[# ix, iy] = tile_index_map[inverted];
    }
}

depth = 0;


rendered_surface = -1;
surface_valid = false;
surface_width = world_cols * cell_size;
surface_height = world_rows * cell_size;


#region Shader Setup

tex_overlay = sprite_get_texture(SprGrassTexture, 0); 


var _overlay_tex_size = sprite_get_width(SprGrassTexture); 
shader_overlay_scale = 1.0 / _overlay_tex_size;


unf_overlay_sampler = shader_get_sampler_index(shd_world_overlay, "u_samOverlay");
unf_overlay_scale   = shader_get_uniform(shd_world_overlay, "u_fScale");
unf_camera_pos      = shader_get_uniform(shd_world_overlay, "u_vCamPos");

#endregion