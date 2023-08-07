uniform:

A uniform variable is a constant value that remains the same for all vertices or fragments within a rendering pass.
It is typically used to pass data from the application (CPU) to the shader (GPU).
In BabylonJS or other WebGL frameworks, you can set the value of uniform variables from JavaScript before rendering a frame, and it remains constant during that frame's rendering process.
For example, you can use uniform to pass transformation matrices, texture data, time, and other constants that do not change per vertex or fragment.

varying:

A varying variable is used to interpolate values across vertices in the vertex shader and then pass them to the fragment shader.
In the vertex shader, you compute the varying value for each vertex, and then the value is automatically interpolated across the surface of the primitive (triangle) and passed to the fragment shader for each fragment within that triangle.
It is useful when you need to pass values smoothly across the surface of a primitive, like texture coordinates, color information, or any other data that varies per vertex but needs to be consistent per fragment within a primitive.