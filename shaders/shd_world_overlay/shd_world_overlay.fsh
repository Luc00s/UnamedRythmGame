varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D u_samOverlay;
uniform float u_fScale;
uniform vec2 u_vCamPos;

void main()
{
    vec4 original_color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );

    float mix_amount = floor(original_color.r);
    
    vec2 world_position = u_vCamPos + gl_FragCoord.xy;

    vec4 overlay_color = texture2D(u_samOverlay, world_position * u_fScale);
    
    gl_FragColor = mix(original_color, overlay_color, mix_amount);
}