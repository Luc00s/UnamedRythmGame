varying vec4 v_vColour;
varying vec2 v_vTexcoord;
varying vec3 v_vWorldPos;

uniform float u_time;
uniform float u_distortion_strength;
uniform float u_frequency;
uniform float u_speed;
uniform vec2 u_resolution;

uniform vec4 u_color;
uniform float u_caustics_frequency;
uniform float u_compress;
uniform float u_add_light;
uniform float u_scale;
uniform float u_caustics_speed;
uniform float u_x_angle;
uniform float u_y_angle;
uniform float u_refraction_ratio;
uniform float u_clear;
uniform float u_surf_sinpowder;
uniform float u_surf_speed;
uniform float u_surf_angle;
uniform float u_surf_magnitude;
uniform float u_s11;
uniform float u_sinpowder;
uniform float u_flow_direction_x;
uniform float u_flow_direction_y;
uniform float u_flow_speed;

vec2 shiftuv2(vec2 uv, float shiftratio) {
    vec2 suv = (uv - 0.5) * 2.0;
    return (suv + suv * -1.0 * shiftratio) * 0.5 + 0.5;
}

float yget(float x, float fc1, float fc2, float fc3, float fc4, float tc1, float tc2, float tc3, float tc4, float amc1, float amc2, float amc3, float amc4, float way, float addt, float freq) {
    float t = u_caustics_speed * u_time * way + addt;
    float y = sin(x * freq);

    y += pow(abs(sin(x * freq * fc1 + t * tc1)), u_sinpowder) * amc1;
    y += pow(abs(sin(x * freq * fc2 + t * tc2)), u_sinpowder) * amc2;
    y += pow(abs(sin(x * freq * fc3 + t * tc3)), u_sinpowder) * amc3;
    y += pow(abs(sin(x * freq * fc4 + t * tc4)), u_sinpowder) * amc4;
    y /= (amc1 + amc2 + amc3 + amc4);

    return y;
}

void main() {
    const float base_res = 213.0;
    float distortion_scale = u_resolution.y / base_res;
    float distortion = u_distortion_strength / distortion_scale;
    float freq = u_frequency * distortion_scale;
    
    vec2 distorted_uv = v_vTexcoord;
    float waveX = sin((distorted_uv.y * freq) + u_time * u_speed);
    float waveY = sin((distorted_uv.x * freq * 1.2) + u_time * u_speed * 1.1);
    distorted_uv.x += waveX * distortion;
    distorted_uv.y += waveY * distortion * 0.5;
    
    vec4 background = texture2D(gm_BaseTexture, distorted_uv);
    
    const float caustics_tiling = 100.0;
    vec2 base_st = v_vWorldPos.xy / caustics_tiling;
    
    float flow_animation_offset = u_time * u_flow_speed;
    
    vec2 st = base_st;
    
    float dl = distance(vec2(0.0), vec2(dFdx(st.x), dFdy(st.y)));
    vec2 st2 = base_st + dl;

    float x = st.x;
    float y = st.y;

    float surface_animation = pow(abs(sin(u_surf_speed * u_time + x * sin(u_surf_angle) + y * cos(u_surf_angle))), u_surf_sinpowder) * u_surf_magnitude;

    float scaled_caustics_frequency = u_caustics_frequency * u_scale;
    
    float a1 = (yget(distance(vec2(0.0), st), 1.30, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 4.0, 4.5, 4.0, 5.0, 2.5, 1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(0.5, 3.5), st), 1.32, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 4.269, 4.5, 4.0, 5.0, 2.5, -1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(4.5, -4.5), st), 1.31, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 4.269, 4.5, 4.0, 5.0, 2.5, 1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(-5.5, -2.5), st), 1.27, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 5.0, 4.5, 4.0, 5.0, 2.5, -1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(-7.5, 3.5), st), 1.25, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 5.0, 4.5, 4.0, 5.0, 2.5, 1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(3.25, 3.25), st), 1.34, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 4.269, 4.5, 4.0, 5.0, 2.5, 1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(6.25, -4.25), st), 1.36, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 4.269, 4.5, 4.0, 5.0, 2.5, -1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(-7.25, -1.25), st), 1.27, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 5.0, 4.5, 4.0, 5.0, 2.5, 1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(-0.25, 5.25), st), 1.59, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 5.0, 4.5, 4.0, 5.0, 2.5, -1.0, flow_animation_offset, scaled_caustics_frequency)) / 9.0;

    float a2 = (yget(distance(vec2(0.0), st2), 1.30, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 4.0, 4.5, 4.0, 5.0, 2.5, 1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(0.5, 3.5), st2), 1.32, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 4.269, 4.5, 4.0, 5.0, 2.5, -1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(4.5, -4.5), st2), 1.31, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 4.269, 4.5, 4.0, 5.0, 2.5, 1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(-5.5, -2.5), st2), 1.27, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 5.0, 4.5, 4.0, 5.0, 2.5, -1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(-7.5, 3.5), st2), 1.25, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 5.0, 4.5, 4.0, 5.0, 2.5, 1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(3.25, 3.25), st2), 1.34, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 4.269, 4.5, 4.0, 5.0, 2.5, 1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(6.25, -4.25), st2), 1.36, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 4.269, 4.5, 4.0, 5.0, 2.5, -1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(-7.25, -1.25), st2), 1.27, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 5.0, 4.5, 4.0, 5.0, 2.5, 1.0, flow_animation_offset, scaled_caustics_frequency)
        + yget(distance(vec2(-0.25, 5.25), st2), 1.59, 1.72, u_s11, 3.1122, 1.0, 1.121, 0.437, 5.0, 4.5, 4.0, 5.0, 2.5, -1.0, flow_animation_offset, scaled_caustics_frequency)) / 9.0;

    float da = clamp((a2 - a1) * u_compress, 0.0, 1.0);
    float ang = atan(da / dl);

    vec2 refracted_uv = shiftuv2(v_vTexcoord, ang * u_refraction_ratio);
    vec4 refracted_background = texture2D(gm_BaseTexture, refracted_uv);

    float caustics_intensity = ((sin(ang - 3.14159 * 0.5 + u_y_angle) + cos(ang - 3.14159 * 1.5 + u_x_angle)) + surface_animation) / 1.5;
    
    float layer4_threshold = 0.99;
    float layer3_threshold = 0.59;
    float layer2_threshold = 0.5;
    float layer1_threshold = 0.1;
    
    vec3 white_layer = vec3(1.0, 1.0, 1.0);
    vec3 light_blue_layer = vec3(0.7, 0.9, 1.0);
    vec3 medium_blue_layer = vec3(0.4, 0.7, 1.0);
    vec3 dark_blue_layer = vec3(0.15, 0.4, 0.7);
    vec3 transparent_dark_layer = vec3(0.12, 0.3, 0.6);

    vec4 final_color = background;
    
    if (caustics_intensity > layer4_threshold) {
        vec3 caustics_tint = white_layer * (1.0 + u_add_light);
        final_color.rgb = final_color.rgb * caustics_tint;
    } else if (caustics_intensity > layer3_threshold) {
        vec3 caustics_tint = light_blue_layer * (1.0 + u_add_light);
        final_color.rgb = final_color.rgb * caustics_tint;
    } else if (caustics_intensity > layer2_threshold) {
        vec3 caustics_tint = medium_blue_layer * (1.0 + u_add_light);
        final_color.rgb = final_color.rgb * caustics_tint;
    } else if (caustics_intensity > layer1_threshold) {
        vec3 caustics_tint = dark_blue_layer * (1.0 + u_add_light);
        final_color.rgb = final_color.rgb * caustics_tint;
    } else {
        float gradient_factor = smoothstep(0.0, layer1_threshold, caustics_intensity);
        vec3 gradient_color = mix(transparent_dark_layer, dark_blue_layer, gradient_factor);
        vec3 caustics_tint = gradient_color * (1.0 + u_add_light);
        final_color.rgb = final_color.rgb * caustics_tint;
    }
    
    final_color.a = 1.0;

    gl_FragColor = final_color * v_vColour;
}
