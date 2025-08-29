// shd_transition.fsh
// Smooth erosion shader with edge blending for transition effects

varying vec2 v_vTexcoord;

uniform sampler2D u_sLut;         // The gradient lookup texture
uniform float u_fEraseAmount;     // The progress of the wipe (0.0 to 1.0)
uniform float u_fSoftness;        // Edge blending softness (0.0 to 1.0)

void main()
{
    // Get the original color from the game screen
    vec4 base_col = texture2D(gm_BaseTexture, v_vTexcoord);

    // Get the brightness from the lookup texture (we only need one channel)
    float lut_value = texture2D(u_sLut, v_vTexcoord).r;

    // Calculate the threshold. As EraseAmount goes from 0 to 1,
    // the threshold goes from 1 down to 0.
    float threshold = 1.0 - u_fEraseAmount;
    
    // Calculate softness range for smooth transitions
    float softness = max(0.001, u_fSoftness * 0.5);
    
    // Create smooth transition using smoothstep for edge blending
    float edge_lower = threshold - softness;
    float edge_upper = threshold + softness;
    
    // Smooth alpha transition with proper complete erasure
    float final_alpha = 1.0 - smoothstep(edge_lower, edge_upper, lut_value);
    
    // Ensure complete erasure when erase_amount reaches 1.0
    // When u_fEraseAmount is 1.0, threshold becomes 0.0
    // We need to force alpha to 0 for any lut_value above the hard threshold
    if (u_fEraseAmount >= 0.99) {
        final_alpha = step(lut_value, threshold);
    }

    // Set the final pixel color with smooth alpha blending
    gl_FragColor = vec4(base_col.rgb, final_alpha);
}