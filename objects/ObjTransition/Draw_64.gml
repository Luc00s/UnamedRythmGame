// Only draw transition effect if transition is active
if (transition_active && surface_exists(old_surface)) {
    draw_surface(application_surface, 0, 0);
    
    shader_set(shader_erase);
    
    texture_set_stage(uniform_lut, tex_lut);
    
    shader_set_uniform_f(uniform_erase_amount, erase_amount);
    
    shader_set_uniform_f(uniform_softness, softness);
    
    draw_surface(old_surface, 0, 0);
    
    shader_reset();
}