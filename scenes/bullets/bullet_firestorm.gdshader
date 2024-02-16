shader_type canvas_item;

uniform vec4 NEWCOLOR: source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 old_color = texture(TEXTURE, UV);
	if (old_color.a != 0.0) {
		COLOR = NEWCOLOR;
	} else {
		COLOR = old_color;
	}
}
