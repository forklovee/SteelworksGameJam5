shader_type canvas_item;
uniform float d=0.5;



float random (int a) {
    return fract(sin(dot(vec2(float(a)*1.4+0.5,float(a)*0.6),
                         vec2(12.9898,78.233)))*
        43758.5453123);
}




void vertex() {
	// Called for every vertex the material is visible on.
}



void fragment() {
	
	vec2 uv2=vec2(0.5,0.5)+(5.0-d*4.0)*(UV-vec2(0.5,0.5));
	
	vec2 a[20];
	for(int i=0;i<20;i++){
		a[i]=vec2(random(2*i),random(2*i+1)); 
	}
	float dist=1000.0;
	vec2 p2=a[0];
	vec2 p=a[0];
	
	for(int i=0;i<20;i++){
		if(distance(a[i],uv2)<distance(p,uv2)){
			p2=p;
			p=a[i];
		}
	}
	
	if(distance(p,uv2)<distance(p2,uv2)-d)
	{
		COLOR=texture(TEXTURE,uv2);
		//COLOR=vec4(p.x,0.0,0.0,1.0)+texture(TEXTURE,uv2);
		if (uv2!=clamp(uv2,vec2(0.0,0.0),vec2(1.0,1.0))){
			COLOR=vec4(0.0);
		}
	}
	else{
		COLOR=vec4(0.0);
	}
	

	//vec4(1.0,0.0,0.0,1.0);
	
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
