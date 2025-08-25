
/// @description Draw GUI - Handle zoom and spin effects on application surface

var _app_surf = application_surface;
var _has_zoom = (global_zoom_level != 1.0);
var _has_spin = (global_spin_angle != 0);

if (surface_exists(_app_surf)) {
    var _app_width = surface_get_width(_app_surf);
    var _app_height = surface_get_height(_app_surf);
    
    if (_has_zoom && _has_spin) {
        ensure_effect_surfaces(_app_width, _app_height);
        
        if (surface_exists(effect_surfaces[0])) {
            surface_set_target(effect_surfaces[0]);
            draw_clear_alpha(c_black, 0);
            shader_set(sh_zoom);
            shader_set_uniform_f(shader_get_uniform(sh_zoom, "u_zoom"), global_zoom_level);
            draw_surface(_app_surf, 0, 0);
            shader_reset();
            surface_reset_target();
            
            shader_set(sh_spin);
            shader_set_uniform_f(shader_get_uniform(sh_spin, "u_angle"), degtorad(global_spin_angle));
            shader_set_uniform_f(shader_get_uniform(sh_spin, "u_resolution"), _app_width, _app_height);
            draw_surface(effect_surfaces[0], 0, 0);
            shader_reset();
        }
        
    } else if (_has_zoom) {
        shader_set(sh_zoom);
        shader_set_uniform_f(shader_get_uniform(sh_zoom, "u_zoom"), global_zoom_level);
        draw_surface(_app_surf, 0, 0);
        shader_reset();
        
    } else if (_has_spin) {
        shader_set(sh_spin);
        shader_set_uniform_f(shader_get_uniform(sh_spin, "u_angle"), degtorad(global_spin_angle));
        shader_set_uniform_f(shader_get_uniform(sh_spin, "u_resolution"), _app_width, _app_height);
        draw_surface(_app_surf, 0, 0);
        shader_reset();
    }
}
