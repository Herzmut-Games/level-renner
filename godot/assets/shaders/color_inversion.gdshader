shader_type canvas_item;

uniform float strength = 0.75;

void fragment() {
	// set the color to its default texture value
	COLOR = texture(TEXTURE, UV);

	// invert the RGB values of the color
	COLOR.rgb = vec3(strength) - COLOR.rgb;
}
