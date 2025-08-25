
/// @description Clean up
if (ds_exists(world_grid,   ds_type_grid))    ds_grid_destroy(world_grid);
if (ds_exists(display_grid, ds_type_grid))    ds_grid_destroy(display_grid);


if (surface_exists(rendered_surface)) surface_free(rendered_surface);
