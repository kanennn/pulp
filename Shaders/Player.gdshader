shader_type canvas_item;

uniform sampler2D pixelShader;
uniform sampler2D erosion : repeat_enable;
uniform float deterioration : hint_range(0.0, 1.85);
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
	
	float pixelSize = 1.0; 
	
	ivec2 size = textureSize(TEXTURE,0);
	
	int xRes = size.r;
	int yRes = size.g;
	
	float xFactor = float(xRes) / pixelSize;
	float yFactor = float(yRes) / pixelSize;
	
	float gridUvX = round(UV.x * xFactor + .5) / xFactor;
	float gridUvY = round(UV.y * yFactor + .5) / yFactor;
	
	vec4 pErosion = texture(erosion, vec2(gridUvX, gridUvY));
	
	float erosion_min = (deterioration * 0.5);
	float erosion_max = erosion_min + .15;
	float erosion_val = smoothstep(erosion_min, erosion_max, pErosion.r);
	

	COLOR.a *= erosion_val;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
