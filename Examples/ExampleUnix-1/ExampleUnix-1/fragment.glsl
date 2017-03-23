#version 330 core

// Interpolated values from the vertex shaders
in vec4 fragmentNormal;
in vec3 fragmentToCamera;
in vec3 fragmentColor;

// Ouput data
out vec3 color;

void main() {

	vec3 light = normalize(vec3(0.4, 0.3, 0.5));
	vec3 normal = normalize(fragmentNormal.xyz);
	vec3 toCamera = normalize(fragmentToCamera);

	float diffuse = clamp(dot(light, normal), 0, 1);

	float specular = 0;
	if(dot(normal, light) > 0) {
		// half vector
		vec3 halfVector = normalize(light + toCamera);
		specular = pow(dot(normal, halfVector), 200);
	}

	color = fragmentColor +
		vec3(diffuse, diffuse, diffuse) * 0.3 +
		vec3(specular, specular, specular);
}
