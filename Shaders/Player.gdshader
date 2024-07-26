shader_type canvas_item;

uniform sampler2D erosion : repeat_enable;
uniform float deterioration : hint_range(-.2, 1.85);
uniform bool isShadow = false;

void vertex() {
	UV = UV;
	
	if (isShadow == true) {
		if (VERTEX.g < 0.0) {
			VERTEX += vec2(6.0, 2.0); 
		}
	}
}

void fragment() {
	if (isShadow == true) {
		COLOR.rgb = vec3(0.0, 0.0, 0.0);
	} 
	
	vec4 erosion_tex = texture(erosion, UV);
	
	float erosion_min = (deterioration * 0.5);
	float erosion_max = erosion_min + .01;
	float erosion_val = smoothstep(erosion_min, erosion_max, erosion_tex.r);
	
	COLOR.a *= erosion_val;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
