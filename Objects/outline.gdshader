shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(1.0, 10.0) = 2.0;
uniform bool is_active;

void fragment() {
	if (is_active) {
	    vec4 tex_color = texture(TEXTURE, UV);
	    float alpha = tex_color.a;
	    float outline_alpha = 0.0;
	    vec2 pixel_size = TEXTURE_PIXEL_SIZE * outline_width;

	    for (float x = -1.0; x <= 1.0; x++) {
	        for (float y = -1.0; y <= 1.0; y++) {
	            vec2 offset = vec2(x, y) * pixel_size;
	            float neighbor_alpha = texture(TEXTURE, UV + offset).a;
	            outline_alpha = max(outline_alpha, neighbor_alpha);
	        }
	    }

	    float outline = max(0.0, outline_alpha - alpha);
	    COLOR = tex_color + outline_color * outline;
	}
}
