varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_angle;
uniform vec2 u_resolution;

void main()
{
    vec2 center = vec2(0.5, 0.5);
    
    float aspect = u_resolution.x / u_resolution.y;
    
    vec2 coord = v_vTexcoord - center;
    
    coord.x *= aspect;
    
    float cosA = cos(u_angle);
    float sinA = sin(u_angle);
    
    vec2 rotatedCoord;
    rotatedCoord.x = coord.x * cosA - coord.y * sinA;
    rotatedCoord.y = coord.x * sinA + coord.y * cosA;
    
    rotatedCoord.x /= aspect;
    
    vec2 finalCoord = rotatedCoord + center;
    
    finalCoord = mod(finalCoord, 1.0);
    
    vec4 texColor = texture2D(gm_BaseTexture, finalCoord);
    gl_FragColor = v_vColour * texColor;
}