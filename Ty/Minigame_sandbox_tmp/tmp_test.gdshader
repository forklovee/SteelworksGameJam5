shader_type canvas_item;
uniform float show=0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR=texture(TEXTURE,UV);
	COLOR.a=show;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
