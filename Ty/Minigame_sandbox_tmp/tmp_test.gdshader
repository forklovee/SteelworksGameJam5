shader_type canvas_item;
uniform float show=0.5;

uniform sampler2D anim;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR=texture(TEXTURE,UV);
	float t=texture(anim,UV).r;
	float v=show+0.1-t;
	COLOR.a=v*10.0;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
