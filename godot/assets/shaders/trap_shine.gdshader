shader_type canvas_item;

uniform vec4 color: hint_color = vec4(1.0, .5, .5, 1.0);

void fragment() {
	COLOR = texture(TEXTURE, UV);
	float pos = sin(UV.y + TIME * 3.0);
	float strength = step(.9995, 0.5 + 0.5 * pos);
	COLOR.rgb = mix(COLOR.rgb, vec3(1, 1, 1), strength * color.rgb);
}
