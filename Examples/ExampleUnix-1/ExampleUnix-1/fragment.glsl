#version 330 core

// Interpolated values from the vertex shaders
in vec3 fragmentColor;
in vec4 fragmentNormal;

// Ouput data
out vec3 color;

void main() {

	vec3 light = normalize(vec3(0.4, 0.3, 0.5));
	vec3 normal = normalize(fragmentNormal.xyz);
	float diffuse = clamp(dot(light, normal), 0, 1);
	color = fragmentColor + vec3(diffuse, diffuse, diffuse);
}
