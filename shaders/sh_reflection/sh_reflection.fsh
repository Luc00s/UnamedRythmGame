varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vWorldPos;

uniform float u_time;
uniform float u_distortionStrength;
uniform float u_waveSpeed;
uniform float u_waveFrequency;

void main()
{
    vec2 distortedCoord = v_vTexcoord;
    
    float horizontalWave = cos(v_vWorldPos.y * u_waveFrequency + u_time * u_waveSpeed) * u_distortionStrength;
    
    distortedCoord.x += horizontalWave;
    
    distortedCoord = clamp(distortedCoord, 0.0, 1.0);
    
    vec4 texColor = texture2D(gm_BaseTexture, distortedCoord);
    
    gl_FragColor = v_vColour * texColor;
}
