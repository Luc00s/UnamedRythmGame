application_surface_draw_enable(false);

shader_erase = sh_transition;

uniform_lut = shader_get_sampler_index(shader_erase, "u_sLut");
uniform_erase_amount = shader_get_uniform(shader_erase, "u_fEraseAmount");
uniform_softness = shader_get_uniform(shader_erase, "u_fSoftness");

tex_lut = sprite_get_texture(sprTransition, 0);

erase_amount = 0;      
erase_speed = 0.025;   
softness = 0.1;       

transition_active = false;     
old_surface = -1;             
target_room = -1;             

