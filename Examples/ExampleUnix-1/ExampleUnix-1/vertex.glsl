#version 330 core

// Input vertex data, different for all executions of this shader.
layout(location = 0) in vec3 vertex;
layout(location = 1) in vec3 normal;

// Output data ; will be interpolated for each fragment.
out vec4 fragmentNormal;
out vec3 fragmentToCamera;
out vec3 fragmentColor;

// Values that stay constant for the whole mesh.
uniform mat4 modelMatrix;
uniform mat4 viewProjectionMatrix;
uniform mat4 normalMatrix;
uniform vec3 cameraPosition;
uniform vec3 color;

void main() {

	vec4 modelPosition = vec4(vertex, 1);
	vec4 worldPosition = modelMatrix * modelPosition;

	mat4 MVP = viewProjectionMatrix * modelMatrix;

	fragmentNormal = normalMatrix * vec4(normal, 0);
	fragmentToCamera = normalize(cameraPosition - worldPosition.xyz);
	fragmentColor = color;

	// Output position of the vertex, in clip space : MVP * position
	gl_Position =  MVP * modelPosition;
}
