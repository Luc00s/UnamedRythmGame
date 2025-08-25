


waterSurface = -1;
backgroundSurface = -1;
distortedTemp = -1;
maskedReflection = -1;
reflectionTemp = -1;
outlineSurface = -1;

surfaceWidth = sprite_get_width(sprite_index)*abs(image_xscale);
surfaceHeight = sprite_get_height(sprite_index)*abs(image_yscale);

shaderTime = 0;
distortionStrength = 0.04; 
waveSpeed = 4.0;
waveFrequency = 6.0;
waterOverlaySurface = -1;


u_time_reflection = shader_get_uniform(sh_reflection, "u_time");
u_distortionStrength = shader_get_uniform(sh_reflection, "u_distortionStrength");
u_waveSpeed = shader_get_uniform(sh_reflection, "u_waveSpeed");
u_waveFrequency = shader_get_uniform(sh_reflection, "u_waveFrequency");


u_color = shader_get_uniform(sh_water, "u_color");
u_caustics_frequency = shader_get_uniform(sh_water, "u_caustics_frequency");
u_compress = shader_get_uniform(sh_water, "u_compress");
u_add_light = shader_get_uniform(sh_water, "u_add_light");
u_scale = shader_get_uniform(sh_water, "u_scale");
u_caustics_speed = shader_get_uniform(sh_water, "u_caustics_speed");
u_x_angle = shader_get_uniform(sh_water, "u_x_angle");
u_y_angle = shader_get_uniform(sh_water, "u_y_angle");
u_refraction_ratio = shader_get_uniform(sh_water, "u_refraction_ratio");
u_clear = shader_get_uniform(sh_water, "u_clear");
u_surf_sinpowder = shader_get_uniform(sh_water, "u_surf_sinpowder");
u_surf_speed = shader_get_uniform(sh_water, "u_surf_speed");
u_surf_angle = shader_get_uniform(sh_water, "u_surf_angle");
u_surf_magnitude = shader_get_uniform(sh_water, "u_surf_magnitude");
u_s11 = shader_get_uniform(sh_water, "u_s11");
u_sinpowder = shader_get_uniform(sh_water, "u_sinpowder");
u_flow_direction_x = shader_get_uniform(sh_water, "u_flow_direction_x");
u_flow_direction_y = shader_get_uniform(sh_water, "u_flow_direction_y");
u_flow_speed = shader_get_uniform(sh_water, "u_flow_speed");
u_world_offset = shader_get_uniform(sh_water, "u_world_offset");


sh_water_u_time = shader_get_uniform(sh_water, "u_time");
sh_water_u_distortion_strength = shader_get_uniform(sh_water, "u_distortion_strength");
sh_water_u_frequency = shader_get_uniform(sh_water, "u_frequency");
sh_water_u_speed = shader_get_uniform(sh_water, "u_speed");
sh_water_u_resolution = shader_get_uniform(sh_water, "u_resolution");


u_outline_texture_size = shader_get_uniform(sh_outline, "u_texture_size");
u_outline_thickness = shader_get_uniform(sh_outline, "u_outline_thickness");


tileMaskSurface = -1;
tileMaskValid = false;  
lastWaterX = x;         
lastWaterY = y;
lastWaterScaleX = image_xscale;
lastWaterScaleY = image_yscale;



causticsColor = [0.1, 0.6, 1.0, 0.6]; 
causticsFrequency = 3.5;
causticsCompress = 3.5; 
causticsAddLight = 1; 
causticsScale = 1.5; 
causticsSpeed = .25;
causticsXAngle = 1.57;
causticsYAngle = 1.57;
causticsRefractionRatio = 10.0;
causticsClear = 0.0;
causticsSurfSinpowder = 8.0;
causticsSurfSpeed = .01; 
causticsSurfAngle = 1.57;
causticsSurfMagnitude = 0.0; 
causticsS11 = 2.221;
causticsSinpowder = 6.0; 


causticsFlowDirectionX = 1.0; 
causticsFlowDirectionY = 0.5; 
causticsFlowSpeed = 0.3; 




function createWaterSurface() {
    if (surface_exists(waterSurface)) {
        surface_free(waterSurface);
    }
    waterSurface = surface_create(surfaceWidth, surfaceHeight);
}

function createBackgroundSurface() {
    if (surface_exists(backgroundSurface)) {
        surface_free(backgroundSurface);
    }
    backgroundSurface = surface_create(surfaceWidth, surfaceHeight);
}

function createOutlineSurface() {
    if (surface_exists(outlineSurface)) {
        surface_free(outlineSurface);
    }
    outlineSurface = surface_create(surfaceWidth, surfaceHeight);
}

function createTileMaskSurface() {
    if (surface_exists(tileMaskSurface)) {
        surface_free(tileMaskSurface);
    }
    tileMaskSurface = surface_create(surfaceWidth, surfaceHeight);
}

createWaterSurface();
createBackgroundSurface();
createOutlineSurface();
createTileMaskSurface();

