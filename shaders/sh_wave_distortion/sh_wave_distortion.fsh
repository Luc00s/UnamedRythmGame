varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;
uniform float u_intensity;
uniform float u_frequency;

void main()
{
    vec2 texCoord = v_vTexcoord;
    
    float wave = sin(texCoord.y * u_frequency + u_time) * u_intensity;
    texCoord.x += wave;
    
    vec4 texColor = texture2D(gm_BaseTexture, texCoord);
    
    gl_FragColor = v_vColour * texColor;
}
