#version 330 core

// Input vertex data, different for all executions of this shader.
layout(location = 0) in vec3 vertex;
layout(location = 1) in vec3 normal;

// Output data ; will be interpolated for each fragment.
out vec3 fragmentColor;
out vec4 fragmentNormal;

// Values that stay constant for the whole mesh.
uniform mat4 MVP;
uniform mat4 normalMat;
uniform vec3 color;

void main() {

	// Output position of the vertex, in clip space : MVP * position
	gl_Position =  MVP * vec4(vertex, 1);

	fragmentNormal = normalMat * vec4(normal, 0);
	fragmentColor = color;
}
