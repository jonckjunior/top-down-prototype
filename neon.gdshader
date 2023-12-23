shader_type canvas_item;

uniform float neon_intensity : hint_range(0.0, 3.0) = 1.0;
uniform vec4 neon_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);  // Green neon color
uniform float neon_radius : hint_range(0.1, 2.0) = 0.5;  // Control the distance of the glow
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.1;  // Alpha threshold to ignore transparent pixels

void vertex() {
    // No changes to the vertex shader for this example
}

void fragment() {
    // Sample the original scene texture
    vec4 original_color = texture(TEXTURE, UV);

    // Check if the pixel is not transparent
    if (true) {
        // Calculate the UV coordinates relative to the center of the object
        vec2 center_uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE - 0.5;
        float distance_to_center = length(center_uv);

        // Apply smooth falloff based on distance to the center with a user-defined radius
        float falloff = smoothstep(neon_radius, neon_radius - 0.1, 1.0 - distance_to_center);

        // Apply pulsating effect
        float pulsate = 0.5 + 0.5 * sin(TIME * 2.0);

        // Apply the neon effect with falloff and pulsation
        vec4 neon = neon_intensity * neon_color * falloff * pulsate;

        // Add a subtle noise texture for a sparkling effect
        float noise_intensity = 0.02;  // Adjust the intensity of the noise
        float noise = noise_intensity * (fract(sin(dot(UV, vec2(12.9898, 78.233))) * 43758.5453));

        // Combine the original color with the neon effect and noise
        vec4 final_color = original_color + neon + vec4(noise);

        // Output the final color
        COLOR = final_color;
    } else {
        // If transparent, keep the original color
        COLOR = original_color;
    }
}
