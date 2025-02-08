shader_type spatial;

//THIS SHADER IS A TOON SHADER FOR THE MAIN BALL
//IT ADDS A BANDED SHADOW EFFECT ONTO THE BALL AND COLORS IT WHITE
//IT ALSO ADDS A BLACK AND WHITE OUTLINE EFFECT

uniform vec4 ball_color : source_color = vec4(1.0);

uniform vec4 outer_outline_color : source_color = vec4(1.0);
uniform vec4 inner_outline_color : source_color = vec4(0.0);

const vec3 cam_pos = vec3(0,0,4.5);
varying vec3 frag_pos_in_world;

uniform float lower_band_limit : hint_range(-1.0, 0.0) = -0.5;
uniform float upper_band_limit : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	// Called for every pixel the material is visible on.
	
	//VERTEX gets the fragments coordinates in view space.
	//the INV_VIEW_MATRIX converts that to world coordinates.
	vec4 world_pos = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	frag_pos_in_world = world_pos.xyz;
}


//Determines the strength of the three different shadow bands
//Complete shadow 1.0
//No Shadow 0.0
//Half shadow 0.5
float round_to_band(float n) {
	if (n > upper_band_limit) {return 1.0;}
	if (n < lower_band_limit) {return 0.0;}
	return 0.5;
	}


void light() {
	 //Called for every pixel for every light affecting the material.
	 //Uncomment to replace the default light processing function with this one.
	
	
	//The directional vector from the pixel to the camera's position.
	//This is needed so that the outline is rendered facing the camera.
	vec3 dir = vec3(cam_pos.x - frag_pos_in_world.x, 
	cam_pos.y - frag_pos_in_world.y, 
	cam_pos.z - frag_pos_in_world.z);
	dir = normalize(dir);
	
	//The angle between the directional vector the the pixel's normal vector.
	//This is used to determine whether or not a pixel is along the edge, and so should be
	//considered part the outline or not.
	//Value ranges from -1 to 1, where 1 points towards the camera
	//-1 points away from the camera
	//0 is perpendicular to the camera
	float a = dot(NORMAL, dir);
	
	if (a < 0.4) {DIFFUSE_LIGHT = inner_outline_color.rgb;}
	if (a < 0.2) {DIFFUSE_LIGHT = outer_outline_color.rgb;}
	if (a > 0.4) {
			//Determines the shadows strength based on the angle between the
			//normal vector of the pixel and the direction of the light source
			float shadow_strength = dot(NORMAL, LIGHT);
			shadow_strength = round_to_band(shadow_strength);
			DIFFUSE_LIGHT = ball_color.rgb * shadow_strength;
	}

}
