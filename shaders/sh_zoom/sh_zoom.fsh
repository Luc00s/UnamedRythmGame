varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_zoom;

void main()
{
    vec2 center = vec2(0.5, 0.5);
    
    vec2 texCoord = center + (v_vTexcoord - center) / u_zoom;
    
    texCoord = fract(texCoord);
    
    vec4 texColor = texture2D(gm_BaseTexture, texCoord);
    gl_FragColor = v_vColour * texColor;
}
