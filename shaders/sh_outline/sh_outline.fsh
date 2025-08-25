varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_texture_size;
uniform float u_outline_thickness;

void main()
{
    vec2 texel = 1.0 / u_texture_size;
    vec4 current_color = texture2D(gm_BaseTexture, v_vTexcoord);
    
    if (current_color.a > 0.0) {
        vec2 above = v_vTexcoord + vec2(0.0, -1.0) * texel;
        
        if (above.y < 0.0) {
            gl_FragColor = vec4(1.0, 1.0, 1.0, 0.5);
        } else {
            vec4 above_color = texture2D(gm_BaseTexture, above);
            if (above_color.a == 0.0) {
                gl_FragColor = vec4(1.0, 1.0, 1.0, 0.5);
            } else {
                gl_FragColor = current_color;
            }
        }
    }
    else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
}
