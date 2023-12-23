shader_type canvas_item;

// Parameters to control the glitch effect
uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.5; // Intensity of the glitch effect
uniform float glitch_rate : hint_range(0.0, 1.0) = 0.2; // Frequency of the glitch effect
uniform float glitch_speed = 5.0; // Speed of the glitch effect
uniform float block_size = 25.0; // Size of the blocks affected by the glitch
uniform float color_shift : hint_range(0.0, 1.0) = 0.1; // Amount of color shift

// Function to generate a pseudo-random number
float random(float seed) {
    return fract(sin(dot(vec2(seed, seed), vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Determine if the current pixel should be glitched
    float glitch_active = step(random(floor(TIME * glitch_speed)), glitch_rate);

    // Calculate the distortion
    vec2 distortion = vec2(random(floor(TIME * glitch_speed) + UV.y * block_size) - 0.5, 0.0) * glitch_intensity * glitch_active;

    // Apply distortion to UV coordinates
    vec2 uv = UV + distortion;

    // Sample the original texture
    vec4 original_color = texture(TEXTURE, uv);

    // Apply color shift
    original_color.r = texture(TEXTURE, uv + vec2(color_shift * glitch_active, 0.0)).r;
    original_color.b = texture(TEXTURE, uv - vec2(color_shift * glitch_active, 0.0)).b;

    // Output the final color
    COLOR = original_color;
}
