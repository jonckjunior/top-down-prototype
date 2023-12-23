shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform vec2 scroll = vec2(0.05, 0.05);


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 noise_col = texture(noise, UV + scroll * TIME);
	COLOR = noise_col;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
