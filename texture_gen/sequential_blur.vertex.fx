precision highp float;

// Uniforms
uniform mat4 worldViewProjection;
uniform vec2 iResolution;

attribute vec2 uv;

// Vertex attributes
attribute vec3 position;

varying vec2 vUV;
varying vec3 p;


void main(void) {
    gl_Position = worldViewProjection * vec4(position, 1.0);
    vUV = uv;
    p = position;
}