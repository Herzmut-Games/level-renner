shader_type canvas_item;

uniform float strength = 0.75;

void fragment() {
	// get the color of the current fragment 
	vec4 color = texture(TEXTURE, UV);

	// return if the fragment is see-through
	if (color.a == 0.0) return;

	// invert the RGB values of the color
	COLOR.rgb = vec3(strength) - color.rgb;
}
